import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_task_2/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:lg_task_2/entities/kml.dart';
import 'package:lg_task_2/entities/screen_overlay.dart';
import 'package:lg_task_2/kml/kml1.dart';
import 'package:lg_task_2/kml/kml2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _password;
  late String _noOfRigs;
  SSHClient? _client;

  SSHClient? get client => _client;

  int get leftScreen {
    final rigs = int.tryParse(_noOfRigs);
    if (rigs == null || rigs <= 0) {
      return 1;
    }
    if (rigs == 1) {
      return 1;
    }
    return (rigs / 2).floor() + 2;
  }

  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _password = prefs.getString('password') ?? 'lg';
    _noOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG() async {
    await initConnectionDetails();

    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _password,
      );

      return true;
    } on SocketException catch (e) {
      return false;
    }
  }

  Future<void> disconnectFromLG() async {
    try {
      if (_client != null) {
        await _client!.done;
        _client = null;
      }
    } catch (e) {
      print("Error disconnecting from LG: $e");
    }
  }

  Future<void> relaunchLG() async {
    try {
      if (_client == null) return;

      for (var i = 1; i <= int.parse(_noOfRigs); i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo $_password | sudo -S service \\\${SERVICE} start
          else
            echo $_password | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p $_password ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _client?.run(cmd);
      }
    } catch (e) {
      print('Failed to relaunch LG: $e');
    }
  }

  Future<void> clearKML() async {
    try {
      if (_client == null) return;

      await _client?.run('echo "" > /tmp/query.txt');
      await _client?.run("echo '' > /var/www/html/kmls.txt");
      print('KML cleared');
    } catch (e) {
      print('Failed to clean KML: $e');
    }
  }

  Future<void> sendKML1(
      BuildContext context, SSHClient _client, String kmlString) async {
    try {
      if (_client == null) {
        context.read<TimelineBloc>().add(
              AddTimelineStep(step: "Error: SSH client not initialized"),
            );
        return;
      }

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "7 Wonders KML Loading."),
          );
      await _client.run('mkdir -p /var/www/html/kmls');

      final sftp = await _client.sftp();
      final sftpFile = await sftp.open('/var/www/html/kmls/seven_wonders.kml',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      final kmlStream =
          Stream.fromIterable([Uint8List.fromList(utf8.encode(kmlString))]);
      await sftpFile.write(kmlStream);
      await sftpFile.close();

      await _client.run(
          'echo "http://lg1:81/kmls/seven_wonders.kml" > /var/www/html/kmls.txt');

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Initializing tour..."),
          );
      await Future.delayed(const Duration(seconds: 2));
      await _client.run('echo "playtour=World Wonders Tour" > /tmp/query.txt');

      // Parse KML and extract names & wait durations from ExtendedData
      final document = xml.XmlDocument.parse(kmlString);
      final placemarks = document.findAllElements('Placemark');

      List<Map<String, dynamic>> tourStops = [];

      for (var placemark in placemarks) {
        final nameElement = placemark.findElements('name').first;
        final name = nameElement.text;

        final extendedData = placemark.findElements('ExtendedData');
        final waitDurationElement = extendedData
            .expand((data) => data.findElements('Data'))
            .where((data) => data.getAttribute('name') == 'wait_duration')
            .map((data) => data.findElements('value').first.text)
            .firstOrNull;

        final waitDuration = waitDurationElement != null
            ? double.tryParse(waitDurationElement) ?? 5.0
            : 5.0;

        tourStops.add({'name': name, 'duration': waitDuration});
      }

      // Iterate through stops with their wait duration
      for (var stop in tourStops) {
        context.read<TimelineBloc>().add(
              AddTimelineStep(step: "Visiting ${stop['name']}..."),
            );
        await Future.delayed(Duration(seconds: stop['duration'].toInt()));
      }

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Finalizing tour..."),
          );
      await _client.run('echo "exittour=true" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 2));
      await _client.run('rm /var/www/html/kmls/seven_wonders.kml');
      await _client.run('echo "" > /var/www/html/kmls.txt');

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Tour completed successfully"),
          );
    } catch (e) {
      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Error during tour: $e"),
          );
      try {
        await _client.run('echo "exittour=true" > /tmp/query.txt');
        await _client.run('rm /var/www/html/kmls/seven_wonders.kml');
        await _client.run('echo "" > /var/www/html/kmls.txt');
        print('Cleanup completed after error');
      } catch (cleanupError) {
        print('Failed to cleanup after error: $cleanupError');
      }
    }
  }

  Future<void> sendKML2(BuildContext context, SSHClient _client) async {
    try {
      if (_client == null) {
        context.read<TimelineBloc>().add(
              AddTimelineStep(step: "Error: SSH client not initialized"),
            );
        return;
      }

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Himalayan Peaks KML Loading..."),
          );
      await _client.run('mkdir -p /var/www/html/kmls');

      final sftp = await _client.sftp();
      final sftpFile = await sftp.open('/var/www/html/kmls/himalayan_peaks.kml',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      final kmlStream =
          Stream.fromIterable([Uint8List.fromList(utf8.encode(KML2.kml))]);
      await sftpFile.write(kmlStream);
      await sftpFile.close();

      await _client.run(
          'echo "http://lg1:81/kmls/himalayan_peaks.kml" > /var/www/html/kmls.txt');

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Initializing tour..."),
          );
      await Future.delayed(const Duration(seconds: 2));
      await _client
          .run('echo "playtour=Himalayan Peaks Tour" > /tmp/query.txt');

      final steps = [
        "Visiting Mount Everest...",
        "Visiting K2...",
        "Visiting Kangchenjunga...",
      ];

      for (var step in steps) {
        context.read<TimelineBloc>().add(
              AddTimelineStep(step: step),
            );
        await Future.delayed(const Duration(seconds: 10));
      }
      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Finalizing tour..."),
          );
      await _client.run('echo "exittour=true" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 1));
      await _client.run('rm /var/www/html/kmls/himalayan_peaks.kml');
      await _client.run('echo "" > /var/www/html/kmls.txt');

      context.read<TimelineBloc>().add(
            AddTimelineStep(step: "Tour completed successfully"),
          );
    } catch (e) {
      print('Error during tour: $e');
      try {
        await _client.run('echo "exittour=true" > /tmp/query.txt');
        await _client.run('rm /var/www/html/kmls/himalayan_peaks.kml');
        await _client.run('echo "" > /var/www/html/kmls.txt');
        context.read<TimelineBloc>().add(
              AddTimelineStep(step: "Cleanup completed after error"),
            );
      } catch (cleanupError) {
        print('Failed to cleanup after error: $cleanupError');
      }
    }
  }

  Future<void> setLogo() async {
    try {
      if (_client == null) {
        return;
      }
      final screenOverlay = ScreenOverlay.liquidGalaxyLogo();
      final kml = KML(
        name: 'LG-Logo',
        content: '<name>Liquid Galaxy</name>${screenOverlay.tag}',
      );

      await _client
          ?.run("echo '${kml.body}' > /var/www/html/kml/slave_$leftScreen.kml");
    } catch (e) {
      print('Failed to set logo: $e');
    }
  }

  Future<void> clearLogo() async {
    try {
      if (_client == null) {
        return;
      }
      String blankKML = KML.generateBlank('LG-Logo');
      await _client
          ?.run("echo '$blankKML' > /var/www/html/kml/slave_$leftScreen.kml");
    } catch (e) {
      print('Failed to clean logo: $e');
    }
  }
}
