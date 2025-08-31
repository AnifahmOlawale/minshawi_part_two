import 'package:quran_app/main.dart';
import 'package:quran_app/util/hive_box.dart';

Future<List<Map<String, dynamic>>?> getTransList() async {
  try {
    final transList = await supabase
        .from("list_of_quran_translations")
        .select()
        .order('trans_lang', ascending: true)
        .timeout(Duration(seconds: 5));

    final transNameList = await supabase
        .from("list_of_quran_translations")
        .select("trans_name")
        .order('trans_lang', ascending: true)
        .timeout(Duration(seconds: 5));
    final List<String> names = transNameList
        .map(
          (e) => e["trans_name"] as String,
        )
        .toList();

    final List availableTrans = downloadedTranslations.keys.toList();

    for (var element in availableTrans) {
      if (!names.contains(element)) {
        downloadedTranslations.delete(element);
        downloadedTranslationsInfo.delete(element);
      }
    }
    return transList;
  } catch (e) {
    //
    return null;
  }
}
