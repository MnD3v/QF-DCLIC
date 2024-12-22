import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/add_question.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(
      {super.key,
      required this.index,
      this.idUser,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.questionnaire,
      required this.initalResponses,
      required this.qcmResponse,
      required this.element});
  final String? idUser;
  final Question element;
  final int index;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final Questionnaire? questionnaire;
  final List initalResponses;
  final RxList<String> qcmResponse;

  @override
  Widget build(BuildContext context) {
    var qctResponse = "";

    if (idUser != null && questionnaire!.maked.containsKey(idUser)) {
      if (element.type == QuestionType.qcm) {
        qcmResponse.value =
            (questionnaire!.maked[idUser]!.response[index] as List)
                .map((element) => element.toString())
                .toList();
      } else if (element.type == QuestionType.qcu) {
        qcuResponse.value = questionnaire!.maked[idUser]!.response[index];
      } else {
        qctResponse = questionnaire!.maked[idUser]!.response[index];
      }
    }

    return Container(
      width: Get.width,
          padding: EdgeInsets.all(18),

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: .5, color: Colors.white54)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ETextRich(
                textSpans: [
                  ETextSpan(
                      text: "${index + 1}. ",
                      color: Colors.amber,
                      weight: FontWeight.bold),
                  ETextSpan(text: element.question, color: Colors.white60),
                ],
                size: 22,
              ),

              element.image.isNotNul
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: InkWell(
                      
                      onTap: (){
                        showImageViewer(context, NetworkImage(element.image!));
                      },
                      child: EFadeInImage(
                        height: 120,
                        width: 120,
                        image: NetworkImage(element.image!)),
                    ),
                  )
                  : 0.h
            ],
          ),
        ),
        12.h,
        DottedDashedLine(
          height: 0,
          width: Get.width - 24,
          axis: Axis.horizontal,
          dashColor: Colors.white54,
        ),
        element.type == QuestionType.qct
            ? Obx(
                () => dejaRepondu.value
                    ? EColumn(
                      children: [
                        EText(
                          supprimerTirets(qctResponse),
                          color: qctResponse.contains("--false")
                              ? Colors.red
                              : qctResponse.contains("--true")
                                  ? Colors.green
                                  : Colors.white,
                        ),
                        9.h,
                        EText(
                          element.reponse,
                          color: Colors.greenAccent,
                        ),
                      ],
                    )
                    : Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ETextField(
                          border: false,
                            maxLines: 6,
                            minLines: 3,
                            radius: 18,
                            placeholder: "Saisissez votre reponse",
                            onChanged: (value) {
                              print(dejaRepondu);
                              initalResponses[index] = value;
                            },
                            phoneScallerFactor: phoneScallerFactor),
                      ),
              )
            : Obx(
                () => EColumn(
                    children: element.choix.keys.map((e) {
                  return !(element.type == QuestionType.qcm)
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
                              var index =
                                  questionnaire!.questions.indexOf(element);
                              initalResponses[index] = qcuResponse.value;
                            },
                            title: isFirebaseStorageLink(element.choix[e]!)
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
                                              color: element.reponse == e
                                                  ? Colors.greenAccent
                                                  : qcuResponse.value == e
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
                                                      element.choix[e]!),
                                                  onViewerDismissed: () {
                                                print("dismissed");
                                              });
                                            },
                                            child: EFadeInImage(
                                              height: 120,
                                              width: 120,
                                              image: NetworkImage(
                                                  element.choix[e]!),
                                            ),
                                          ),
                                        )),
                                  )
                                : EText(
                                    element.choix[e],
                                    color: element.reponse == e
                                        ? Colors.greenAccent
                                        : qcuResponse.value == e
                                            ? Colors.red
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
                            var index =
                                questionnaire!.questions.indexOf(element);
                            initalResponses[index] = qcmResponse.value;
                          },
                          title: isFirebaseStorageLink(element.choix[e]!)
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
                                              color: element.reponse.contains(e)
                                                  ? Colors.greenAccent
                                                  : qcmResponse.contains(e)
                                                      ? Colors.red
                                                      : Colors.white)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          onTap: () {
                                            showImageViewer(context,
                                                NetworkImage(element.choix[e]!),
                                                onViewerDismissed: () {
                                              print("dismissed");
                                            },
                                                doubleTapZoomable: true,
                                                backgroundColor: Colors.black,
                                                barrierColor: Colors.black,
                                                useSafeArea: true);
                                          },
                                          child: EFadeInImage(
                                            height: 120,
                                            width: 120,
                                            image:
                                                NetworkImage(element.choix[e]!),
                                          ),
                                        ),
                                      )),
                                )
                              : EText(
                                  element.choix[e],
                                  color: element.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : Colors.white,
                                ),
                        );
                }).toList()),
              )
      ]),
    );
  }
}

String supprimerTirets(String qctResponse) {
  return qctResponse
      .replaceAll("--none", "")
      .replaceAll("--false", "")
      .replaceAll("--true", "");
}
