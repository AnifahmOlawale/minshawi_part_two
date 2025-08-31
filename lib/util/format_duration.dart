String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final seconds = duration.inSeconds.remainder(60);

  final minutes = duration.inMinutes.remainder(60);

  final hours = duration.inHours;

  if (hours > 0) {
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  } else {
    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
