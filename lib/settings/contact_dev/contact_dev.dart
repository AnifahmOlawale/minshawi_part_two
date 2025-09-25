import 'package:flutter/material.dart';
import 'package:quran_app/util/facebook_dev.dart';
import 'package:quran_app/util/mail_dev.dart';

Future<void> contactSheet(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 200,
          child: Column(
            spacing: 10,
            children: [
              //Facbook contact
              GestureDetector(
                onTap: () {
                  contactDeveloperFB(context);
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.facebook_rounded,
                    size: 40,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text(
                    "Facebook",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              //Mail Contact
              GestureDetector(
                onTap: () {
                  contactDeveloperEmail(context);
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.mail,
                    size: 40,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text(
                    "Email",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
