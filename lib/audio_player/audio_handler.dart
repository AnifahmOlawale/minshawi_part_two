import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../provider/player_provider.dart';

class AudioPlayerHandlerImpl extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  final PlayerProvider _playerProvider;

  AudioPlayerHandlerImpl(this._player, this._playerProvider) {
    // Update playback state when player state changes or position changes
    _player.playerStateStream.listen(updatePlaybackState);
    _player.positionStream.listen((_) {
      updatePlaybackState(_player.playerState);
    });

    // Update media item duration when sequence changes
    _player.sequenceStateStream.listen((sequenceState) {
      final tag = sequenceState.currentSource?.tag;
      if (tag is MediaItem) {
        final updatedItem = tag.copyWith(
          duration: _player.duration,
        );
        mediaItem.add(updatedItem);
      }
    });
  }

  void updatePlaybackState(PlayerState state) {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.rewind,
          state.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.fastForward,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 2, 4],
        processingState: _mapProcessingState(state.processingState),
        playing: state.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  AudioProcessingState _mapProcessingState(ProcessingState s) {
    switch (s) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() async => _playerProvider.play();

  @override
  Future<void> pause() async => _playerProvider.pause();

  @override
  Future<void> stop() async => _playerProvider.stop();

  @override
  Future<void> skipToNext() async => _playerProvider.next();

  @override
  Future<void> skipToPrevious() async => _playerProvider.previous();

  @override
  Future<void> fastForward() async {
    final newPosition = _player.position + const Duration(seconds: 10);
    await _player.seek(newPosition);
  }

  @override
  Future<void> rewind() async {
    final newPosition = _player.position - const Duration(seconds: 10);
    await _player
        .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}
