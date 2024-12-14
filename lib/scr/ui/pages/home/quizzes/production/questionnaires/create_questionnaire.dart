import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/data/repository/const.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/question_card.dart';
import 'package:my_widgets/data/models/questionnaire.dart';
import 'package:my_widgets/my_widgets.dart';

class CreateQuestionnaire extends StatefulWidget {
  Questionnaire? questionnaire;
  CreateQuestionnaire({super.key, this.brouillon, this.questionnaire});

  final bool? brouillon;

  @override
  State<CreateQuestionnaire> createState() => _CreateQuestionnaireState();
}

class _CreateQuestionnaireState extends State<CreateQuestionnaire> {
  var questions = RxList<Question>();

  var titre = "";

  final _loading = false.obs;

  @override
  void initState() {
    if (widget.questionnaire != null) {
      questions.value = widget.questionnaire!.questions;
      titre = widget.questionnaire!.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

      return EScaffold(
        appBar: AppBar(backgroundColor: AppColors.background900,),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background900, borderRadius: BorderRadius.circular(12)),
            width: width,
            child: EScaffold(
              color: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: EText(
                  "Questionnaire",
                  color: Colors.pinkAccent,
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleButton(
                  radius: 12,
                  width: 120,
                  onTap: () async {
                    var user = Utilisateur.currentUser.value!;
          
                    if (titre.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Veuillez saisir le titre du questionnaire");
                      return;
                    }
                    if (questions.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Veuillez ajouter au moin une question");
                      return;
                    }
                    _loading.value = true;
          
                    var id = DateTime.now().millisecondsSinceEpoch.toString();
          
                    //verifier si c'est une mise a jour
                    if (widget.questionnaire != null) {
                      id = widget.questionnaire!.id;
                    }
                    //verifier si c'est une mise a jour
          
                    var questionnaire = Questionnaire(
                        id: id,
                        date: DateTime.now().toString(),
                        title: titre,
                        maked: {},
                        questions: questions);
                    if (widget.brouillon == true) {
                      questionnaire.save( brouillon: true);
                    } else {
                      questionnaire.save( brouillon: false);
                    }
          
                    _loading.value = false;
          
                    Get.back(id: widget.brouillon == true ? 3 : 1);
                  },
                  child: Obx(
                    () => _loading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.2,
                              color: Colors.white,
                            ),
                          )
                        : EText(
                     widget.brouillon == true?       "Enregistrer": "Publier",
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
                ],
              ),
              body: Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EColumn(
                    children: [
                      EText("Titre du questionnaire"),
                      6.h,
                      ETextField(
                          initialValue: titre,
                          placeholder: "Saisissez le questionnaire",
                          onChanged: (value) {
                            titre = value;
                          },
                          phoneScallerFactor: phoneScallerFactor),
                      12.h,
                      Column(
                          children: questions.value.map((element) {
                        var index = questions.indexOf(element);
                        var initalResponses = questions
                            .map((element) =>
                                element.type == QuestionType.qcm ? [] : "")
                            .toList();
                        return QuestionCard(
                          idUser: null,
                          dejaRepondu: true.obs,
                          element: element,
                          index: index,
                          initalResponses: initalResponses,
                          qcmResponse: RxList(),
                          qcuResponse: RxString(""),
                          questionnaire: Questionnaire(
                              id: "",
                              date: DateTime.now().toString(),
                              title: "title",
                              maked: {},
                              questions: questions),
                        );
                      }).toList()),
                      12.h,
                      EText("Ajouter des questions"),
                      6.h,
                      SimpleOutlineButton(
      
                          onTap: () {
                            Get.dialog(
                              Dialog(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 700),
                                    child: AddQuestion(
                                      questions: questions,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: EText(
                            "Ajouter",
                            color: Colors.pinkAccent,
                          )),
                    ],
                  ),
                ),
              ),
        
            ),
          ),
        ),
      );
    });
  }
}
