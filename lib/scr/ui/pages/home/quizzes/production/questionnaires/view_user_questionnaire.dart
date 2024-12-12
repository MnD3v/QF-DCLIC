// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/question_card.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/user_question_card.dart';
import 'package:my_widgets/data/models/question_type.dart';
import 'package:my_widgets/data/models/questionnaire.dart';

class ViewUserQuestionnaire extends StatefulWidget {
  Questionnaire questionnaire;
  RxBool dejaRepondu;
  String userID;
  ViewUserQuestionnaire(
      {super.key,
      required this.questionnaire,
      required this.dejaRepondu,
      required this.userID});

  @override
  State<ViewUserQuestionnaire> createState() => _ViewUserQuestionnaireState();
}

class _ViewUserQuestionnaireState extends State<ViewUserQuestionnaire> {
  var initalResponses = [];

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var loading = false.obs;

  @override
  void initState() {
    waitAfter(10, () {
      widget.dejaRepondu.value =
          widget.questionnaire!.maked.keys.contains(widget.userID);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.questionnaire.maked.containsKey(widget.userID)) {
      _initialiseResponses();
    } else {
      initalResponses = widget.questionnaire.maked[widget.userID]!.response;
    }
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      return EScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: EText(
            "Questionnaires",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child:    DynamicHeightGridView(
                  physics: BouncingScrollPhysics(),
                itemCount: widget.questionnaire.questions.length,
              crossAxisCount: crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                builder: (ctx, index) {
                  var element = widget.questionnaire.questions[index];
                  var qcmResponse = RxList<String>();
                  var qcuResponse = "".obs;
                  return UserQuestionCard(
                      userID: widget.userID,
                      element: element,
                      index: index,
                      dejaRepondu: widget.dejaRepondu,
                      qcuResponse: qcuResponse,
                      questionnaire: widget.questionnaire,
                      initalResponses: initalResponses,
                      qcmResponse: qcmResponse);
                }),
        ),
      );
    });
  }

  void showDialogForScrore(double points) {
    return Custom.showDialog(
        barrierColor: Colors.black12,
        dialog: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: BlurryContainer(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: EColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    12.h,
                    EText(
                      widget.questionnaire.title.toUpperCase(),
                      align: TextAlign.center,
                      color: Colors.white,
                      size: 22,
                    ),
                    Image(
                      image: AssetImage(Assets.icons("diamant.png")),
                      height: 55,
                    ),
                    EText(
                      "Votre score",
                      color: Colors.white,
                      size: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EText(
                          points.toStringAsFixed(2),
                          font: Fonts.sevenSegment,
                          size: 65,
                          color: const Color.fromARGB(255, 21, 255, 0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: EText(
                            "/${widget.questionnaire.questions.length}",
                            color: const Color.fromARGB(255, 255, 255, 255),
                            size: 24,
                          ),
                        )
                      ],
                    ),
                    SimpleOutlineButton(
                        radius: 9,
                        color: Colors.white60,
                        onTap: () {
                          Get.back();
                        },
                        child: EText(
                          "Fermer",
                          color: Colors.white54,
                        ))
                  ]),
            ),
          ),
        ));
  }

  // void showInputDialogForId(String _id) {
  _initialiseResponses() {
    initalResponses = widget.questionnaire!.questions
        .map((element) => element.type == QuestionType.qcm ? [] : "")
        .toList();
  }
}
