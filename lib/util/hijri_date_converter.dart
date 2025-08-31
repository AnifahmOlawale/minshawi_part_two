import 'package:flutter/material.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/util/datepicker.dart';

void convertDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePickerDialog(context);
  if (pickedDate != null) {
    if (!context.mounted) return;
    converthijriDateSheet(context, gregorianDate: pickedDate);
  }
}

Future<void> converthijriDateSheet(BuildContext context,
    {required DateTime gregorianDate}) {
  final HijriCalendarConfig hijriDate =
      HijriCalendarConfig.fromGregorian(gregorianDate);

  String convertedDate =
      hijriDate.toFormat("DDDD - dd - MMMM - yyyy").toString();

  String inputDate =
      DateFormat("EEEE - dd - MMMM - yyyy").format(gregorianDate).toString();
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          // height: 170,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                inputDate,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                Icons.swap_vert_rounded,
                color: Colors.red,
              ),
              Text(
                "$convertedDate AH",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });
    },
  );
}
