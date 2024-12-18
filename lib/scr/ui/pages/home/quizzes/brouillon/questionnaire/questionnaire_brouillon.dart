import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/create_questionnaire.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/questionnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/my_widgets.dart';

class QuestionnaireBrouillon extends StatelessWidget {
  QuestionnaireBrouillon({
    super.key,
  });

  var questionnaires = Rx<List<Questionnaire>?>(null);

  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;

      return EScaffold(
        appBar: AppBar(
               leading:Get.width>600?null: MenuBoutton(user: user, constraints: constraints, width: width),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: EText(
            "Questionnaires (Brouillon)",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: StreamBuilder(
            stream: DB
                .firestore(Collections.classes)
                .doc(user.classe)
                .collection(Collections.questionnaires)
                .doc(user.classe)
                .collection(Collections.brouillon)
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot)&& questionnaires.value.isNul) {
                return ECircularProgressIndicator();
              }

              var telephone = Utilisateur.currentUser.value!.telephone_id;

              var tempQuestionnaires = <Questionnaire>[];

              waitAfter(0, () async {
                for (var element in snapshot.data!.docs) {
                  tempQuestionnaires
                      .add(await Questionnaire.fromMap(element.data()));
                }

                questionnaires.value = tempQuestionnaires;
              });

              return Obx(
                () => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: questionnaires.value.isNul
                      ? ECircularProgressIndicator()
                      : questionnaires.value!.isEmpty
                          ? Empty(
                              constraints: constraints,
                            )
                          : DynamicHeightGridView(
                              physics: BouncingScrollPhysics(),
                              key: Key(questionnaires.value!.length.toString()),
                              itemCount: questionnaires.value!.length,
                              crossAxisCount: crossAxisCount.toInt() <= 0
                                  ? 1
                                  : crossAxisCount.toInt(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              builder: (ctx, index) {
                                var questionnaire =
                                    questionnaires.value![index];
                                var dejaRepondu = questionnaire.maked
                                    .containsKey(telephone)
                                    .obs;
                                return QuestionnaireCard(
                                    navigationId: 3,
                                    brouillon: true,
                                    dejaRepondu: dejaRepondu,
                                    questionnaire: questionnaire,
                                    width: width);
                              }),
                ),
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
