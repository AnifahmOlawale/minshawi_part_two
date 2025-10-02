import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/audio_player/sleep_timer.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/read_quran.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/arabic_surah_font_text.dart';
import 'package:quran_app/util/enums.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:quran_app/util/format_duration.dart';

class PlayerPage extends StatelessWidget {
  final ThemeColor themeColorProvider;
  final QuranCsv quranCsv;
  const PlayerPage(
      {super.key, required this.themeColorProvider, required this.quranCsv});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeColorProvider.playerPage ??
          Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //ARABIC SURAH NAME
            Text(
              arabicSurahFont(playerProvider.currentPlayerIndex == null
                  ? 1
                  : playerProvider.currentPlayerIndex! + 1),
              style: TextStyle(
                  fontFamily: "ArabicSurah",
                  fontSize: 60,
                  color: themeColorProvider.control),
            ),
            const SizedBox(
              height: 5,
            ),
            //LOTTIE ANIMI
            GestureDetector(
              onTap: () async {
                //
                //Save Clicked Index
                quranCsv
                    .setCurrentSurahIndex(playerProvider.currentPlayerIndex!);
                //initialize translatios
                quranCsv.initTrans();
                //open quran page
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ReadQuran(),
                    transitionDuration: Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.38,
                child: Card(
                  color: themeColorProvider.primary ??
                      Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Lottie.asset("assets/lottie/reading_quran.json"),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //RECITERS NAME
            Text(
              reciterName,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: themeColorProvider.control),
            ),
            //SURAH NAME
            Text(
              playerProvider.currentPlayerTransSurahName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: themeColorProvider.control),
            ),
            //LOOP POSITION

            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              width: double.infinity,
              child: Text.rich(
                style:
                    TextStyle(color: themeColorProvider.control, fontSize: 10),
                TextSpan(
                  children: [
                    if (playerProvider.loopIcon == LoopPlayer.start)
                      TextSpan(text: "SET START POINT FOR LOOP"),
                    if (playerProvider.loopIcon == LoopPlayer.end)
                      TextSpan(
                          text:
                              "START POINT @ ${formatDuration(playerProvider.loopStart)} SET END POINT"),
                    if (playerProvider.loopIcon == LoopPlayer.stop)
                      TextSpan(
                          text:
                              "LOOP START @ ${formatDuration(playerProvider.loopStart)} LOOP STOP @ ${formatDuration(playerProvider.loopStop)}"),
                  ],
                ),
              ),
            ),
            //CONTROLLER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //REPLAY
                IconButton(
                  iconSize: 35,
                  color: themeColorProvider.control,
                  onPressed: () {
                    if (playerProvider.player.audioSource == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Start the audio"),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      );
                    } else {
                      playerProvider.switchLoopIcon(context: context);
                    }
                  },
                  icon: playerProvider.loopIcon == LoopPlayer.start
                      ? Icon(
                          Icons.sync_outlined,
                          color: themeColorProvider.control,
                        )
                      : playerProvider.loopIcon == LoopPlayer.end
                          ? Icon(
                              Icons.sync_outlined,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.lock_reset_outlined,
                              color: Colors.red,
                            ),
                ),
                //PREVIOUSE
                IconButton(
                  iconSize: 50,
                  color: themeColorProvider.control,
                  onPressed: playerProvider.previous,
                  icon: Icon(Icons.skip_previous_rounded),
                ),
                //PLAY / PAUSE
                IconButton(
                  iconSize: 60,
                  color: themeColorProvider.control,
                  onPressed: () {
                    playerProvider.player.audioSource == null
                        ? playerProvider.resume()
                        : playerProvider.isPlaying
                            ? playerProvider.pause()
                            : playerProvider.play();
                  },
                  icon: playerProvider.isPlaying
                      ? Icon(Icons.pause_circle_filled_rounded)
                      : Icon(Icons.play_circle_fill_outlined),
                ),
                //NEXT
                IconButton(
                  iconSize: 50,
                  color: themeColorProvider.control,
                  onPressed: playerProvider.next,
                  icon: Icon(Icons.skip_next_rounded),
                ),
                //LOOP
                IconButton(
                  iconSize: 35,
                  color: themeColorProvider.control,
                  onPressed: () {
                    playerProvider.switchRepeatIcon();
                  },
                  icon: SwitchRepeat.repeatOFF.name ==
                          playerProvider.repeatingIcon
                      ? Icon(
                          Icons.repeat_rounded,
                        )
                      : SwitchRepeat.repeatON.name ==
                              playerProvider.repeatingIcon
                          ? Icon(Icons.repeat_one_rounded)
                          : Icon(Icons.shuffle), //repeat_one shuffle
                ),
              ],
            ),

            //SLIDER
            StreamBuilder<Duration?>(
              stream: playerProvider.durationStream,
              builder: (context, snapshot) {
                //
                final total = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: playerProvider.positionStream,
                  builder: (context, snapshot) {
                    //
                    final position = snapshot.data ?? Duration.zero;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ProgressBar(
                        progress: position,
                        total: total,
                        onSeek: (value) => playerProvider.seek(position: value),
                        timeLabelTextStyle: TextStyle(
                          color: themeColorProvider.control,
                        ),
                        progressBarColor: themeColorProvider.currentTheme ==
                                SetTheme.dark.name
                            ? Colors.white
                            : null,
                        thumbColor: themeColorProvider.currentTheme ==
                                SetTheme.dark.name
                            ? Colors.white
                            : null,
                        baseBarColor: themeColorProvider.currentTheme ==
                                SetTheme.dark.name
                            ? Colors.white.withValues(alpha: 0.5)
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
            //SLEEP TIMER
            SleepTimer(
              themeColorProvider: themeColorProvider,
              playerProvider: playerProvider,
            ),
          ],
        ),
      ),
    );
  }
}
