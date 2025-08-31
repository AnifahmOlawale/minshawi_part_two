import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/arabic_surah_font_text.dart';

Widget homeListTile(BuildContext context,
    {required Icon icon, required String title, VoidCallback? onCardClick}) {
  final themeColorProvider = Provider.of<ThemeColor>(context);

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: GestureDetector(
      onTap: onCardClick,
      child: Card(
        color: themeColorProvider.card,
        child: ListTile(
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          leading: icon,
        ),
      ),
    ),
  );
}

Widget bottomPlayer(BuildContext context) {
  final themeColorProvider = Provider.of<ThemeColor>(context);
  final playerProvider = Provider.of<PlayerProvider>(context, listen: true);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: themeColorProvider.playerCard,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          playerProvider.player.audioSource != null
              ? Text(
                  "Playing: ",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "Continue Playing: ",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
          Expanded(
              child: Text(
            "Surah ${playerProvider.currentPlayerTransSurahName}",
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          )),
          IconButton(
            iconSize: 30,
            color: Colors.white,
            onPressed: () {
              playerProvider.player.audioSource == null
                  ? playerProvider.resume()
                  : playerProvider.isPlaying
                      ? playerProvider.pause()
                      : playerProvider.play();
            },
            icon: playerProvider.isPlaying
                ? Icon(Icons.pause_circle_outline_outlined)
                : Icon(Icons.play_circle_outline_outlined),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}

Widget surahListTile(
  BuildContext context, {
  required int index,
  required String title,
  required String subTitle,
  required String arabicName,
  required Color? cardColor,
  required Color? selectedColour,
  required bool isPlayer,
  VoidCallback? onCardClick,
}) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: GestureDetector(
      onTap: onCardClick,
      child: Column(
        children: [
          Card(
            color: cardColor,
            child: ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text.rich(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    TextSpan(
                        text: title, style: TextStyle(color: selectedColour)),
                    TextSpan(
                        text: "\n$subTitle",
                        style: TextStyle(fontSize: 12, color: selectedColour))
                  ],
                ),
              ),
              leading: Stack(children: [
                Image.asset(
                  "assets/images/star.png",
                  color: selectedColour,
                ),
                Positioned(
                    right: 0,
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                        child: Text(
                      index.toString(),
                      style: TextStyle(color: selectedColour),
                    )))
              ]),
              trailing: Text(
                arabicSurahFont(index),
                style: TextStyle(
                    fontFamily: 'ArabicSurah',
                    fontSize: 35,
                    color: selectedColour),
              ),
            ),
          ),
          //BOTTOM SPACING
          if (index == 114)
            const SizedBox(
              height: 150,
            ),
        ],
      ),
    ),
  );
}

Widget settingsListTile(BuildContext context,
    {required Icon? icon,
    required String title,
    required Widget? trailing,
    VoidCallback? onCardClick}) {
  final themeColorProvider = Provider.of<ThemeColor>(context);

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: GestureDetector(
      onTap: onCardClick,
      child: Card(
        color: themeColorProvider.card,
        child: ListTile(
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          leading: icon,
          trailing: trailing,
        ),
      ),
    ),
  );
}
