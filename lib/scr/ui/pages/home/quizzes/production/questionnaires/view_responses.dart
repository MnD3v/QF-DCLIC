import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/view_user_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/my_widgets.dart';

class ViewResponses extends StatelessWidget {
  final String id;
  ViewResponses({super.key, required this.id});

  var user = Formateur.currentUser.value!;

  var questionnaire = Rx<Questionnaire?>(null);

  var notCorrected = false.obs;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 270;

      return EScaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: EText(
              "Reponses",
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
                  .collection(Collections.production)
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
                waitAfter(0, () async {
                  questionnaire.value =
                      await Questionnaire.fromMap(snapshot.data!.data()!, classe: user.classe!);
                });

                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: 666.milliseconds,
                        child: questionnaire.value.isNul
                            ? ECircularProgressIndicator()
                            : questionnaire.value!.maked.keys.isEmpty
                                ? Empty(
                            )
                                : DynamicHeightGridView(
                                    key: Key(questionnaire
                                        .value!.maked.keys.length
                                        .toString()),
                                    physics: BouncingScrollPhysics(),
                                    itemCount:
                                        questionnaire.value!.maked.keys.length,
                                    crossAxisCount: crossAxisCount.toInt() <= 0
                                        ? 1
                                        : crossAxisCount.toInt(),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    builder: (ctx, index) {
                                      var id = questionnaire.value!.maked.keys
                                          .toList()[index];
                                      var maked =
                                          questionnaire.value!.maked[id];
                                      return UserCard(
                                          id: id,
                                          questionnaire: questionnaire,
                                          maked: maked!,
                                          notCorrected: notCorrected);
                                    }),
                      ),
                    ));
              }));
    });
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.id,
    required this.questionnaire,
    required this.maked,
    required this.notCorrected,
  });

  final String id;
  final Rx<Questionnaire?> questionnaire;
  final Maked maked;
  final RxBool notCorrected;

  @override
  Widget build(BuildContext context) {
    verifyNoCorrected(maked);
    return InkWell(
      onTap: () {
        Get.to(
            ViewUserQuestionnaire(
                userID: id,
                questionnaire: questionnaire.value!,
                dejaRepondu: true.obs),
            id: 1);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 16, 0, 43),
                  const Color.fromARGB(255, 29, 0, 75)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    9.h,
                    SizedBox(width: 165, child: Center(child: EText("${maked!.nom} ${maked.prenom}",maxLines: 1,))),
                          
                  ],
                ),
                  ETextRich(
                          textSpans: [
                            ETextSpan(
                                text: maked.pointsGagne.toStringAsFixed(2),
                                weight: FontWeight.bold,
                                color: Colors.greenAccent),
                            ETextSpan(
                              text:
                                  "/${questionnaire.value!.questions.length.toDouble().toStringAsFixed(2)}",
                              weight: FontWeight.bold,
                              color: Colors.white,
                            )
                          ],
                          size: 30,
                          font: Fonts.sevenSegment,
                        ),
                        6.h,
                        
Icon(Icons.remove_red_eye)
              ],
            ),
          ),
          notCorrected.value
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.warning_rounded,
                    size: 30,
                    color: Colors.amberAccent,
                  ),
                )
              : 0.h
        ],
      ),
    );
  }

  verifyNoCorrected(Maked maked) {
    for (var e in maked.response) {
      if (e is String) {
        if (e.contains('--none')) {
          notCorrected.value = true;
          return;
        }
      }

      notCorrected.value = false;
    }
  }
}
