import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/ardoise/add_ardoise_question.dart';

class UserArdoiseResponseCard extends StatelessWidget {
  UserArdoiseResponseCard(
      {super.key, required this.question, required this.id});
  final String id;
  final ArdoiseQuestion question;

  var sendLoading = false.obs;

  RxString qcuResponse = "".obs;
  RxString qctResponse = "".obs;
  RxList<String> qcmResponse = RxList<String>([]);
  @override
  Widget build(BuildContext context) {
    if (question.type == QuestionType.qcm) {


      qcmResponse.value = (question.maked[id]!.response[0] as List)
          .map((element) => element.toString() as String)
          .toList();
    } else if (question.type == QuestionType.qcu) {
      qcuResponse.value = question.maked[id]!.response[0];
    } else {
      qctResponse.value = question.maked[id]!.response[0];
    }
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
      margin: EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: EColumn(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.pink, borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.person_circle),
              3.w,
              EText("${question.maked[id]!.nom} ${question.maked[id]!.prenom}"),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
              //   child: ETextRich(
              //     textSpans: [
              //       ETextSpan(
              //           text: question.question,
              //           color: const Color.fromARGB(255, 255, 255, 255),
              //           weight: FontWeight.bold),
              //     ],
              //     size: 22,
              //   ),
              // ),
            ],
          ),
        ),
        // DottedDashedLine(
        //   height: 0,
        //   width: Get.width - 24,
        //   axis: Axis.horizontal,
        //   dashColor: Colors.white54,
        // ),
        question.type == QuestionType.qct
            ? 
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
                child: EColumn(
                  children: [
                    EText(question
                        .maked[id]!
                        .response[0]
                        .toString()),
                    9.h,
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
                  print   ( question.reponse);
                  print   ( e);
                  return question.type == QuestionType.qcu
                      ? IgnorePointer(
                          ignoring: true,
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
                                    child: Container(
                                        height: 90,
                                        width: 120,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: question.reponse == e
                                                  ? Colors.greenAccent
                                                  : question.maked[id]!.response
                                                          .contains(e)
                                                      ? Colors.red
                                                      : Colors.white,
                                            )),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: InkWell(
                                            onTap: () {
                                              showImageViewer(
                                                  context,
                                                  NetworkImage(
                                                      question.choix[e]!),
                                                  onViewerDismissed: () {
                                                print("dismissed");
                                              });
                                            },
                                            child: EFadeInImage(
                                              height: 120,
                                              width: 120,
                                              radius: 12,
                                              image: NetworkImage(
                                                  question.choix[e]!),
                                            ),
                                          ),
                                        )),
                                  )
                                : EText(
                                    question.choix[e],
                                    color: true && question.reponse == e
                                        ? Colors.greenAccent
                                        : true && qcuResponse.value == e
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                          ),
                        )
                      : CheckboxListTile(
                          enabled: !true,
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
                                  child: Container(
                                      height: 90,
                                      width: 120,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: question.reponse.contains(e)
                                                ? Colors.greenAccent
                                                : question.maked[id]!.response
                                                        .contains(e)
                                                    ? Colors.red
                                                    : Colors.white,
                                          )),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          onTap: () {
                                            showImageViewer(
                                                context,
                                                NetworkImage(
                                                    question.choix[e]!),
                                                onViewerDismissed: () {
                                              print("dismissed");
                                            });
                                          },
                                          child: EFadeInImage(
                                            height: 120,
                                            width: 120,
                                            radius: 12,
                                            image: NetworkImage(
                                                question.choix[e]!),
                                          ),
                                        ),
                                      )),
                                )
                              : EText(
                                  question.choix[e],
                                  color: true && question.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : true && qcmResponse.value.contains(e)
                                          ? Colors.red
                                          : Colors.white,
                                ),
                        );
                }).toList()),
              ),
      ]),
    );
  }
}
