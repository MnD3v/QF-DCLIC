import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/create_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_responses.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/widgets/questionnaire_card.dart';
import 'package:lottie/lottie.dart';

class QuestionnaireBrouillon extends StatelessWidget {
  QuestionnaireBrouillon({
    super.key,
  });

  var questionnaires = <Questionnaire>[];
  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
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
        body: StreamBuilder(
            stream: DB
                .firestore(Collections.classes)
                .doc(user.classe)
                .collection(Collections.brouillon)
                .doc(user.classe)
                .collection(Collections.questionnaires)
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot)) {
                return ECircularProgressIndicator();
              }

              var telephone = Utilisateur.currentUser.value!.telephone_id;
              questionnaires.clear();
              snapshot.data!.docs.forEach((element) {
                questionnaires.add(Questionnaire.fromMap(element.data()));
              });

              return AnimatedSwitcher(
                duration: 666.milliseconds,
                child: questionnaires.isEmpty?Lottie.asset(Assets.image("empty.json"),  height: 400): DynamicHeightGridView(
                    key: Key(questionnaires.length.toString()),
                    itemCount: questionnaires.length,
                    crossAxisCount: crossAxisCount.toInt() <= 0
                        ? 1
                        : crossAxisCount.toInt(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    builder: (ctx, index) {
                      var questionnaire = questionnaires[index];
                      var dejaRepondu =
                          questionnaire.maked.containsKey(telephone).obs;
                      return QuestionnaireCard(
                          navigationId: 3,
                          brouillon: true,
                          dejaRepondu: dejaRepondu,
                          questionnaire: questionnaire,
                          width: width);
                    }),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(
                SizedBox(
                    width: 600,
                    child: CreateQuestionnaire(
                      brouillon: true,
                    )),
                id: 3);
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
