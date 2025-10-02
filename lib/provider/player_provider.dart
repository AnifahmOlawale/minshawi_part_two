import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/audio_player/audio_handler.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'dart:math';

class PlayerProvider extends ChangeNotifier {
  QuranCsv quranCsv = QuranCsv();

  final random = Random();

  late AudioPlayerHandlerImpl _audioHandler;

  final AudioPlayer _player;

  PlayerProvider(this._player) {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (SwitchRepeat.repeatOFF.name == _repeatingIcon) {
          next();
        } else if (SwitchRepeat.repeatON.name == _repeatingIcon) {
          restart();
        } else if (SwitchRepeat.shuffle.name == _repeatingIcon) {
          shuffle();
        }
      }

      //notifyListeners();
    });

    _player.positionStream.listen(
      (event) {
        audioPlayer.put("lastPosition", event);
        if (_loopStop != Duration.zero) {
          if (event >= _loopStop) {
            seek(position: _loopStart);
          }
        }
      },
    );

    _player.durationStream.listen(
      (event) {
        audioPlayer.put("lastDuration", event);
      },
    );
  }

  void setHandler(AudioPlayerHandlerImpl handler) {
    _audioHandler = handler;
  }

  Future playCurrent() async {
    final fileName = '${_currentPlayerIndex! + 1}.mp3';
    // Update notification MediaItem with correct duration
    MediaItem updatedItem = MediaItem(
      id: fileName,
      title: 'Surah $_currentPlayerTransSurahName',
      album: appName,
      artUri: Uri.parse(
          'https://play-lh.googleusercontent.com/J0924rdWk6mlZTzgl2MPMum6btNBFbqD_RH3lNomnwLn_H-2XjFdjJ4vFOJ5nw57iA=s512-rw'),
    );

    if (_audioHandler.mediaItem.value?.id != updatedItem.id) {
      // Load audio and attach tag
      await _player.setAudioSource(
        AudioSource.asset(
          'assets/audios/$fileName',
          tag: MediaItem(
            id: fileName,
            title: 'Surah $_currentPlayerTransSurahName',
            album: appName,
            artUri: Uri.parse(
                'https://play-lh.googleusercontent.com/J0924rdWk6mlZTzgl2MPMum6btNBFbqD_RH3lNomnwLn_H-2XjFdjJ4vFOJ5nw57iA=s512-rw'),
          ),
        ),
        initialPosition: _lastPosition,
      );

      // After loading, get duration

      await _audioHandler.updateMediaItem(updatedItem);

      // Immediately update playback state after updating media
      // _audioHandler.updatePlaybackState(_player.playerState);
    }

    // notifyListeners();
  }

  //
  int? _currentPlayerIndex = audioPlayer.get("currentPlayerIndex");
  String _currentPlayerArabicSurahName =
      audioPlayer.get("currentPlayerArabicSurahName") ?? "";
  String _currentPlayerTransSurahName =
      audioPlayer.get("currentPlayerTransSurahName") ?? "";

  Duration _lastPosition = audioPlayer.get("lastPosition") ?? Duration.zero;

  String _repeatingIcon =
      audioPlayer.get("repeatingIcon") ?? SwitchRepeat.repeatOFF.name;

  LoopPlayer _loopIcon = LoopPlayer.start;

  Duration _loopStart = Duration.zero;

  Duration _loopStop = Duration.zero;
  //

//Getters
  int? get currentPlayerIndex => _currentPlayerIndex;
  String get currentPlayerArabicSurahName => _currentPlayerArabicSurahName;
  String get currentPlayerTransSurahName => _currentPlayerTransSurahName;
  String get repeatingIcon => _repeatingIcon;
  Duration get lastPosition => _lastPosition;
  LoopPlayer get loopIcon => _loopIcon;
  Duration get loopStart => _loopStart;
  Duration get loopStop => _loopStop;

//
  AudioPlayer get player => _player;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream =>
      _player.playerStateStream; //NOT USED
  bool get isPlaying => _player.playing;

//CHANGE PLAYER INDEX AND TEXT PROPERTIES
  void setCurrentPlayerIndex(
      {required int index,
      required String currentPlayerArabicSurahName,
      required String currentPlayerTransSurahName}) {
    //
    stopLooping();
    _currentPlayerIndex = index;
    audioPlayer.put("currentPlayerIndex", index);
    //
    _currentPlayerArabicSurahName = currentPlayerArabicSurahName;
    audioPlayer.put(
        "currentPlayerArabicSurahName", currentPlayerArabicSurahName);
    //
    _currentPlayerTransSurahName = currentPlayerTransSurahName;
    audioPlayer.put("currentPlayerTransSurahName", currentPlayerTransSurahName);

    notifyListeners();
  }

