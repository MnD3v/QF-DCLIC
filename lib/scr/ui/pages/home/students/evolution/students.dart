import 'package:csv/csv.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'dart:html';

import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/student_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
import 'package:lottie/lottie.dart';

class Students extends StatelessWidget {
  Students({super.key});
  final formateur = Utilisateur.currentUser.value!;
  var users = Rx<List<Utilisateur>?>(null);

  var user = Utilisateur.currentUser.value!;

  var downloadLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 250;
      print(crossAxisCount);
      return FutureBuilder(
          future: DB
              .firestore(Collections.classes)
              .doc(formateur.classe)
              .collection(Collections.utilistateurs)
              .orderBy("points", descending: true)
              .get(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot) && users.value.isNul) {
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
                leading: Get.width > 600
                    ? null
                    : MenuBoutton(
                        user: user, constraints: constraints, width: width),
                title: EText(
                  "Etudiants",
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white24,
                        ),
                        SizedBox(
                          width: width / 3,
                          child: ETextField(
                              smallHeight: true,
                              radius: 40,
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
                      ],
                    ),
                  ),
                  Obx(()=>
                     downloadLoading.value
                        ? ECircularProgressIndicator(
                            height: 20,
                          )
                        : IconButton(
                            onPressed: () {
                              save();
                            },
                            icon: Icon(Icons.download_rounded)),
                  ),
                  12.w,
                ],
              ),
              body: Obx(
                () => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: users.value!.isEmpty
                      ? Empty(
                          constraints: constraints,
                        )
                      : DynamicHeightGridView(
                          key: Key(users.value!.length.toString()),
                          physics: BouncingScrollPhysics(),
                          itemCount: users.value!.length,
                          crossAxisCount: crossAxisCount.toInt() <= 0
                              ? 1
                              : crossAxisCount.toInt(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          builder: (ctx, index) {
                            var user = users.value![index];
                            return StudentCard(user: user);
                          }),
                ),
              ),
            );
          });
    });
  }

  void save() async {
    downloadLoading.value = true;
    // Exemple de données des utilisateurs
    var students = users.value!.map((element) => element).toList();
    var studentsMap = users.value!.map((element) => element.toMap()).toList();

    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .doc(user.classe)
        .collection(Collections.production)
        .get();

    var quizMaked = 0;
    for (var student in students) {
      quizMaked = 0;
      double points = 0;
      print("****************");

      for (var element in q.docs) {
        var q = await DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.questionnaires)
            .doc(user.classe)
            .collection(Collections.production)
            .doc(element.id)
            .collection(Collections.maked)
            .doc(student.telephone_id)
            .get();
        if (q.exists) {
          quizMaked++;
          print(q.data()!["pointsGagne"].toString() +
              " " +
              jsonDecode(q.data()!["response"]).length.toString());
          points += q.data()!["pointsGagne"] *
              100 /
              jsonDecode(q.data()!["response"]).length;
        }
      }
      print("****************");
      var index = students.indexOf(student);
      studentsMap[index].putIfAbsent("quiz_effectue", () => quizMaked);
      studentsMap[index].putIfAbsent("reussite", () => points / quizMaked);
    }
    List<List<dynamic>> rows = [
      [
        "Nom",
        "Prénom",
        "Numéro",
        "Heures Présence",
        "Quiz effectués",
        "Quiz total",
        "Moyenne de réussite"
      ], // En-tête
      for (var student in studentsMap)
        [
          "${student["nom"]}", // Ajout de guillemets pour les champs texte
          "${student["prenom"]}",
          "${student["telephone_id"]}",
          student["heuresTotal"] ?? "0",
          student["quiz_effectue"],
          q.docs.length,
          student["reussite"].toDouble().toStringAsFixed(2),
        ]
    ];

    // Convertit les lignes en contenu CSV
    String csvContent = const ListToCsvConverter().convert(rows);

    // Encode en UTF-8 pour obtenir des octets
    final bytes = utf8.encode(csvContent);

    // Crée un blob avec les octets
    final blob = Blob([bytes], 'text/csv;charset=utf-8');
    final url = Url.createObjectUrlFromBlob(blob);

    // Crée un lien de téléchargement
    final anchor = AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'etudiants.csv'
      ..click();

    // Nettoie l'URL après le téléchargement
    Url.revokeObjectUrl(url);
    downloadLoading.value = false;
  }
}
