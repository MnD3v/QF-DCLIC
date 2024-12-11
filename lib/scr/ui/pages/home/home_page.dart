// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:async';
import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/ardoise.dart';
import 'package:immobilier_apk/scr/ui/pages/home/brouillon/ardoise/ardoise_brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/brouillon/brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/brouillon/questionnaire/questionnaire_brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/all_questionnaires.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/create_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/students.dart';
import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class HomePage extends StatefulWidget {
  static var newQuestionnaires = 0.obs;
  static var newQuestionsArdoise = 0.obs;
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initalResponses = [];

  var dejaRepondu = false.obs;

  var id = "".obs;

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var currentIndex = 0.obs;

  var loading = false.obs;

  @override
  void initState() {
    streamQuestionsAndUpdate();
    streamQuestionnairesAndUpdate();
    super.initState();
  }

  var pages = [
    Students(),
    Navigator(
      key: Get.nestedKey(2), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) => SizedBox(
            width: 700,
            child: Ardoise(),
          ),
        );
      },
    ),
    Navigator(
      key: Get.nestedKey(1), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) =>
              SizedBox(width: 700, child: ViewAllQuestionnaires()),
        );
      },
    ),
    Navigator(
      key: Get.nestedKey(3), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) =>
              SizedBox(width: 700, child: QuestionnaireBrouillon()),
        );
      },
    ),
    Navigator(
      key: Get.nestedKey(4), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) => SizedBox(width: 700, child: ArdoiseBrouillon()),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      return EScaffold(
          body: Center(
        child: Row(
          children: [
            Container(
              width: 240,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 16, 0, 43),
             
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EText("Menu"),
                    9.h,
                    MneuItem(
                      currentIndex: currentIndex,
                      label: "Etudiants",
                      icon: CupertinoIcons.person_3,
                      index: 0,
                    ),
                    MneuItem(
                      currentIndex: currentIndex,
                      label: "Ardoise",
                      icon: CupertinoIcons.square,
                      index: 1,
                    ),
                    MneuItem(
                      currentIndex: currentIndex,
                      label: "Questionnaires",
                      icon: CupertinoIcons.question_diamond_fill,
                      index: 2,
                    ),
                    12.h,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.archivebox,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              9.w,
                              EText("Brouillon",
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ],
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    12.h,
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Obx(
                        () => Column(
                          children: [
                            3.h,
                            GestureDetector(
                              onTap: () {
                                currentIndex.value = 3;
                                // waitAfter(50, () {
                                //   Get.to(QuestionnaireBrouillon(), id: 3);
                                // });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                  color: Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.question_diamond,
                                      color: currentIndex.value == 3
                                          ? Colors.amber
                                          : Colors.white60,
                                    ),
                                    6.w,
                                    EText(
                                      "Questionnaires",
                                      color: currentIndex.value == 3
                                          ? Colors.amber
                                          : Colors.white60,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            6.h,
                            GestureDetector(
                              onTap: () {
                                currentIndex.value = 4;
                              },
                              child: Container(
                                height: 40,

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.square,
                                      color: currentIndex.value == 4
                                          ? Colors.amber
                                          : Colors.white60,
                                    ),
                                    6.w,
                                    EText(
                                      "Ardoise",
                                      color: currentIndex.value == 4
                                          ? Colors.amber
                                          : Colors.white60,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
            Obx(
              () => SizedBox(
                  width: width - 240,
                  child: AnimatedSwitcher(
                      duration: 666.milliseconds,
                      child: SizedBox(
                          key: Key(currentIndex.value.toString()),
                          child: pages[currentIndex.value]))),
            ),
          ],
        ),
      )

          // PageView(
          //   controller: pageController,
          //   onPageChanged: (index) {
          //     currentPageIndex.value = index;
          //   },
          //   children: [ViewAllQuestionnaires(), Ardoise(), Compte()],
          // ),

          );
    });
  }
}

class MneuItem extends StatelessWidget {
  String label;
  IconData icon;
  RxInt currentIndex;
  int index;
  MneuItem(
      {super.key,
      required this.icon,
      required this.currentIndex,
      required this.label,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          currentIndex.value = index;
        },
        child: Obx(
          () => AnimatedContainer(
              duration: 333.milliseconds,
              height: 40,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(vertical: 6),
              width: Get.width,
              decoration: BoxDecoration(
                  color: currentIndex.value == index
                      ? Colors.amber
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: currentIndex.value == index
                            ? Colors.black
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      9.w,
                      EText(label,
                          color: currentIndex.value == index
                              ? Colors.black
                              : const Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: currentIndex.value == index
                        ? Colors.black
                        : const Color.fromARGB(0, 255, 255, 255),
                    size: 15,
                  )
                ],
              )),
        ));
  }
}

StreamSubscription streamQuestionsAndUpdate() {
  var user = Utilisateur.currentUser.value!;

  // Téléphone de l'utilisateur actuel
  var telephone = Utilisateur.currentUser.value!.telephone_id;

  // Souscription au flux de données Firestore
  return DB
      .firestore(Collections.classes)
      .doc(user.classe)
      .collection(Collections.ardoise)
      .orderBy("date", descending: true)
      .snapshots()
      .listen((snapshot) {
    // Liste des questions à mettre à jour
    List<ArdoiseQuestion> questions = [];

    // Traitement des documents reçus
    for (var element in snapshot.docs) {
      questions.add(ArdoiseQuestion.fromMap(element.data()));
    }

    // Mise à jour de `newQuestionsArdoise` avec le nombre de nouvelles questions
    HomePage.newQuestionsArdoise.value = questions
        .where((element) => !element.maked.containsKey(telephone))
        .length;
  }, onError: (error) {
    // Gestion des erreurs éventuelles
    print('Erreur lors du streaming : $error');
  });
}

StreamSubscription streamQuestionnairesAndUpdate() {
  var user = Utilisateur.currentUser.value!;

  // Téléphone de l'utilisateur actuel
  var telephone = Utilisateur.currentUser.value!.telephone_id;

  // Souscription au flux de données Firestore
  return DB
      .firestore(Collections.classes)
      .doc(user.classe)
      .collection(Collections.questionnaires)
      .orderBy("date", descending: true)
      .snapshots()
      .listen((snapshot) {
    // Liste des questionnaires à mettre à jour
    List<Questionnaire> questionnaires = [];

    // Traitement des documents reçus
    for (var element in snapshot.docs) {
      questionnaires.add(Questionnaire.fromMap(element.data()));
    }

    // Mise à jour de `newQuestionnaires` avec le nombre de nouveaux questionnaires
    HomePage.newQuestionnaires.value = questionnaires
        .where((element) => !element.maked.containsKey(telephone))
        .length;
  }, onError: (error) {
    // Gestion des erreurs éventuelles
    print('Erreur lors du streaming : $error');
  });
}
