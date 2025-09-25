import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/value_notifier.dart';

Future<void> setTransSheet(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Builder(builder: (context) {
        final quranCsv = Provider.of<QuranCsv>(context);
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Scrollbar(
            child: Column(
              spacing: 10,
              children: [
                const Text("Select Translation"),
                ValueListenableBuilder(
                  valueListenable: turnOffTrans,
                  builder: (context, turnOffTransValue, child) =>
                      SwitchListTile.adaptive(
                    value: turnOffTransValue,
                    title: Text("Turn OFF Translation"),
                    onChanged: (value) {
                      turnOffTrans.value = !turnOffTrans.value;
                      settings.put("turnOffTrans", turnOffTrans.value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioGroup<String>(
                    groupValue: quranCsv.currentQuranTrans,
                    onChanged: (value) {
                      if (value != null) {
                        quranCsv.setChangeTrans(value);
                      }
                    },
                    child: ListView(
                      children: List.generate(
                        quranCsv.transName.length,
                        (index) => Card(
                          child: RadioListTile<String>(
                            value: quranCsv.transName.elementAt(index),
                            title: Text(
                              quranCsv.transName.elementAt(index),
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              quranCsv.transLang.elementAt(index),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
