import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/quran_settings_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/basmala.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/value_notifier.dart';
import 'package:share_plus/share_plus.dart';

Widget quranContainer(
  BuildContext context, {
  required int index,
  required String subTitle,
}) {
  final themeColorProvider = Provider.of<ThemeColor>(context);
  return Builder(builder: (context) {
    final quranSettings = Provider.of<QuranSettings>(context, listen: true);
    final quranCsv = Provider.of<QuranCsv>(context, listen: true);
    final GlobalKey<CustomPopupState> popupkey = GlobalKey<CustomPopupState>();
    String copyText =
        "──────⊹⊱✫⊰⊹──────\nSurah ${quranCsv.currentTransSurahName}\nQur'an ${quranCsv.currentSurahIndex! + 1}, Verse ${index + 1}\n──────⊹⊱✫⊰⊹──────\n${quranCsv.currentQuranList.elementAt(index)[0]}\n${subTitle.replaceAll('+', ',').replaceAll('=', ';').replaceAll("<u>", "").replaceAll("</u>", "").replaceAll("<b>", "").replaceAll("</b>", "").replaceAll("<U>", "").replaceAll("</U>", "").replaceAll("<B>", "").replaceAll("</B>", "")}\n━━━━━━ ◦ ❖ ◦ ━━━━━━\nShared via $appName\n${isAndroid ? playStoreLink : appleStoreLink}"; //TODO
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 10,
        children: [
          if (index == 0)
            if (quranCsv.currentSurahIndex != 1 - 1 &&
                quranCsv.currentSurahIndex != 9 - 1)
              //Basmala
              basmala(themeColorProvider: themeColorProvider),
          //Quran
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //Arabic
              SizedBox(
                width: double.infinity,
                child: Text.rich(
                  textAlign: TextAlign.right,
                  locale: Locale("ar"),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: quranCsv.currentQuranList.elementAt(index)[0],
                        style: TextStyle(
                          wordSpacing: 5,
                          height: 2.5,
                          fontFamily: quranSettings.quranFont,
                          color: themeColorProvider.quranText,
                          fontSize: quranSettings.quranFontSize,
                        ),
                      ),
                      TextSpan(
                        text: quranCsv.currentQuranList.elementAt(index)[1],
                        style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            color: themeColorProvider.quranText,
                            fontSize: quranSettings.quranFontSize),
                      )
                    ],
                  ),
                ),
              ),
              //Translation
              /* SizedBox(
                width: double.infinity,
                child: Text(
                  subTitle.replaceAll('+', ',').replaceAll('=', ';'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: themeColorProvider.quranTrans,
                      fontSize: quranSettings.translationFontSize),
                ),
              ),*/
              ValueListenableBuilder(
                  valueListenable: turnOffTrans,
                  builder: (context, turnOffTransValue, child) {
                    return Visibility(
                      visible: !turnOffTransValue,
                      child: Html(
                        data:
                            subTitle.replaceAll('+', ',').replaceAll('=', ';'),
                        style: {
                          "body": Style(
                            textAlign: TextAlign.left,
                            color: themeColorProvider.currentTheme ==
                                    SetTheme.dark.name
                                ? Colors.white
                                : themeColorProvider.quranTrans,
                            fontSize:
                                FontSize(quranSettings.translationFontSize),
                          )
                        },
                      ),
                    );
                  }),
              //More
              CustomPopup(
                backgroundColor:
                    themeColorProvider.currentTheme == SetTheme.dark.name
                        ? Colors.black
                        : Theme.of(context).scaffoldBackgroundColor,
                arrowColor:
                    themeColorProvider.currentTheme == SetTheme.dark.name
                        ? Colors.black
                        : Theme.of(context).scaffoldBackgroundColor,
                key: popupkey,
                position: PopupPosition.auto,
                content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Copy
                      ListTile(
                        title: Text("Copy"),
                        leading: Icon(Icons.copy_rounded),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: copyText));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Copied!"),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          );
                        },
                      ),
                      //Share
                      ListTile(
                        title: Text("Share"),
                        leading: Icon(Icons.share_rounded),
                        onTap: () {
                          Navigator.pop(context);
                          SharePlus.instance.share(ShareParams(
                              text: copyText, subject: "Share Qur'an Verse"));
                        },
                      ),
                      //Bookmark
                      ListTile(
                        title: Text("Bookmark"),
                        leading: Icon(Icons.bookmark_add_rounded),
                        onTap: () {
                          quranCsv.addBookmark(index);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Bookmarked!"),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                child: IconButton(
                    onPressed: () {
                      popupkey.currentState?.show();
                    },
                    icon: Icon(Icons.more_horiz_outlined)),
              ),
            ],
          ),
          //Divider
          if (index != quranCsv.currentQuranList.length - 1)
            Divider(
              thickness: 1.5,
            ),
        ],
      ),
    );
  });
}
