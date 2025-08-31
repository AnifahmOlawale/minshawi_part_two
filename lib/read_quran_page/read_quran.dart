import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/quran_container.dart';
import 'package:quran_app/read_quran_page/quran_header.dart';
import 'package:quran_app/read_quran_page/set_current_translation.dart';
import 'package:quran_app/settings/set_font_size/set_font_size.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/appbar_system_style.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReadQuran extends StatefulWidget {
  const ReadQuran({super.key});

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  final ItemScrollController _quranScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  final ValueNotifier<bool> _isBottomVisible = ValueNotifier<bool>(true);

  double _lastIndex = 0;

  @override
  void initState() {
    super.initState();

    // currentSurahIndex = widget.surahIndex;

    _isBottomVisible.value = true;

    _itemPositionsListener.itemPositions.addListener(
      () {
        final positions = _itemPositionsListener.itemPositions.value;
        if (positions.isNotEmpty) {
          //
          final visibleItems = positions
              .where(
                (pos) => pos.itemLeadingEdge > 0,
              )
              .toList();
          if (visibleItems.isNotEmpty) {
            final currentIndex = positions
                .where(
                  (pos) => pos.itemLeadingEdge >= 0,
                )
                .reduce(
                  (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
                )
                .index
                .toDouble();

            if (currentIndex > _lastIndex && _isBottomVisible.value) {
              _isBottomVisible.value = false; //Scroll Down Hide
            } else if (currentIndex < _lastIndex && !_isBottomVisible.value) {
              //
              _isBottomVisible.value = true; //Scroll Up Show
            }
            _lastIndex = currentIndex;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _isBottomVisible.dispose();
    super.dispose();
  }

  void preloadImages(BuildContext context) {
    precacheImage(AssetImage("assets/images/basmala.png"), context);
    precacheImage(AssetImage("assets/images/surahframe.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    preloadImages(context);
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final quranCsv = Provider.of<QuranCsv>(context, listen: true);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppbarSystemStyle().appbarSystemStyle(context),
      child: Scaffold(
        appBar: !isAndroid
            ? AppBar(
                title: Text(
                  quranCsv.currentTransSurahName,
                ),
              )
            : null,
        backgroundColor:
            themeColorProvider.background ?? themeColorProvider.primary,
        body: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            //SET THE LAST VEARSE
            final positions = _itemPositionsListener.itemPositions.value;
            if (positions.isNotEmpty) {
              quranCsv.setCsurrentVerseIndex(positions.first.index);
            }
          },
          child: SafeArea(
            child: ColoredBox(
              color: themeColorProvider.quranBackground ??
                  Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        //QuranHeader
                        quranHeader(title: quranCsv.currentArabicSurahName),
                        //QuranList
                        Expanded(
                          child: Scrollbar(
                            radius: Radius.circular(100),
                            child: ScrollablePositionedList.builder(
                              itemScrollController: _quranScrollController,
                              itemPositionsListener: _itemPositionsListener,
                              initialScrollIndex: quranCsv.currentVerseIndex,
                              itemCount: quranCsv.currentQuranList.length,
                              itemBuilder: (context, index) {
                                return quranContainer(
                                  context,
                                  index: index,
                                  subTitle: quranCsv.isTransCSV
                                      ? quranCsv.currentQuranList
                                              .elementAt(index)[
                                          quranCsv.indexOfCurrentTransCSV!]
                                      : quranCsv.currentTransFromDow[index][0],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Quran Navigation
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ValueListenableBuilder(
                        valueListenable: _isBottomVisible,
                        builder: (context, isVisible, child) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: isVisible ? 60 : 0,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Card(
                                child: SizedBox(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      //Previous
                                      IconButton(
                                        onPressed: () {
                                          quranCsv.previousSurah();

                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                            (timeStamp) {
                                              return _quranScrollController
                                                  .jumpTo(
                                                      index: 0, alignment: 0);
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.arrow_back_ios),
                                      ),
                                      //Text Size
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            setFontSize(context);
                                          },
                                          icon: Icon(Icons.format_size_rounded),
                                        ),
                                      ),
                                      //Translation
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            setTransSheet(context);
                                          },
                                          icon: Icon(Icons.translate_rounded),
                                        ),
                                      ),
                                      //Next
                                      IconButton(
                                        onPressed: () {
                                          quranCsv.netxSurah();

                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                            (timeStamp) {
                                              return _quranScrollController
                                                  .jumpTo(
                                                      index: 0, alignment: 0);
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
