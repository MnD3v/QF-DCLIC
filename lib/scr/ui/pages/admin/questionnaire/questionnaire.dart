import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/data/repository/const.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class CreateQuestionnaire extends StatelessWidget {
  CreateQuestionnaire({super.key});

  var questions = RxList<Question>();

  var titre = "";
  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back(id: 1);
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: EText(
          "Questionnaire",
          color: Colors.amber,
          size: 24,
          weight: FontWeight.bold,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: EColumn(
            children: [
              EText("Titre du questionnaire"),
              6.h,
              ETextField(
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
                    .map(
                        (element) => element.type == QuestionType.qcm ? [] : "")
                    .toList();
                return QuestionCard(
                  dejaRepondu: false.obs,
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
                  radius: 6,
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
                    color: Colors.amber,
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SimpleButton(
          radius: 3,
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

            var q = await DB.firestore(Collections.utils).doc("lastID").get();
            var lastIDKey = q.data()!["lastID"];
            print(lastIDKey);
            var id = ids[lastIDKey];

            var questionnaire = Questionnaire(
                id: id!,
                date: DateTime.now().toString(),
                title: titre,
                maked: {},
                questions: questions.value);

            await DB
                .firestore(Collections.classes)
                .doc(user.classe)
                .collection(Collections.questionnaires)
                .doc(id!)
                .set(questionnaire.toMap());
            lastIDKey += 1;
            await DB
                .firestore(Collections.utils)
                .doc("lastID")
                .set({"lastID": lastIDKey});
          },
          child: EText(
            "Enregistrer",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
