import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_task_2/bloc/connection_bloc/connection_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isConnected = false;
  late ConnectionBloc connectionBloc;
  final TextEditingController ipController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController sshPortController = TextEditingController();
  final TextEditingController lgRigsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectionBloc = context.read<ConnectionBloc>();
    isConnected= connectionBloc.state is Connected;
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ipController.text = prefs.getString('ipAddress') ?? '';
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      sshPortController.text = prefs.getString('sshPort') ?? '';
      lgRigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> _connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('sshPort', sshPortController.text);
    await prefs.setString('numberOfRigs', lgRigsController.text);
    connectionBloc.add(ConnectToLG());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff03214A),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff03214A),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: BlocConsumer<ConnectionBloc, LGConnectionState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            isConnected = state is Connected;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isConnected
                              ? const Color(0xFF00FF41)
                              : const Color(0xFFFF1744),
                          boxShadow: [
                            BoxShadow(
                              color: isConnected
                                  ? const Color(0xFF00FF41).withOpacity(0.7)
                                  : const Color(0xFFFF1744).withOpacity(0.7),
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        isConnected ? "Connected" : "Disconnected",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: isConnected
                              ? const Color(0xFF00FF41)
                              : const Color(0xFFFF1744),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(Icons.computer, "IP Address", ipController),
                  _buildTextField(
                      Icons.person, "LG Username", usernameController),
                  _buildTextField(Icons.lock, "LG Password", passwordController,
                      isPassword: true),
                  _buildTextField(Icons.code, "SSH Port", sshPortController),
                  _buildTextField(
                      Icons.settings, "No. of LG rigs", lgRigsController),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected
                          ? const Color(0xFFFF1744)
                          : const Color(0xFF006D5B), // Change color
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 40.w),
                    ),
                    onPressed: () {
                      if (isConnected) {
                        connectionBloc.add(
                            DisconnectFromLG()); // Dispatch Disconnect Event
                      } else {
                        _connect();
                      }
                    },
                    child: Text(
                      isConnected ? "Disconnect" : "Connect", // Change text
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        obscureText: isPassword,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
          hintText: "Enter $label",
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFF00E5FF)),
          ),
        ),
      ),
    );
  }
}
