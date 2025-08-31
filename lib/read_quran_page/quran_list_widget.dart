import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/ads/inter_ads_class.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/read_quran.dart';
import 'package:quran_app/util/appbar_system_style.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/search_text_field.dart';
import 'package:quran_app/widget_tree/listwidget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranListWidget extends StatefulWidget {
  const QuranListWidget({
    super.key,
  });

  @override
  State<QuranListWidget> createState() => _QuranListWidgetState();
}

class _QuranListWidgetState extends State<QuranListWidget> {
  final ItemScrollController _listScrollController = ItemScrollController();

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearch = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final quranCsv = Provider.of<QuranCsv>(context);
    return Scaffold(
      backgroundColor: themeColorProvider.background ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeColorProvider.currentTheme == SetTheme.dark.name
            ? Theme.of(context).colorScheme.surfaceContainer
            : themeColorProvider.secondary,
        foregroundColor: Colors.white,
        title: _isSearch
            ? searchtextField(
                context,
                controller: _searchController,
                focusNode: _searchFocusNode,
                isPlayer: false,
              )
            : Text("Read Qur'an"),
        actions: [
          IconButton(
            tooltip: _isSearch ? "Close Search" : "Search",
            onPressed: () {
              setState(() {
                _searchController.text = "";
                _isSearch = !_isSearch;
                _isSearch
                    ? _searchFocusNode.requestFocus()
                    : FocusScope.of(context).unfocus();
              });
            },
            icon: !_isSearch ? Icon(Icons.search) : Icon(Icons.cancel),
          ),
        ],
        systemOverlayStyle: AppbarSystemStyle().appbarSystemStyle(context),
      ),
      body: PopScope(
        canPop: !_isSearch,
        onPopInvokedWithResult: (didPop, result) {
          setState(() {
            if (_isSearch) {
              _isSearch = !_isSearch;
            }
          });
        },
        child: Scrollbar(
          radius: Radius.circular(100),
          child: Column(
            children: [
              Expanded(
                child: ScrollablePositionedList.builder(
                  initialScrollIndex: quranCsv.currentSurahIndex ?? 0,
                  itemScrollController: _listScrollController,
                  itemCount: _isSearch && _searchController.text.isNotEmpty
                      ? quranCsv.filterSurah.length
                      : quranCsv.listOfSurahs.length,
                  itemBuilder: (context, index) {
                    return surahListTile(
                      context,
                      isPlayer: false,
                      cardColor:
                          quranCsv.currentSurahIndex == index && !_isSearch
                              ? themeColorProvider.selectedCardColour
                              : themeColorProvider.card,
                      selectedColour:
                          quranCsv.currentSurahIndex == index && !_isSearch
                              ? themeColorProvider.selectedTextColour
                              : null,
                      index: _isSearch && _searchController.text.isNotEmpty
                          ? quranCsv.filterSurah.elementAt(index)[0]
                          : quranCsv.listOfSurahs.elementAt(index)[0],
                      title: _isSearch && _searchController.text.isNotEmpty
                          ? quranCsv.filterSurah.elementAt(index)[1]
                          : quranCsv.listOfSurahs.elementAt(index)[1],
                      subTitle: _isSearch && _searchController.text.isNotEmpty
                          ? "${quranCsv.filterSurah.elementAt(index)[3]} | ${quranCsv.filterSurah.elementAt(index)[6]} Verses"
                          : "${quranCsv.listOfSurahs.elementAt(index)[3]} | ${quranCsv.listOfSurahs.elementAt(index)[6]} Verses",
                      arabicName: _isSearch && _searchController.text.isNotEmpty
                          ? quranCsv.filterSurah.elementAt(index)[2]
                          : quranCsv.listOfSurahs.elementAt(index)[2],
                      onCardClick: () async {
                        int openIndex =
                            _isSearch && _searchController.text.isNotEmpty
                                ? quranCsv.filterSurah.elementAt(index)[0]
                                : quranCsv.listOfSurahs.elementAt(index)[0];
                        //If the index is even, Show Ads
                        if (openIndex % 2 == 0) {
                          //Show Interstitial Ad
                          InterstitialAdmob().showInterstitial();
                        }
                        //Save Clicked Index
                        quranCsv.setCurrentSurahIndex(openIndex - 1);

                        //Open Quran Screen
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ReadQuran(),
                            transitionDuration: Duration(seconds: 1),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                        //Scrool To the changed Index
                        if (_isSearch) return;
                        _listScrollController.jumpTo(
                          index: quranCsv.currentSurahIndex ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
              /* Expanded(
                child: AnimationLimiter(
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: quranCsv.currentSurahIndex,
                    itemScrollController: _listScrollController,
                    itemCount: quranCsv.listOfSurahs.length - 2,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 1000),
                        child: SlideAnimation(
                          horizontalOffset: 100,
                          child: FadeInAnimation(
                            child: surahListTile(
                              context,
                              index: index + 1,
                              title: quranCsv.listOfSurahs
                                  .elementAt(index)[0],
                              subTitle: quranCsv.listOfSurahs
                                  .elementAt(index)[2],
                              arabicName: quranCsv.listOfSurahs
                                  .elementAt(index)[1],
                              onCardClick: () async {
                                //Save Clicked Index
                                quranLastRead.put(
                                    "currentSurahIndex", index);
                                //Open Quran Screen
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ReadQuran(
                                      surahIndex: index,
                                    ),
                                    transitionDuration:
                                        Duration(seconds: 1),
                                    transitionsBuilder: (context,
                                        animation,
                                        secondaryAnimation,
                                        child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(
                                              begin: begin, end: end)
                                          .chain(
                                              CurveTween(curve: curve));
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                //Scrool To the changed Index
                                _listScrollController.jumpTo(
                                  index: quranCsv.currentSurahIndex,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
