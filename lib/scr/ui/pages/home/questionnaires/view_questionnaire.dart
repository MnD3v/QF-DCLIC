// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';


import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class ViewQuestionnaire extends StatefulWidget {
  Questionnaire questionnaire;
  RxBool dejaRepondu;

  ViewQuestionnaire(
      {super.key, required this.questionnaire, required this.dejaRepondu});

  @override
  State<ViewQuestionnaire> createState() => _ViewQuestionnaireState();
}

class _ViewQuestionnaireState extends State<ViewQuestionnaire> {
  var initalResponses = [];

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var loading = false.obs;

  var telephone = Utilisateur.currentUser.value!.telephone_id;

  @override
  void initState() {
    waitAfter(10, (){
    widget.dejaRepondu.value =
        widget.questionnaire!.maked.keys.contains(telephone);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.questionnaire!.maked.containsKey(telephone)) {
      _initialiseResponses();
    } else {
      initalResponses = widget.questionnaire!.maked[telephone]!.response;
    }
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 900.0 ? 900.0 : constraints.maxWidth;

        return EScaffold(
          appBar: AppBar(
             leading: IconButton(
                onPressed: () {
                  Get.back(id: 1);
                },
                icon: Icon(Icons.arrow_back)),
            backgroundColor: Color(0xff0d1b2a),
            surfaceTintColor: Color(0xff0d1b2a),
            title: EText("Questionnaire", size: 22,),
         ),
          color: Color.fromARGB(255, 24, 49, 77),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: EColumn(children: [
              12.h,
              Container(
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                   borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EText(
                    widget.questionnaire!.title.toUpperCase(),
                    align: TextAlign.center,
                    size: 22,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              12.h,
              ...widget.questionnaire!.questions.map((element) {
                var qcmResponse = RxList<String>([]);
                var qcuResponse = "".obs;
                var index = widget.questionnaire!.questions.indexOf(element);
                return QuestionCard(
                    element: element,
                    index: index,
                    dejaRepondu: widget.dejaRepondu,
                    qcuResponse: qcuResponse,
                    questionnaire: widget.questionnaire,
                    initalResponses: initalResponses,
                    qcmResponse: qcmResponse);
              }).toList(),
           24.h
            ]),
          ),
        );
      }
    );
  }


  void showDialogForScrore(double points) {
    return Custom.showDialog(
        barrierColor: Colors.black12,
        dialog: Dialog(
          backgroundColor:  Colors.transparent,
          surfaceTintColor:  Colors.transparent,
          child: BlurryContainer(
            decoration: BoxDecoration(color: Colors.black.withOpacity(.7), borderRadius: BorderRadius.circular(12)),
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
                            "/" +
                                widget.questionnaire!.questions.length.toString(),
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
