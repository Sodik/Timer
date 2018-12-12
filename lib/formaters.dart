String formatTime(int time) {
  int hours = (time / Duration.millisecondsPerHour).floor();
  int minutes = ((time - (hours * Duration.millisecondsPerHour)) / Duration.millisecondsPerMinute).floor();
  int seconds = ((time - (minutes * Duration.millisecondsPerMinute)) / Duration.millisecondsPerSecond).floor();

  return "${_formatNumber(hours)}:${_formatNumber(minutes)}:${_formatNumber(seconds)}";
}

String _formatNumber(int number) {
  return number < 10 ? "0${number}" : number.toString();
}

Duration stringToDuration(String str) {
  var splitteddStr = str.split(':');

  return new Duration(
      hours: int.parse(splitteddStr[0]),
      minutes: int.parse(splitteddStr[1]),
      seconds: int.parse(splitteddStr[2].split('.')[0])
  );
}