import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/value_notifier.dart';
import 'package:time_picker_sheet_fork/widget/sheet.dart';
import 'package:time_picker_sheet_fork/widget/time_picker.dart';

class SleepTimer extends StatelessWidget {
  final ThemeColor themeColorProvider;
  final PlayerProvider playerProvider;

  const SleepTimer({
    super.key,
    required this.themeColorProvider,
    required this.playerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: audioSleepTimer,
      builder: (context, timerValue, child) {
        // final int hours = timerValue?.hour ?? 0;
        // final int min = timerValue?.minute ?? 0;
        // final int sec = timerValue?.second ?? 0;

        return GestureDetector(
          onTap: () async {
            if (timerValue == null) {
              final picked = await TimePicker.show<DateTime?>(
                context: context,
                sheet: TimePickerSheet(
                  sheetTitle: "Set Qur'an Sleep Timer",
                  hourTitle: 'Hour',
                  minuteTitle: 'Minute',
                  minuteInterval: 5,
                  minMinute: 1,
                  saveButtonWidget:
                      Text('Set Timer', style: TextStyle(color: Colors.white)),
                  saveButtonStyle: ElevatedButton.styleFrom(
                    backgroundColor: themeColorProvider.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );

              if (picked != null) {
                final pickedDuration =
                    Duration(hours: picked.hour, minutes: picked.minute);
                audioSleepTimer.value = DateTime.now().add(pickedDuration);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: themeColorProvider.control,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (timerValue == null)
                  Icon(Icons.timer, color: themeColorProvider.control),
                const SizedBox(width: 5),
                if (timerValue == null)
                  Text(
                    "Sleep Timer",
                    style: TextStyle(
                        color: themeColorProvider.control,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                if (timerValue != null)
                  IconButton(
                      onPressed: () {
                        audioSleepTimer.value = null;
                      },
                      icon: Icon(Icons.cancel, color: Colors.red)),
                if (timerValue != null)
                  TimerCountdown(
                    format: CountDownTimerFormat.hoursMinutesSeconds,
                    minutesDescription: 'min',
                    secondsDescription: 'sec',
                    hoursDescription: 'hr',
                    endTime: timerValue,
                    onEnd: () {
                      playerProvider.pause();
                      audioSleepTimer.value = null;
                    },
                    timeTextStyle: TextStyle(
                      color: themeColorProvider.control,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
