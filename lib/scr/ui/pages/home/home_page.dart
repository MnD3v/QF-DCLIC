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
import 'package:immobilier_apk/scr/ui/pages/home/students/presence/presence.dart';

import 'package:immobilier_apk/scr/ui/pages/home/students/evolution/students.dart';
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



  PageController pageController = PageController();

  var loading = false.obs;

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
     Navigator(
      key: Get.nestedKey(5), // Clé pour le Navigator local
      initialRoute: '/', // Page initiale
      onGenerateRoute: (settings) {
        // Par défaut, afficher HomePage
        return MaterialPageRoute(
          builder: (context) => SizedBox(
            width: 700,
            child: Presence(),
          ),
        );
      },
    ),
  ];

  var showBrouillonElements = true.obs;

  var user = Formateur.currentUser.value!;
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
                      width: constraints.maxWidth < 600 ? width : width - 245,
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
