import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/read_quran.dart';
import 'package:quran_app/util/appbar_system_style.dart';
import 'package:quran_app/util/arabic_surah_font_text.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/value_notifier.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranBookmarkWidget extends StatefulWidget {
  const QuranBookmarkWidget({super.key});

  @override
  State<QuranBookmarkWidget> createState() => _QuranBookmarkWidgetState();
}

class _QuranBookmarkWidgetState extends State<QuranBookmarkWidget> {
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
        title: Text("Bookmarks"),
        actions: [
          if (quranCsv.bookmarks.isNotEmpty)
            IconButton(
                tooltip: "Delete all Bookmarks",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog.adaptive(
                        title: Text("Delete all Bookmarks?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    themeColorProvider.currentTheme !=
                                            SetTheme.colured.name
                                        ? Colors.white
                                        : themeColorProvider.background,
                              ),
                              child: Text("No")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              quranCsv.deleteALLBookmarks();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Bookmarks Deleted"),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  themeColorProvider.currentTheme !=
                                          SetTheme.colured.name
                                      ? Colors.white
                                      : themeColorProvider.background,
                            ),
                            child: Text("Yes"),
                          )
                        ],
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                "Are you sure you want to delete all Bookmarks"),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_forever_rounded)),
          const SizedBox(
            width: 10,
          )
        ],
        systemOverlayStyle: AppbarSystemStyle().appbarSystemStyle(context),
      ),
      body: ValueListenableBuilder(
        valueListenable: quranListSwitch,
        builder: (context, navIndexValue, child) => PopScope(
          canPop: navIndexValue == 0,
          onPopInvokedWithResult: (didPop, result) {
            quranListSwitch.value = 0;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 3,
              ),
              if (quranCsv.bookmarks.isNotEmpty)
                Text(
                  "Slide Left to Delete Bookmark",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: themeColorProvider.text),
                ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemCount: quranCsv.bookmarks.length,
                  itemBuilder: (context, index) {
                    int surahIndex = quranCsv
                        .listOfSurahs[quranCsv.bookmarks[index].keys.first]
                        .elementAt(0);

                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (context) {
                                quranCsv.deleteBookmark(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Bookmark Deleted"),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                );
                              },
                              autoClose: true,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            quranCsv.setCurrentSurahIndex(index);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadQuran(),
                                ));
                          },
                          child: Card(
                            color: themeColorProvider.card,
                            child: ListTile(
                              textColor: Colors.white,
                              title: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: quranCsv.listOfSurahs[quranCsv
                                                .bookmarks[index].keys.first]
                                            .elementAt(1)),
                                    TextSpan(
                                        text:
                                            "\nQur'an: $surahIndex | Verse: ${quranCsv.bookmarks[index].values.first + 1}",
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ),
                              trailing: Text(
                                arabicSurahFont(surahIndex),
                                style: TextStyle(
                                    fontFamily: 'ArabicSurah', fontSize: 35),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
