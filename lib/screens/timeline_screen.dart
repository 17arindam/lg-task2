import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_task_2/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:lg_task_2/bloc/command_bloc/command_bloc.dart';

class TimelineScreen extends StatefulWidget {
  final String tag;

  const TimelineScreen({super.key, required this.tag});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late final TimelineBloc _timelineBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timelineBloc = context.read<TimelineBloc>();
  }

  @override
  void dispose() {
    _timelineBloc.add(ResetTimeline());
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero animation background
          Hero(
            tag: widget.tag,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, opacity, child) {
                return Container(
                  color: widget.tag == "kml1"
                      ? const Color(0xFF4682B4)
                      : const Color(0xFF008080),
                );
              },
            ),
          ),

          // Timeline content
          BlocConsumer<TimelineBloc, TimelineState>(
            listener: (context, state) {
              if (state is CurrentTimelineState) {
                _scrollToEnd(); 
              }
            },
            builder: (context, state) {
              if (state is CurrentTimelineState) {
                return SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller:
                              _scrollController, // Attach scroll controller
                          padding: EdgeInsets.only(top: 20.h),
                          itemCount: state.timelineSteps.length,
                          itemBuilder: (context, index) {
                            return TimelineItem(
                              isLeft: index.isEven,
                              stepText: state.timelineSteps[index],
                              isLast: index == state.timelineSteps.length - 1,
                              animationDelay:
                                  Duration(milliseconds: 200 * index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),

         
          BlocListener<CommandBloc, CommandState>(
            listener: (context, state) {
              if (state is CommandSuccess &&
                  state.message == "Tour Completed") {
                Navigator.pop(context); 
              }
            },
            child: const SizedBox(), 
          ),
        ],
      ),
    );
  }
}

class TimelineItem extends StatefulWidget {
  final bool isLeft;
  final String stepText;
  final bool isLast;
  final Duration animationDelay;

  const TimelineItem({
    Key? key,
    required this.isLeft,
    required this.stepText,
    required this.isLast,
    required this.animationDelay,
  }) : super(key: key);

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isLeft ? -0.5 : 0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Stack(
        children: [
          // Vertical line
          if (!widget.isLast)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 1,
              top: 25.h,
              bottom: 0,
              child: Container(
                width: 2,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          // Timeline dot
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 6,
            top: 20.h,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            left: widget.isLeft ? 20.w : null,
            right: widget.isLeft ? null : 20.w,
            top: 10.h,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.stepText,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
