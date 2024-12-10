import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class Users extends StatelessWidget {
  Users({super.key});

  final user = Utilisateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DB
            .firestore(Collections.utilistateurs)
            .where("classe", isEqualTo: user.classe)
            .get(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }
          var users = <Utilisateur>[];
          snapshot.data!.docs.forEach((element) {
            users.add(Utilisateur.fromMap(element.data()));
          });
          return EScaffold(
              body: EColumn(
                  children: users.map((user) {
            return  Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.background,
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  9.w,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EText("${user.nom} ${user.prenom}"),
                                      ETextRich(
                                        textSpans: [
                                          ETextSpan(
                                              text: user.points.toStringAsFixed(2),
                                              color: Colors.greenAccent),
                                          
                                        ],
                                        size: 30,
                                        font: Fonts.sevenSegment,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right_rounded)
                            ],
                          ),
                        );
          }).toList()));
        });
  }
}
