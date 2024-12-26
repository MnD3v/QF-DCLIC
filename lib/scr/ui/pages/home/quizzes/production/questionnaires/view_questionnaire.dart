// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';


import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/question_card.dart';
import 'package:my_widgets/my_widgets.dart';

class ViewQuestionnaire extends StatefulWidget {
  Questionnaire questionnaire;
  RxBool dejaRepondu;
  String? idUser;

  ViewQuestionnaire(
      {super.key, required this.questionnaire,this.idUser, required this.dejaRepondu});

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
  Widget build(BuildContext context) {
    if (!widget.questionnaire!.maked.containsKey(telephone)) {
      _initialiseResponses();
    } else {
      initalResponses = widget.questionnaire!.maked[telephone]!.response;
    }
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth ;
      final crossAxisCount = width / 400;

        return EScaffold(
          appBar: AppBar(
           
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: EText("Questionnaire", size: 24, weight: FontWeight.bold,),
         ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child:
            
                       DynamicHeightGridView(
                  physics: BouncingScrollPhysics(),
                    itemCount: widget.questionnaire!.questions.length,
                 crossAxisCount: crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    builder: (ctx, index) {
                      var element =  widget.questionnaire.questions[index];
                      var qcmResponse = RxList<String>([]);
                var qcuResponse = "".obs;
                return QuestionCard(
                  questions: widget.questionnaire.questions.obs,
                  idUser: widget.idUser,
                    element: element,
                    index: index,
                    dejaRepondu: widget.dejaRepondu,
                    qcuResponse: qcuResponse,
                    questionnaire: widget.questionnaire,
                    initalResponses: initalResponses,
                    qcmResponse: qcmResponse);
                    })
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
