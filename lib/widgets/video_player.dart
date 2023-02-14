import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../extensions/duration_extension.dart';
import '../utils/auto_orientation.dart';

export 'package:video_player/video_player.dart' show VideoPlayerController;

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    Key? key,
    this.path,
    this.title,
    this.controller,
  })  : assert(path != null || controller != null),
        super(key: key);
  final String? path;
  final String? title;
  final VideoPlayerController? controller;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;

  Future<void> _initController() async {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      if (widget.path!.startsWith('http')) {
        _controller = VideoPlayerController.network(widget.path!);
      } else if (widget.path!.startsWith('assets')) {
        _controller = VideoPlayerController.asset(widget.path!);
      } else {
        _controller = VideoPlayerController.file(File(widget.path!));
      }
      await _controller.initialize();
      setState(() {});
      _controller.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = IconButton(
      icon: const Icon(Icons.fullscreen, color: Colors.white),
      tooltip: '全屏播放',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrientationVideoPlayer(controller: _controller),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                VideoControlOverlay(controller: _controller, actions: [button]),
                // VideoProgressIndicator(
                //   _controller,
                //   allowScrubbing: true,
                //   colors: VideoProgressColors(
                //       playedColor: Theme.of(context).colorScheme.primary,
                //       bufferedColor:
                //           Theme.of(context).colorScheme.primaryContainer),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 横屏视频播放器
class OrientationVideoPlayer extends StatefulWidget {
  const OrientationVideoPlayer({
    Key? key,
    this.path,
    this.title,
    this.controller,
  })  : assert(path != null || controller != null),
        super(key: key);
  final String? path;
  final String? title;
  final VideoPlayerController? controller;

  @override
  State<OrientationVideoPlayer> createState() => _OrientationVideoPlayerState();
}

class _OrientationVideoPlayerState extends State<OrientationVideoPlayer> {
  late VideoPlayerController _controller;

  Future<void> _initController() async {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      if (widget.path!.startsWith('http')) {
        _controller = VideoPlayerController.network(widget.path!);
      } else if (widget.path!.startsWith('assets')) {
        _controller = VideoPlayerController.asset(widget.path!);
      } else {
        _controller = VideoPlayerController.file(File(widget.path!));
      }
      await _controller.initialize();
      _controller.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _initController();
    AutoOrientation.landscapeLeftMode();
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = IconButton(
      icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
      tooltip: '退出全屏',
      onPressed: () => Navigator.pop(context),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                VideoControlOverlay(controller: _controller, actions: [button]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const Duration _kOpacityDuration = Duration(milliseconds: 300);

class VideoControlOverlay extends StatefulWidget {
  const VideoControlOverlay({
    required this.controller,
    this.actions,
    super.key,
  });

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  final List<Widget>? actions;

  @override
  State<VideoControlOverlay> createState() => VideoControlOverlayState();
}

class VideoControlOverlayState extends State<VideoControlOverlay> {
  Timer? _timer;
  late bool _showToolBar;

  void _listener() {
    if (widget.controller.value.isPlaying) {
      if (_showToolBar && _timer == null) {
        _startTimer();
      }
    } else if (!_showToolBar) {
      setState(() {
        _showToolBar = true;
      });
    }
  }

  void _onTap() {
    setState(() => _showToolBar = !_showToolBar);
    if (_showToolBar && widget.controller.value.isPlaying) {
      _startTimer();
    } else if (!widget.controller.value.isPlaying) {
      _cancelTimer();
    }
  }

  void _startTimer() {
    if (_timer != null) {
      return;
    }
    _timer = Timer(const Duration(seconds: 5), () {
      if (_showToolBar && mounted && widget.controller.value.isPlaying) {
        setState(() {
          _showToolBar = false;
        });
        _cancelTimer();
      }
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    _showToolBar = true;
    if (widget.controller.value.isPlaying) {
      _startTimer();
    }
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget bottomBar = AnimatedOpacity(
      opacity: _showToolBar ? 1 : 0,
      duration: _kOpacityDuration,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.black45,
              Colors.black38,
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PlayIcon(widget.controller),
            Expanded(
              child: VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                padding: const EdgeInsets.only(right: 12.0),
              ),
            ),
            _PlayDuration(widget.controller),
            ...?widget.actions,
          ],
        ),
      ),
    );
    final Widget topBar = AnimatedOpacity(
      opacity: _showToolBar ? 1 : 0,
      duration: _kOpacityDuration,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black54, Colors.black38, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: _PlaySpeed(widget.controller),
          ),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _onTap,
          onDoubleTap: widget.controller.value.isPlaying
              ? widget.controller.pause
              : widget.controller.play,
        ),
        Align(alignment: Alignment.bottomCenter, child: bottomBar),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: topBar,
        ),
      ],
    );
  }
}

