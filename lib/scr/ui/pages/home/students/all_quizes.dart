import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/questionnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:lottie/lottie.dart';

class AllQuizes extends StatelessWidget {
  final Utilisateur user;
  AllQuizes({super.key, required this.user});

  var questionnaires = Rx<List<Questionnaire>?>(null);

  @override
  Widget build(BuildContext context) {
    print("5555555555555555555");
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      return EScaffold(
        appBar: AppBar(
          title: EText(
            "Informations Complete",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot)) {
                return ECircularProgressIndicator();
              }
              return AnimatedSwitcher(
                duration: 666.milliseconds,
                child: Obx(
                  () => questionnaires.value.isNul
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

                                var pointsGagne = questionnaire.maked
                                        .containsKey(user.telephone_id)
                                    ? questionnaire
                                        .maked[user.telephone_id]!.pointsGagne
                                    : 0.0;
                                return Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    QuestionnaireCard(
                                        idUser: user.telephone_id,
                                        justUserInfos: true,
                                        navigationId: 0,
                                        dejaRepondu: true.obs,
                                        questionnaire: questionnaire,
                                        width: width),
                                    Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Row(
                                        children: [
                                          EText(
                                            pointsGagne.toStringAsFixed(2),
                                            font: Fonts.sevenSegment,
                                            size: 34,
                                            color: Colors.greenAccent,
                                          ),
                                          EText(
                                            " (${(100 * (pointsGagne / questionnaire.questions.length)).toStringAsFixed(2)})%",
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                ),
              );
            }),
      );
    });
  }

  getData() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .doc(user.classe)
        .collection(Collections.production)
        .orderBy(
          "date",
        )
        .limit(40)
        .get();
    var tempQuestionnaires = <Questionnaire>[];
    print(q.docs.length);
    for (var element in q.docs) {
      tempQuestionnaires.add(await Questionnaire.fromMap(element.data(),
          oneIdMaked: user.telephone_id));
    }
    questionnaires.value = tempQuestionnaires;
    print(questionnaires.value!.length);
  }
}
