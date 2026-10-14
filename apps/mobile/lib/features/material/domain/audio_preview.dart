class AudioPreview {
  const AudioPreview({this.playing = true, this.speed = 1.25});
  final bool playing;
  final double speed;
  AudioPreview copyWith({bool? playing, double? speed}) => AudioPreview(
    playing: playing ?? this.playing,
    speed: speed ?? this.speed,
  );
}
