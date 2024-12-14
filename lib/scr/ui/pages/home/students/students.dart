import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';

import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/student_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
import 'package:lottie/lottie.dart';

class Students extends StatelessWidget {
  Students({super.key});
  final formateur = Utilisateur.currentUser.value!;
  var users = RxList<Utilisateur>([]);

  var user = Utilisateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      print(crossAxisCount);
      return FutureBuilder(
          future: DB
              .firestore(Collections.classes)
              .doc(formateur.classe)
              .collection(Collections.utilistateurs)
              .orderBy("points", descending: true)
              .get(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot)) {
              return ECircularProgressIndicator();
            }
            var tempUsers = <Utilisateur>[];
            for (var element in snapshot.data!.docs) {
              tempUsers.add(Utilisateur.fromMap(element.data()));
            }
            users.value = tempUsers;
            return EScaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading:Get.width>600?null: MenuBoutton(user: user, constraints: constraints, width: width), title: EText(
                  "Etudiants",
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: width / 3,
                      child: ETextField(
                          radius: 12,
                          border: true,
                          placeholder: "Rechercher",
                          onChanged: (value) {
                            users.value = tempUsers
                                .where((element) =>
                                    ("${element.nom} ${element.prenom}")
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          },
                          phoneScallerFactor: phoneScallerFactor),
                    ),
                  )
                ],
              ),
              body: Obx(
                () => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: users.isEmpty
                      ? Empty(
                              constraints: constraints,
                            )
                      : DynamicHeightGridView(
                          key: Key(users.length.toString()),
                          physics: BouncingScrollPhysics(),
                          itemCount: users.length,
                          crossAxisCount: crossAxisCount.toInt() <= 0
                              ? 1
                              : crossAxisCount.toInt(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          builder: (ctx, index) {
                            var user = users[index];
                            return StudentCard(user: user);
                          }),
                ),
              ),
            );
          });
    });
  }
}
