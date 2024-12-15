import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/add_ardoise_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/view_ardoise_responses.dart';

class ArdoiseQuestionCard extends StatelessWidget {
  ArdoiseQuestionCard(
      {super.key,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.qctResponse,
      required this.qcmResponse,
      this.brouillon,
      required this.question});
  final ArdoiseQuestion question;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final RxString qctResponse;
  final RxList<String> qcmResponse;
  final bool? brouillon;

  var sendLoading = false.obs;
  var _delete_loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 333.milliseconds,
      width: Get.width,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        // color: Color.fromARGB(0, 30, 95, 145),
        // gradient: LinearGradient(colors: [Colors.transparent, const Color.fromARGB(255, 15, 53, 88)]),
        border: Border.all(width: .6, color: Colors.white24),

        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 16, 0, 43),
          const Color.fromARGB(255, 29, 0, 75)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ETextRich(
              textSpans: [
                ETextSpan(
                    text: question.question,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    weight: FontWeight.bold),
              ],
              size: 22,
            ),
            9.h,
              question.image.isNotNul
                  ? InkWell(
                    
                    onTap: (){
                      showImageViewer(context, NetworkImage(question.image!));
                    },
                    child: EFadeInImage(
                      height: 120,
                      width: 120,
                      radius: 12,
                      image: NetworkImage(question.image!)),
                  )
                  : 0.h
          ],
        ),
        question.type == QuestionType.qct
            ? Padding(
                padding:
                    const EdgeInsets.symmetric( vertical: 18),
                child: EColumn(
                  children: [
                    EText(
                      question.reponse,
                      color: Colors.greenAccent,
                    )
                  ],
                ),
              )
            : Obx(
                () => EColumn(
                    children: question.choix.keys.map((e) {
                  return !(question.type == QuestionType.qcm)
                      ? IgnorePointer(
                          ignoring: dejaRepondu.value,
                          child: RadioListTile(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcuResponse.value == e
                                    ? Colors.amber
                                    : Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            value: e,
                            groupValue: qcuResponse.value,
                            onChanged: (value) {
                              qcuResponse.value = value as String;
                            },
                            title: isFirebaseStorageLink(question.choix[e]!)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: InkWell(
                                        onTap: () {
                                          showImageViewer(
                                            context,
                                            NetworkImage(question.choix[e]!),
                                          );
                                        },
                                        child: EFadeInImage(
                                          height: 90,
                                          width: 130,
                                          radius: 12,
                                          image:
                                              NetworkImage(question.choix[e]!),
                                        ),
                                      ),
                                    ),
                                  )
                                : EText(
                                    question.choix[e],
                                    color: question.reponse == e
                                        ? Colors.greenAccent
                                        : Colors.white,
                                  ),
                          ),
                        )
                      : CheckboxListTile(
                          enabled: !dejaRepondu.value,
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              qcmResponse.contains(e)
                                  ? Colors.amber
                                  : Colors.transparent),
                          activeColor: Colors.amber,
                          side: BorderSide(width: 2, color: Colors.grey),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          value: qcmResponse.contains(e),
                          onChanged: (value) {
                            qcmResponse.contains(e)
                                ? qcmResponse.remove(e)
                                : qcmResponse.add(e);
                          },
                          title: isFirebaseStorageLink(question.choix[e]!)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: InkWell(
                                      onTap: () {
                                        showImageViewer(
                                          context,
                                          NetworkImage(question.choix[e]!),
                                        );
                                      },
                                      child: EFadeInImage(
                                        radius: 12,
                                        width: 120,
                                        image: NetworkImage(question.choix[e]!),
                                      ),
                                    ),
                                  ))
                              : EText(
                                  question.choix[e],
                                  color: question.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : Colors.white,
                                ),
                        );
                }).toList()),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            brouillon == true
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: SimpleButton(
                        height: 35,
                        width: 140,
                        onTap: () async {
                          sendLoading.value = true;
                          await question.toProduction();
                          sendLoading.value = false;
                        },
                        child: Obx(
                          () => sendLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.2,
                                  ))
                              : EText(
                                  "Publier",
                                  color: Colors.white,
                                ),
                        )),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SimpleButton(
                      height: 35,
                      width: 140,
                      onTap: () {
                        Get.to(ViewArdoiseResponses(ardoiseQuestionID: question.id), id: 2);
                      },
                      child: EText(
                        "Reponses",
                        color: Colors.white,
                      ),
                    ),
                  ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                          AddArdoiseQuestion(
                            question: question,
                            brouillon: brouillon,
                          ),
                          id: brouillon == true ? 4 : 2);
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
                InkWell(
                  onTap: () {
                    Custom.showDialog(
                        dialog: TwoOptionsDialog(
                            confirmFunction: () async {
                              Get.back();
                              _delete_loading.value = true;
                              await question.delete(
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
              ],
            )
          ],
        )
      ]),
    );
  }
}
