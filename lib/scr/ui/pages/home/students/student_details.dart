import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/questionnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/fl_chart.dart';
import 'package:lottie/lottie.dart';

class StudentDetails extends StatelessWidget {
  final Utilisateur user;
  StudentDetails({super.key, required this.user});

  var questionnaires = Rx<List<Questionnaire>?>(null);

  var points = <double>[];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount =
          (width / 400).toInt() <= 0 ? 1 : (width / 400).toInt();

      return EScaffold(
        appBar: AppBar(
          title: EText(
            "${user.nom} ${user.prenom}",
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
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: EColumn(
                                children: [
                                  24.h,
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 700),
                                    child: LineChartSample2(
                                      points: points,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: EColumn(
                                      children: [
                                        ETextRich(textSpans: [
                                          ETextSpan(
                                              text: "Axe X: ",
                                              color: Colors.pinkAccent,
                                              weight: FontWeight.bold,
                                              size: 22),
                                          ETextSpan(
                                            text: "Le numero du questionnaire",
                                            weight: FontWeight.bold,
                                          )
                                        ]),
                                        ETextRich(textSpans: [
                                          ETextSpan(
                                              text: "Axe X: ",
                                              color: Colors.pinkAccent,
                                              weight: FontWeight.bold,
                                              size: 22),
                                          ETextSpan(
                                            text: "Le Pourcentage de réussite",
                                            weight: FontWeight.bold,
                                          )
                                        ]),
                                        24.h,
                                        EText("Questionnaires", size: 24, weight: FontWeight.bold,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: max(
                                            (crossAxisCount ~/
                                                questionnaires.value!.length),
                                            1) *
                                        460,
                                    child: DynamicHeightGridView(
                                        physics: BouncingScrollPhysics(),
                                        key: Key(questionnaires.value!.length
                                            .toString()),
                                        itemCount: questionnaires.value!.length,
                                        crossAxisCount:
                                            crossAxisCount.toInt() <= 0
                                                ? 1
                                                : crossAxisCount.toInt(),
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        builder: (ctx, index) {
                                          //pour que le dernier entré soit le premier affiché
                                          var questionnaire =
                                              questionnaires.value![
                                                  questionnaires.value!.length -
                                                      index -
                                                      1];
                                                          //pour que le dernier entré soit le premier affiché

                                          var pointsGagne = questionnaire.maked
                                                  .containsKey(
                                                      user.telephone_id)
                                              ? questionnaire
                                                  .maked[user.telephone_id]!
                                                  .pointsGagne
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
                                                padding:
                                                    const EdgeInsets.all(32.0),
                                                child: Row(
                                                  children: [
                                                    EText(
                                                      pointsGagne
                                                          .toStringAsFixed(2),
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
                                ],
                              ),
                            ),
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
        .get();
    var tempQuestionnaires = <Questionnaire>[];
    print(q.docs.length);
    for (var element in q.docs) {
      tempQuestionnaires.add(await Questionnaire.fromMap(element.data(),
          oneIdMaked: user.telephone_id));
    }
    points = [];
    tempQuestionnaires.forEach((element) {
      if (element.maked.containsKey(user.telephone_id)) {
        points.add(((element.maked[user.telephone_id]!.pointsGagne) /
                element.questions.length) *
            100);
      } else {
        points.add(0);
      }
    });
    questionnaires.value = tempQuestionnaires;
    print(questionnaires.value!.length);
  }
}
