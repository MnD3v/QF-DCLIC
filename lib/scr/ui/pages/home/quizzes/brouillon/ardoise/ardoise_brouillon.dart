import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/add_ardoise_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/widgets/admin_ardoise_card.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/question_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/my_widgets.dart';

class ArdoiseBrouillon extends StatelessWidget {
  ArdoiseBrouillon({super.key});

  var questions = Rx<List<ArdoiseQuestion>?>(null);
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
          leading: Get.width > 600
              ? null
              : MenuBoutton(user: user, constraints: constraints, width: width),
          title: EText(
            "Ardoise (Brouillon)",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: StreamBuilder(
            stream: DB
                .firestore(Collections.classes)
                .doc(user.classe)
                .collection(Collections.ardoise)
                .doc(user.classe)
                .collection(Collections.brouillon)
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot) && questions.value.isNul) {
                return ECircularProgressIndicator();
              }

              var telephone = Utilisateur.currentUser.value!.telephone_id;
              var tempQuestions = <ArdoiseQuestion>[];
              snapshot.data!.docs.forEach((element) {
                tempQuestions.add(ArdoiseQuestion.fromMap(element.data()));
              });
              questions.value = tempQuestions;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: questions.value!.isEmpty
                      ? Empty(
                          constraints: constraints,
                        )
                      : DynamicHeightGridView(
                          physics: BouncingScrollPhysics(),
                          key: Key(questions.value!.length.toString()),
                          itemCount: questions.value!.length,
                          crossAxisCount: crossAxisCount.toInt() <= 0
                              ? 1
                              : crossAxisCount.toInt(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          builder: (ctx, index) {
                            var element = questions.value![index];
                            var qcmResponse = RxList<String>([]);
                            var qcuResponse = "".obs;
                            var qctResponse = "".obs;

                            // var index = questions.indexOf(element);

                            var dejaRepondu = false.obs;

                            dejaRepondu.value =
                                element!.maked.keys.contains(telephone);

                            return ArdoiseQuestionCard(
                                brouillon: true,
                                dejaRepondu: dejaRepondu,
                                qctResponse: qctResponse,
                                qcuResponse: qcuResponse,
                                qcmResponse: qcmResponse,
                                question: element);
                          }),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(
                AddArdoiseQuestion(
                  brouillon: true,
                ),
                id: 4);
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
