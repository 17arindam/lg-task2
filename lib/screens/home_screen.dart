import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_task_2/bloc/command_bloc/command_bloc.dart';
import 'package:lg_task_2/bloc/connection_bloc/connection_bloc.dart';
import 'package:lg_task_2/screens/settings_screen.dart';
import 'package:lg_task_2/screens/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  late ConnectionBloc connectionBloc;
  late CommandBloc commandBloc;
  bool isConnected = false; // Change this for status

  @override
  void initState() {
    super.initState();
    connectionBloc = context.read<ConnectionBloc>();
    commandBloc = context.read<CommandBloc>();
    isConnected = connectionBloc.state is Connected;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animations = [
      Tween<Offset>(begin: const Offset(-1, -1), end: Offset.zero)
          .animate(_controller),
      Tween<Offset>(begin: const Offset(1, -1), end: Offset.zero)
          .animate(_controller),
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(_controller),
      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(_controller),
      Tween<Offset>(begin: const Offset(-1, 1), end: Offset.zero)
          .animate(_controller),
      Tween<Offset>(begin: const Offset(1, 1), end: Offset.zero)
          .animate(_controller),
    ];

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendLogo() {
    commandBloc.add(SendLogo());
  }

  void _clearLogo() {
    commandBloc.add(ClearLogo());
  }

  void _sendKML1() {
    _navigateWithAnimation(context, "kml1");
    commandBloc.add(SendKML1(context));
  }

  void _sendKML2() {
    _navigateWithAnimation(context, "kml2");
    commandBloc.add(SendKML2(context));
  }

  void _clearKML() {
    commandBloc.add(ClearKML());
  }

  void _relaunch() {
    commandBloc.add(RelaunchLG());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff03214A),
      appBar: AppBar(
        backgroundColor: const Color(0xff03214A),
        title: Text(
          "Liquid Galaxy",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 24.sp),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SettingsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<ConnectionBloc, LGConnectionState>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isConnected = state is Connected;
          return BlocConsumer<CommandBloc, CommandState>(
            listener: (context, state) {
              if (state is CommandSuccess) {
                Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.sp,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    /// **Status Indicator**
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
                                : const Color(
                                    0xFFFF1744), // Green for connected, Red for disconnected
                            boxShadow: [
                              BoxShadow(
                                color: isConnected
                                    ? const Color(0xFF00FF41)
                                        .withOpacity(0.7) // Glowing green
                                    : const Color(0xFFFF1744)
                                        .withOpacity(0.7), // Glowing red
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

                    /// **Grid of Cards**
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        children: [
                          _buildAnimatedCard(
                              "Send Logo",
                              const Color(0xFF4B0082),
                              _animations[0],
                              _sendLogo),
                          _buildAnimatedCard(
                              "Clear Logo",
                              const Color(0xFF5F9EA0),
                              _animations[1],
                              _clearLogo),
                          Hero(
                            tag: 'kml1',
                            child: _buildAnimatedCard(
                                "Send KML1",
                                const Color(0xFF4682B4),
                                _animations[2],
                                _sendKML1),
                          ),
                          Hero(
                            tag: 'kml2',
                            child: _buildAnimatedCard(
                                "Send KML2",
                                const Color(0xFF008080),
                                _animations[3],
                                _sendKML2),
                          ),
                          _buildAnimatedCard(
                              "Clear KML",
                              const Color(0xFF5C5C5C),
                              _animations[4],
                              _clearKML),
                          _buildAnimatedCard("Relaunch LG", const Color(0xFF66CDAA),
                              _animations[5], _relaunch),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// **Reusable Card Widget with Function Parameter**
  Widget _buildAnimatedCard(String text, Color color,
      Animation<Offset> animation, VoidCallback onTap) {
    return SlideTransition(
      position: animation,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          color: color,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateWithAnimation(BuildContext context, String tag) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: TimelineScreen(tag: tag),
        );
      },
    ));
  }
}
