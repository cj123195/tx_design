extension DurationExtension on Duration {
  String format() {
    String text;
    final int total = inSeconds;
    final int second = total % 60;
    text = _formatNum(second);
    int minute = total ~/ 60;
    if (minute > 60) {
      minute = minute % 60;
      text = '${_formatNum(minute)}:$text';
      final int hour = minute ~/ 60;
      text = '$hour:$text';
    } else {
      text = '${_formatNum(minute)}:$text';
    }
    return text;
  }

  String _formatNum(int num) {
    return num < 10 ? '0$num' : num.toString();
  }
}
