import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/ads/inter_ads_class.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/widget_tree/listwidget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Widget playerSurahList({
  required QuranCsv quranCsv,
  required bool isSearch,
  required bool playerListPage,
  required ItemScrollController? listScrollController,
  required bool isSearchControllerEmpty,
  required void Function() onCardClick,
}) {
  return Builder(builder: (context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Visibility(
      //maintainState: true,
      visible: playerListPage,
      child: Scrollbar(
        radius: Radius.circular(100),
        child: Column(
          children: [
            Expanded(
              child: ScrollablePositionedList.builder(
                initialScrollIndex: playerProvider.currentPlayerIndex == null
                    ? 0
                    : playerProvider.currentPlayerIndex! - 18, //TODO
                itemScrollController: listScrollController,
                itemCount: isSearch && isSearchControllerEmpty
                    ? quranCsv.filterSurah.length
                    : quranCsv.listOfSurahsPart.length,
                itemBuilder: (context, index) {
                  return surahListTile(
                    context,
                    isPlayer: true,
                    cardColor: playerProvider.currentPlayerIndex ==
                                quranCsv.listOfSurahsPart.elementAt(index)[0] -
                                    1 &&
                            !isSearch
                        ? themeColorProvider.selectedCardColour
                        : themeColorProvider.card,
                    selectedColour: playerProvider.currentPlayerIndex ==
                                quranCsv.listOfSurahsPart.elementAt(index)[0] -
                                    1 &&
                            !isSearch
                        ? themeColorProvider.selectedTextColour
                        : null,
                    index: isSearch && isSearchControllerEmpty
                        ? quranCsv.filterSurah.elementAt(index)[0]
                        : quranCsv.listOfSurahsPart.elementAt(index)[0],
                    title: isSearch && isSearchControllerEmpty
                        ? quranCsv.filterSurah.elementAt(index)[1]
                        : quranCsv.listOfSurahsPart.elementAt(index)[1],
                    subTitle: isSearch && isSearchControllerEmpty
                        ? quranCsv.filterSurah.elementAt(index)[3]
                        : quranCsv.listOfSurahsPart.elementAt(index)[3],
                    arabicName: isSearch && isSearchControllerEmpty
                        ? quranCsv.filterSurah.elementAt(index)[2]
                        : quranCsv.listOfSurahsPart.elementAt(index)[2],
                    onCardClick: () {
                      onCardClick();
                      int openIndex = isSearch && isSearchControllerEmpty
                          ? quranCsv.filterSurah.elementAt(index)[0]
                          : quranCsv.listOfSurahsPart.elementAt(index)[0];

                      //If the index is even, Show Ads
                      if (openIndex % 2 == 0) {
                        //Show Interstitial Ad
                        InterstitialAdmob().showInterstitial();
                      }
                      if (openIndex - 1 != playerProvider.currentPlayerIndex) {
                        //Save Clicked Index
                        playerProvider.setCurrentPlayerIndex(
                          index: openIndex - 1,
                          currentPlayerArabicSurahName: isSearch &&
                                  isSearchControllerEmpty
                              ? quranCsv.filterSurah.elementAt(index)[2]
                              : quranCsv.listOfSurahsPart.elementAt(index)[2],
                          currentPlayerTransSurahName: isSearch &&
                                  isSearchControllerEmpty
                              ? quranCsv.filterSurah.elementAt(index)[1]
                              : quranCsv.listOfSurahsPart.elementAt(index)[1],
                        );

                        //
                        playerProvider.setLastPostion(position: Duration.zero);
                        playerProvider.playCurrent();
                        playerProvider.play();
                      } else {
                        playerProvider.resume();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  });
}
