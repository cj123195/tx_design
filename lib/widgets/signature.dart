import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';

import 'signature_theme.dart';

export 'package:signature/signature.dart' show SignatureController;

const Color _kPenColor = Colors.black;
const Color _kBackgroundColor = Colors.white;
const Color _kExportBackgroundColor = Colors.transparent;
const double _kStrokeWidth = 3.0;

/// 一个用于签名的画板小部件。
class TxSignature extends StatefulWidget {
  /// 创建一个签名小部件
  const TxSignature({
    super.key,
    this.controller,
    this.height,
    this.width,
    this.penColor,
    this.exportPenColor,
    this.strokeWidth,
    this.backgroundColor,
    this.exportBackgroundColor,
    this.iconTheme,
    this.onSave,
  });

  /// 签名控制器
  final SignatureController? controller;

  /// 画布高度
  ///
  /// 外层容器的高度并不能限制画布高度，所以如不设置此值，画笔可绘制到父容器之外
  /// 默认值为200
  final double? height;

  /// 画布宽度
  ///
  /// 外层容器的宽度并不能限制画布宽度，所以如不设置此值，画笔可绘制到父容器之外
  /// 默认值为屏幕宽度
  final double? width;

  /// 画笔颜色
  final Color? penColor;

  /// 导出画笔颜色
  final Color? exportPenColor;

  /// 画笔粗细
  final double? strokeWidth;

  /// 背景颜色
  final Color? backgroundColor;

  /// 导出背景颜色
  final Color? exportBackgroundColor;

  /// 图标样式
  final IconThemeData? iconTheme;

  /// 保存回调
  final ValueChanged<Uint8List?>? onSave;

  @override
  State<TxSignature> createState() => _TxSignatureState();
}

class _TxSignatureState extends State<TxSignature> {
  SignatureController? _controller;

