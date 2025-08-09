import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class _VideoPlayPauseOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final Animation<double> pulseAnimation;
  const _VideoPlayPauseOverlay({
    required this.controller,
    required this.pulseAnimation,
    Key? key,
  }) : super(key: key);

  @override
  State<_VideoPlayPauseOverlay> createState() => _VideoPlayPauseOverlayState();
}

class _VideoPlayPauseOverlayState extends State<_VideoPlayPauseOverlay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        opacity: _isHovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Transform.scale(
          scale: widget.pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.4),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.controller.value.isPlaying) {
                    widget.controller.pause();
                  } else {
                    widget.controller.play();
                  }
                });
              },
              child: Icon(
                widget.controller.value.isPlaying
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
