import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/audio_preview.dart';
import 'material_failure.dart';
import 'material_providers.dart';

class AudioController extends Notifier<AudioPreview> {
  static final provider = NotifierProvider<AudioController, AudioPreview>(
    AudioController.new,
  );
  @override
  AudioPreview build() => ref.read(materialRepositoryProvider).audio;
  void toggle() => _save(state.copyWith(playing: !state.playing));
  void pause() => _save(state.copyWith(playing: false));
  void speed(double value) {
    if (!value.isFinite || value <= 0) return;
    _save(state.copyWith(speed: value));
  }

  void _save(AudioPreview value) {
    try {
      ref.read(materialRepositoryProvider).saveAudio(value);
      state = value;
      ref.read(MaterialFailure.provider.notifier).set(false);
    } catch (error, stack) {
      logError(error, stack);
      ref.read(MaterialFailure.provider.notifier).set(true);
    }
  }
}
