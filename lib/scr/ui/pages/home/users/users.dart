import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class Users extends StatelessWidget {
  Users({super.key});

  final _user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      print(crossAxisCount);
      return FutureBuilder(
          future: DB
              .firestore(Collections.utilistateurs)
              .where("classe", isEqualTo: _user.classe)
              // .orderBy("points", descending: true)
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
              body: DynamicHeightGridView(
                  itemCount: users.length,
                  crossAxisCount: crossAxisCount.toInt(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  builder: (ctx, index) {
                    var user = users[index];
                    return SizedBox(
                      height: 100,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(6),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xff0d1b2a),
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white10,
                                    child: Icon(
                                      CupertinoIcons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                9.w,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EText("${user.nom} ${user.prenom}"),
                                    ETextRich(
                                      textSpans: [
                                        ETextSpan(
                                            text:
                                                user.points.toStringAsFixed(2),
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
                      ),
                    );
                  }),
            );
          });
    });
  }
}
