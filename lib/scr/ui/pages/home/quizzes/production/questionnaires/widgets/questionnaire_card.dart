import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/create_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/view_responses.dart';
import 'package:my_widgets/data/models/questionnaire.dart';

class QuestionnaireCard extends StatelessWidget {
  QuestionnaireCard(
      {super.key,
      required this.dejaRepondu,
      required this.questionnaire,
      required this.width,
      required this.navigationId,
      this.justUserInfos,
      this.idUser,
      this.brouillon});
  final String? idUser;
  final bool? justUserInfos;
  final RxBool dejaRepondu;
  final Questionnaire questionnaire;
  final double width;
  final bool? brouillon;
  final int navigationId;

  var _loading = false.obs;
  var _delete_loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
            SizedBox(
              child: ViewQuestionnaire(
                idUser: idUser,
                dejaRepondu: dejaRepondu,
                questionnaire: questionnaire,
              ),
            ),
            id: navigationId);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
        decoration: BoxDecoration(
            color: idUser.isNotNul && !questionnaire.maked.containsKey(idUser)
                ? Colors.red.withOpacity(.1)
                : null,
            // gradient: LinearGradient(colors: [
            //   Color.fromARGB(255, 16, 0, 43),
            //   const Color.fromARGB(255, 29, 0, 75)
            // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EText(
              questionnaire.title,
              color: Colors.white,
              size: 22,
            ),
            9.h,
            EText(
              questionnaire.date.split(" ")[0].split("-").reversed.join("-"),
              color: Colors.pinkAccent,
              size: 18,
              weight: FontWeight.bold,
            ),
            9.h,
            justUserInfos == true
                ? 24.h
                : Wrap(
                    children: [
                      brouillon == true
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: SimpleButton(
                                width: 122,
                                height: 35,
                                onTap: () async {
                                  _loading.value = true;
                                  await questionnaire.toProduction();
                                  _loading.value = false;
                                },
                                child: Obx(
                                  () => _loading.value
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : EText(
                                          "Publier",
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: SimpleButton(
                                width: 122,
                                height: 35,
                                onTap: () {
                                  Get.to(
                                      ViewResponses(
                                        id: questionnaire.id,
                                      ),
                                      id: 1);
                                },
                                child: EText(
                                  "Reponses",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      6.w,
                      Container(
                        alignment: Alignment.center,
                        width: 90,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Colors.white12,
                        ),
                        height: 35,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: EText(
                                "Voir",
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 30,
                            )
                          ],
                        ),
                      ),
                      12.w,
         brouillon != true? 0.h:             Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                                CreateQuestionnaire(
                                  brouillon: brouillon,
                                  questionnaire: questionnaire,
                                ),
                                id: brouillon == true ? 3 : 1);
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Obx(
                                () => _delete_loading.value
                                    ? SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.mode_edit_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                              )),
                        ),
                      ),
                      12.w,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: InkWell(
                          onTap: () {
                            Custom.showDialog(
                                dialog: TwoOptionsDialog(
                                    confirmFunction: () async {
                                      Get.back();
                                      _delete_loading.value = true;
                                      await questionnaire.delete(
                                          brouillon: brouillon == true);
                                      _delete_loading.value = false;
                                    },
                                    body:
                                        "Voulez-vous vraiment supprimer cet element ?",
                                    confirmationText: "Supprimer",
                                    title: "Suppression"));
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Obx(
                                () => _delete_loading.value
                                    ? SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.2,
                                        ),
                                      )
                                    : Icon(
                                        CupertinoIcons.trash,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                              )),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
