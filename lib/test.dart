// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
  List<Tache> taches = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: taches.map((tache) {
          return Container(
            width: Get.width,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                border: Border(left: BorderSide(color: Colors.teal, width: 3)),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tache.titre),
                Text(tache.date),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Tache {
  String titre;
  String date;
  String heure;
  int etat;
  Tache({
    required this.titre,
    required this.date,
    required this.heure,
    required this.etat,
  });
}