class _PlayDuration extends StatefulWidget {
  const _PlayDuration(this.controller);

  final VideoPlayerController controller;

  @override
  State<_PlayDuration> createState() => _PlayDurationState();
}

class _PlayDurationState extends State<_PlayDuration> {
  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String position = widget.controller.value.position.format();
    final String duration = widget.controller.value.duration.format();

    return Text(
      '$position/$duration',
      style: const TextStyle(color: Colors.white),
    );
  }
}

class _PlayIcon extends StatefulWidget {
  const _PlayIcon(this.controller);

  final VideoPlayerController controller;

  @override
  State<_PlayIcon> createState() => _PlayIconState();
}

class _PlayIconState extends State<_PlayIcon> {
  late bool _isPlaying;

  void _listener() {
    if (widget.controller.value.isPlaying && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    } else if (!widget.controller.value.isPlaying && _isPlaying) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void initState() {
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget pauseIcon = IconButton(
      onPressed: widget.controller.pause,
      icon: const Icon(Icons.pause),
      color: Colors.white,
    );
    final Widget playIcon = IconButton(
      onPressed: widget.controller.play,
      icon: const Icon(Icons.play_arrow),
      color: Colors.white,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: widget.controller.value.isPlaying ? pauseIcon : playIcon,
    );
  }
}

class _PlaySpeed extends StatefulWidget {
  const _PlaySpeed(this.controller);

  final VideoPlayerController controller;

  @override
  State<_PlaySpeed> createState() => _PlaySpeedState();
}

class _PlaySpeedState extends State<_PlaySpeed> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: widget.controller.value.playbackSpeed,
      tooltip: '播放速度',
      onSelected: (speed) async {
        await widget.controller.setPlaybackSpeed(speed);
        setState(() {});
      },
      itemBuilder: (context) {
        return [
          for (final speed in VideoControlOverlay._examplePlaybackRates)
            PopupMenuItem(
              value: speed,
              textStyle: Theme.of(context).primaryTextTheme.bodyMedium,
              child: Text('${speed}x'),
            )
        ];
      },
      color: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        child: Text(
          '${widget.controller.value.playbackSpeed}x',
          style: Theme.of(context).primaryTextTheme.bodySmall,
        ),
      ),
    );
  }
}

// class _VolumeSlider extends StatefulWidget {
//   const _VolumeSlider(this.controller);
//
//   final VideoPlayerController controller;
//
//   @override
//   State<_VolumeSlider> createState() => _VolumeSliderState();
// }
//
// class _VolumeSliderState extends State<_VolumeSlider> {
//   void _listener() {
//     print(widget.controller.value.volume);
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     widget.controller.addListener(_listener);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     widget.controller.removeListener(_listener);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return RotatedBox(
//       quarterTurns: -1,
//       child: SizedBox(
//         width: 150.0,
//         child: Slider(
//           activeColor: Colors.transparent,
//           inactiveColor: Colors.transparent,
//           thumbColor: Colors.transparent,
//           value: widget.controller.value.volume,
//           onChanged: (value) {
//             widget.controller.setVolume(value);
//           },
//         ),
//       ),
//     );
//   }
// }