  /// 进入全屏
  Future<void> _enterFullScreen(double height, double width) async {
    final Size mediaSize = MediaQuery.of(context).size;

    _refreshPoints(mediaSize.height / width, mediaSize.width / height);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TxSignatureFullScreen(
          controller: _controller,
          backgroundColor: widget.backgroundColor,
          iconTheme: widget.iconTheme,
        ),
      ),
    );
    _refreshPoints(width / mediaSize.height, height / mediaSize.width);
  }

  /// 修改点位
  void _refreshPoints(double widthRadio, double heightRadio) {
    final List<Point> points = _controller!.points;
    _controller!.points = points
        .map((e) => e.copyWith(
              offset:
                  Offset(e.offset.dx * widthRadio, e.offset.dy * heightRadio),
            ))
        .toList();
  }

  @override
  void didChangeDependencies() {
    if (_controller != null) {
      return;
    }
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      final TxSignatureThemeData signatureTheme = TxSignatureTheme.of(context);
      final Color penColor =
          widget.penColor ?? signatureTheme.penColor ?? _kPenColor;
      final Color exportPenColor =
          widget.exportPenColor ?? signatureTheme.exportPenColor ?? _kPenColor;
      final Color exportBackground = widget.exportBackgroundColor ??
          signatureTheme.exportBackgroundColor ??
          _kExportBackgroundColor;
      final double strokeWidth =
          widget.strokeWidth ?? signatureTheme.strokeWidth ?? _kStrokeWidth;

      _controller = SignatureController(
        penColor: penColor,
        penStrokeWidth: strokeWidth,
        exportPenColor: exportPenColor,
        exportBackgroundColor: exportBackground,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TxSignatureThemeData signatureTheme = TxSignatureTheme.of(context);
    final Color background = widget.backgroundColor ??
        signatureTheme.backgroundColor ??
        _kBackgroundColor;
    final IconThemeData iconTheme =
        widget.iconTheme ?? signatureTheme.iconTheme ?? const IconThemeData();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double height =
              widget.height ?? signatureTheme.height ?? constraints.maxHeight;
          final double width =
              widget.width ?? signatureTheme.width ?? constraints.maxWidth;

          return Stack(
            alignment: Alignment.topRight,
            children: [
              Signature(
                controller: _controller!,
                backgroundColor: background,
                height: height,
                width: width,
              ),
              IconTheme(
                data: iconTheme.copyWith(size: 18.0),
                child: ButtonBar(
                  children: [
                    IconButton(
                      onPressed: _controller!.clear,
                      icon: const Icon(Icons.cleaning_services_rounded),
                      tooltip: '清空',
                    ),
                    IconButton(
                      onPressed: _controller!.undo,
                      icon: const Icon(Icons.undo),
                      tooltip: '撤销',
                    ),
                    IconButton(
                      onPressed: _controller!.redo,
                      icon: const Icon(Icons.redo),
                      tooltip: '还原',
                    ),
                    IconButton(
                      onPressed: widget.onSave == null
                          ? null
                          : () async =>
                              widget.onSave!(await _controller!.toPngBytes()),
                      icon: const Icon(Icons.save_outlined),
                      tooltip: '保存',
                    ),
                    IconButton(
                      onPressed: () => _enterFullScreen(height, width),
                      icon: const Icon(Icons.fullscreen),
                      tooltip: '全屏',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 一个用于全屏的签名的画板小部件。
class TxSignatureFullScreen extends StatefulWidget {
  /// 创建一个签名小部件
  const TxSignatureFullScreen({
    super.key,
    this.controller,
    this.penColor,
    this.exportPenColor,
    this.strokeWidth,
    this.backgroundColor,
    this.exportBackgroundColor,
    this.iconTheme,
    this.onSave,
  });

  /// 签名控制器
  final SignatureController? controller;

  /// 画笔颜色
  final Color? penColor;

  /// 导出画笔颜色
  final Color? exportPenColor;

  /// 画笔粗细
  final double? strokeWidth;

  /// 背景颜色
  final Color? backgroundColor;

  /// 导出背景颜色
  final Color? exportBackgroundColor;

  /// 图标样式
  final IconThemeData? iconTheme;

  /// 保存回调
  final ValueChanged<Uint8List?>? onSave;

  @override
  State<TxSignatureFullScreen> createState() => _TxSignatureFullScreenState();
}

class _TxSignatureFullScreenState extends State<TxSignatureFullScreen> {
  SignatureController? _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_controller != null) {
      return;
    }
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      final TxSignatureThemeData signatureTheme = TxSignatureTheme.of(context);
      final Color penColor =
          widget.penColor ?? signatureTheme.penColor ?? _kPenColor;
      final Color exportPenColor =
          widget.exportPenColor ?? signatureTheme.exportPenColor ?? _kPenColor;
      final Color exportBackground = widget.exportBackgroundColor ??
          signatureTheme.exportBackgroundColor ??
          _kExportBackgroundColor;
      final double strokeWidth =
          widget.strokeWidth ?? signatureTheme.strokeWidth ?? _kStrokeWidth;

      _controller = SignatureController(
        penColor: penColor,
        penStrokeWidth: strokeWidth,
        exportPenColor: exportPenColor,
        exportBackgroundColor: exportBackground,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (widget.controller == null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TxSignatureThemeData signatureTheme = TxSignatureTheme.of(context);
    final Color background = widget.backgroundColor ??
        signatureTheme.backgroundColor ??
        _kBackgroundColor;
    final IconThemeData iconTheme =
        widget.iconTheme ?? signatureTheme.iconTheme ?? const IconThemeData();

    return SafeArea(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Signature(controller: _controller!, backgroundColor: background),
          IconTheme(
            data: iconTheme.copyWith(size: 24.0),
            child: ButtonBar(
              children: [
                IconButton(
                  onPressed: _controller!.clear,
                  icon: const Icon(Icons.cleaning_services_rounded),
                  tooltip: '清空',
                ),
                IconButton(
                  onPressed: _controller!.undo,
                  icon: const Icon(Icons.undo),
                  tooltip: '撤销',
                ),
                IconButton(
                  onPressed: _controller!.redo,
                  icon: const Icon(Icons.redo),
                  tooltip: '还原',
                ),
                IconButton(
                  onPressed: widget.onSave == null
                      ? null
                      : () async =>
                          widget.onSave!(await _controller!.toPngBytes()),
                  icon: const Icon(Icons.save_outlined),
                  tooltip: '保存',
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.fullscreen_exit),
                  tooltip: '退出',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension PointExtension on Point {
  Point copyWith({Offset? offset, PointType? type, double? pressure}) {
    return Point(
      offset ?? this.offset,
      type ?? this.type,
      pressure ?? this.pressure,
    );
  }
}
