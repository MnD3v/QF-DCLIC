import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/question_card.dart';

class UserQuestionViewCard extends StatelessWidget {
  UserQuestionViewCard(
      {super.key,
      required this.userID,
      required this.index,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.questionnaire,
      required this.initalResponses,
      required this.qcmResponse,
      required this.element});
  final userID;
  final Question element;
  final int index;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final Questionnaire questionnaire;
  final List initalResponses;
  final RxList qcmResponse;
  var qctResponse = "".obs;

  var inLoading = false.obs;

  var user = Formateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    if (element.type == QuestionType.qcu) {
      qcuResponse.value = initalResponses[index];
    } else if (element.type == QuestionType.qcm) {
      List<String> qcmR = (initalResponses[index] as List)
          .map((element) => element.toString())
          .toList();
      qcmResponse.value = qcmR;
    } else {
      qctResponse.value = initalResponses[index];
    }
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: .5, color: Colors.white54)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        Container(
          padding: EdgeInsets.all(6),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                child: ETextRich(
                  textSpans: [
                    ETextSpan(
                        text: "${index + 1}. ",
                        color: Colors.amber,
                        weight: FontWeight.bold),
                    ETextSpan(text: element.question, color: Colors.white60),
                  ],
                  size: 22,
                ),
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
        DottedDashedLine(
          height: 0,
          width: Get.width - 24,
          axis: Axis.horizontal,
          dashColor: Colors.white54,
        ),
        element.type == QuestionType.qct
            ? Obx(
                () => dejaRepondu.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18),
                        child: EColumn(
                          children: [
                            EText(
                              supprimerTirets(qctResponse.value),
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
                            Obx(
                              () => AnimatedSwitcher(
                                duration: 666.milliseconds,
                                child: inLoading.value
                                    ? Row(
                                        children: [
                                          //row parceque ça refuse de s'aligner
                                          ECircularProgressIndicator(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : !qctResponse.contains("--none")
                                        ? 0.h
                                        : Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    inLoading.value = true;
                                                    qctResponse.value =
                                                        qctResponse.replaceAll(
                                                            "--none", "--true");

                                                    initalResponses[index] =
                                                        qctResponse.value;
                                                    var tempMaked =
                                                        questionnaire!
                                                            .maked[userID]!;
                                                    tempMaked.pointsGagne += 1;
                                                    await getAndUpdateUserPoints();
                                                    tempMaked.response =
                                                        initalResponses;
                                                    await updateMaked(
                                                        maked: tempMaked);
                                                    waitAfter(2000, () {
                                                      inLoading.value = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: Colors.greenAccent,
                                                  )),
                                              IconButton(
                                                  onPressed: () async {
                                                    inLoading.value = true;
                                                    qctResponse.value =
                                                        qctResponse.replaceAll(
                                                            "--none",
                                                            "--false");

                                                    initalResponses[index] =
                                                        qctResponse.value;
                                                    var tempMaked =
                                                        questionnaire!
                                                            .maked[userID];

                                                    tempMaked!.response =
                                                        initalResponses;
                                                    await updateMaked(
                                                        maked: tempMaked);

                                                    waitAfter(2000, () {
                                                      inLoading.value = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )),
                                            ],
                                          ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ETextField(
                            maxLines: 6,
                            minLines: 3,
                            radius: 24,
                            placeholder: "Saisissez votre reponse",
                            onChanged: (value) {
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
                                              color: dejaRepondu.value &&
                                                      element.reponse == e
                                                  ? Colors.greenAccent
                                                  : dejaRepondu.value &&
                                                          initalResponses[
                                                                  index] ==
                                                              e
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
                                    color: dejaRepondu.value &&
                                            element.reponse == e
                                        ? Colors.greenAccent
                                        : dejaRepondu.value &&
                                                initalResponses[index] == e
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
                                              color: dejaRepondu.value &&
                                                      element.reponse
                                                          .contains(e)
                                                  ? Colors.greenAccent
                                                  : dejaRepondu.value &&
                                                          initalResponses[index]
                                                              .contains(e)
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
                                  color: dejaRepondu.value &&
                                          element.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : dejaRepondu.value &&
                                              initalResponses[index].contains(e)
                                          ? Colors.red
                                          : Colors.white,
                                ),
                        );
                }).toList()),
              )
      ]),
    );
  }

  Future<void> updateMaked({required Maked maked}) async {
    await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .doc(user.classe)
        .collection(Collections.production)
        .doc(questionnaire!.id)
        .collection(Collections.maked)
        .doc(userID)
        .set(maked.toMap());
        //histoire de declancher le stream de recuperation de questionnaire
    questionnaire!.date =
        '${questionnaire!.date.split(".")[0]}.${Random().nextInt(900)}';
        //histoire de declancher le stream de recuperation de questionnaire

    questionnaire!.save(brouillon: false);
  }

  Future<void> getAndUpdateUserPoints() async {
    var q = await DB.firestore(Collections.utilistateurs).doc(userID).get();
    var user = Utilisateur.fromMap(q.data()!);
    user.points += 1;
    Utilisateur.setUser(user);
  }
}