//SWITCH LOOP ICON

  void switchLoopIcon({required BuildContext context}) {
    Duration currentPosition = audioPlayer.get("lastPosition");
    if (_loopIcon == LoopPlayer.start) {
      _loopStart = currentPosition;
      _loopIcon = LoopPlayer.end;
    } else if (_loopIcon == LoopPlayer.end) {
      if (currentPosition <= _loopStart) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Stop position should be greater"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      } else {
        _loopStop = currentPosition;
        _loopIcon = LoopPlayer.stop;
      }
    } else if (_loopIcon == LoopPlayer.stop) {
      stopLooping();
    }
    notifyListeners();
  }

  //STOP LOOPING
  void stopLooping() {
    _loopStart = Duration.zero;
    _loopStop = Duration.zero;
    _loopIcon = LoopPlayer.start;
  }

//SWITCH REPEAT | REPEAT_ONE | SHUFFLE
  void switchRepeatIcon() {
    //
    if (_repeatingIcon == SwitchRepeat.repeatOFF.name) {
      _repeatingIcon = SwitchRepeat.repeatON.name;
    } else if (_repeatingIcon == SwitchRepeat.repeatON.name) {
      _repeatingIcon = SwitchRepeat.shuffle.name;
    } else {
      _repeatingIcon = SwitchRepeat.repeatOFF.name;
    }
    audioPlayer.put("repeatingIcon", _repeatingIcon);
    notifyListeners();
  }

//SET LAST POSITION
  void setLastPostion({required Duration position}) {
    _lastPosition = position;
    audioPlayer.put("lastPosition", position);
  }

//RESTART
  void restart() {
    if (player.audioSource != null) {
      setLastPostion(position: Duration.zero);
      _audioHandler.seek(Duration.zero); // use handler
      //_player.seek(Duration.zero);
      play();
    } else {
      resume();
      _audioHandler.seek(Duration.zero); // use handler
      //_player.seek(Duration.zero);
      play();
    }

    notifyListeners();
  }

//PLAY
  void play() async {
    // _audioHandler.play();
    _player.play();
    notifyListeners();
  }

//PAUSE
  void pause() async {
    //_audioHandler.pause();
    _player.pause();
    notifyListeners();
  }

//NEXT
  void next() {
    int nextIndex =
        _currentPlayerIndex == 113 ? 18 : _currentPlayerIndex! + 1; //TODO
    String arabicSurahName = quranCsv.listOfSurahs.elementAt(nextIndex)[2];
    String transSurahName = quranCsv.listOfSurahs.elementAt(nextIndex)[1];
    setCurrentPlayerIndex(
      index: nextIndex,
      currentPlayerArabicSurahName: arabicSurahName,
      currentPlayerTransSurahName: transSurahName,
    );
    setLastPostion(position: Duration.zero);
    playCurrent();
    play();

    //notifyListeners();
  }

//PREVIOUSE
  void previous() {
    int previousIndex =
        _currentPlayerIndex == 18 ? 113 : _currentPlayerIndex! - 1; //TODO
    String arabicSurahName = quranCsv.listOfSurahs.elementAt(previousIndex)[2];
    String transSurahName = quranCsv.listOfSurahs.elementAt(previousIndex)[1];
    setCurrentPlayerIndex(
      index: previousIndex,
      currentPlayerArabicSurahName: arabicSurahName,
      currentPlayerTransSurahName: transSurahName,
    );
    setLastPostion(position: Duration.zero);
    playCurrent();
    play();

    //notifyListeners();
  }

//SEEK TO POSITION
  void seek({required Duration position}) async {
    _audioHandler.seek(position); // use handler
    //_player.seek(position);
    if (isPlaying) {
      play();
    } else {
      notifyListeners();
    }
  }

//RESUME
  void resume() async {
    if (player.audioSource == null) {
      await playCurrent();
      play();
    } else {
      play();
    }
    //notifyListeners();
  }

//SHUFFLE
  void shuffle() {
    int randomIndex = 19 +
        random.nextInt(114 -
            19 +
            1); //TODO max=114 min =19--------- min + random.nextInt(max - min + 1);    String arabicSurahName = quranCsv.listOfSurahs.elementAt(randomIndex)[2];
    String arabicSurahName = quranCsv.listOfSurahs.elementAt(randomIndex)[2];
    String transSurahName = quranCsv.listOfSurahs.elementAt(randomIndex)[1];
    setCurrentPlayerIndex(
      index: randomIndex,
      currentPlayerArabicSurahName: arabicSurahName,
      currentPlayerTransSurahName: transSurahName,
    );
    setLastPostion(position: Duration.zero);
    playCurrent();
    play();

    //notifyListeners();
  }

//STOP
  void stop() async {
    _player.stop();
    notifyListeners();
  }

//DISPOSE PLAYER
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
