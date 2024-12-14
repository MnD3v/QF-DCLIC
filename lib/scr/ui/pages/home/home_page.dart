// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:async';
import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/ardoise.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/brouillon/ardoise/ardoise_brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/brouillon/questionnaire/questionnaire_brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/view_all_questionnaires.dart';

import 'package:immobilier_apk/scr/ui/pages/home/students/students.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/menu.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:my_widgets/data/models/ardoise_question.dart';
import 'package:my_widgets/data/models/questionnaire.dart';

var currentMenuIndex = 0.obs;

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

  var loading = false.obs;

  @override
  void initState() {
    streamQuestionsAndUpdate();
    streamQuestionnairesAndUpdate();
    super.initState();
  }

  var menuIsOpen = false.obs;

  var pages = [
    Navigator(
      key: Get.nestedKey(0), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) => SizedBox(
            width: 700,
            child: Students(),
          ),
        );
      },
    ),
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

  var showBrouillonElements = true.obs;

  var user = Utilisateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      print(constraints.maxWidth);
      return EScaffold(
          body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Row(
              children: [
                constraints.maxWidth < 600
                    ? 0.h
                    : Menu(
                        maxHeight: constraints.maxHeight,
                        width: width,
                        user: user,
                        currentIndex: currentMenuIndex,
                        showBrouillonElements: showBrouillonElements),
                Obx(
                  () => SizedBox(
                      width: constraints.maxWidth < 600 ? width : width - 240,
                      child: AnimatedSwitcher(
                          duration: 666.milliseconds,
                          child: SizedBox(
                              key: Key(currentMenuIndex.value.toString()),
                              child: pages[currentMenuIndex.value]))),
                ),
              ],
            ),
          ),
        ],
      ));
    });
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
    snapshot.docs.toList().forEach((element) async {
      questionnaires.add(await Questionnaire.fromMap(element.data()));
    });

    // Mise à jour de `newQuestionnaires` avec le nombre de nouveaux questionnaires
    HomePage.newQuestionnaires.value = questionnaires
        .where((element) => !element.maked.containsKey(telephone))
        .length;
  }, onError: (error) {
    // Gestion des erreurs éventuelles
    print('Erreur lors du streaming : $error');
  });
}
