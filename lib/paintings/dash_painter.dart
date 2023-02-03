import 'dart:ui';

/// 虚线绘制
class DashedPainter {
  DashedPainter([this.pattern = const [3.0, 2.0]])
      : assert(pattern.length.isEven);

  /// 定义一组虚线的格式
  ///
  /// 如[3.0, 2.0]表示线段长3.0，两个线段之间间隔2.0；[5.0, 4.0, 10.0, 3.0]表示先绘制一
  /// 条长5.0的线段，间隔4.0绘制一条长10.0的线段，再间隔3.0绘制下一组虚线。
  ///
  /// 不能为null
  final List<double> pattern;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    final double partLength = pattern.reduce((total, value) => total + value);
    final int partCount = pattern.length ~/ 2;

    for (var pm in pms) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        double start = partLength * i;
        for (int j = 0; j < partCount; j++) {
          canvas.drawPath(
            pm.extractPath(start, start + pattern[j * 2]),
            paint,
          );
          start += pattern[j * 2] + pattern[j * 2 + 1];
        }
      }

      double tail = pm.length % partLength;
      for (int j = 0; j < partCount; j++) {
        final double length = pattern[j * 2] + pattern[j * 2 + 1];
        double end;
        if (length > tail) {
          end = pm.length - pattern[j * 2 + 1];
        } else {
          end = pm.length - tail + pattern[j * 2];
        }
        canvas.drawPath(
          pm.extractPath(pm.length - tail, end),
          paint,
        );
        tail -= length;
      }
    }
  }
}
