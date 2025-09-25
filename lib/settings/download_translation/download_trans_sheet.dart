import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/settings/download_translation/downloade_translation.dart';
import 'package:quran_app/settings/download_translation/supabase_get_trans_list.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/value_notifier.dart';

Future<void> downloadTransSheet(BuildContext context) {
  int? downloadingIndex;
  isDownloading.value = false;

  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Builder(
        builder: (context) {
          final quranCsv = Provider.of<QuranCsv>(context);
          return ValueListenableBuilder<
              Future<List<Map<String, dynamic>>?> Function()>(
            valueListenable: downlaodTransNotifier,
            builder: (context, downlaodTransNotifierValue, child) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: FutureBuilder<List<Map<String, dynamic>>?>(
                  future: downlaodTransNotifierValue(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: 50,
                          ),
                          Text(
                            "Failed to load translations, try again",
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              // Assign a NEW function (even though same logic) to notify listeners
                              downlaodTransNotifier.value =
                                  () => getTransList();
                            },
                            child: Text("Try again"),
                          )
                        ],
                      );
                    }
                    final data = snapshot.data!;

                    return Scrollbar(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          height: 60,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          imageUrl: data[index]["flag"],
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        data[index]["trans_name"],
                                      ),
                                      subtitle: Text(
                                        data[index]["trans_lang"],
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      trailing: ValueListenableBuilder(
                                        valueListenable: isDownloading,
                                        builder: (context, isDownloadingValue,
                                            child) {
                                          final List availableTrans =
                                              downloadedTranslations.keys
                                                  .toList();
                                          //checking if the translation is available
                                          if (availableTrans.contains(
                                              data[index]["trans_name"]
                                                  .toString())) {
                                            return IconButton(
                                              onPressed: () {
                                                if (!isDownloadingValue) {
                                                  downloadedTranslations.delete(
                                                      data[index]
                                                          ["trans_name"]);
                                                  downloadedTranslationsInfo
                                                      .delete(data[index]
                                                          ["trans_name"]);
                                                  isDownloading.value = true;
                                                  isDownloading.value = false;
                                                  quranCsv.initTrans();
                                                }
                                              },
                                              icon: Icon(Icons.delete_rounded),
                                            );
                                          } else if (downloadingIndex ==
                                                  index &&
                                              isDownloadingValue) {
                                            return CircularProgressIndicator();
                                          }
                                          return IconButton(
                                            onPressed: () {
                                              if (!isDownloadingValue) {
                                                downloadingIndex = index;
                                                isDownloading.value = true;
                                                fetchCSVFromGoogleSheet(
                                                    data: data[index]);
                                              }
                                            },
                                            icon: Icon(Icons.download_rounded),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Source of translation by Tanzil International Qur'anic Project",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 35,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      );
    },
  );
}
