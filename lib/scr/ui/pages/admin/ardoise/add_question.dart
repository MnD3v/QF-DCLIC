import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';

class AddArdoiseQuestion extends StatelessWidget {
  AddArdoiseQuestion({super.key});
  var qcuResponse = "".obs;
  var qcmResponse = RxList<String>();
  var qctResponse = "";

  var propositions = RxList<String>();

  var type = "qcm".obs;

  String title = "";

  var _loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return EScaffold(
        color: Color.fromARGB(255, 24, 49, 77),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: EText(
          "Ajouter une question",
          color: Colors.amber,
          size: 24,
          weight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EColumn(children: [
          EText("Ajoutez l'intitulé de la question"),
          6.h,
          ETextField(
              placeholder: "Saisissez l'intitulé de la question",
              onChanged: (value) {
                title = value;
              },
              phoneScallerFactor: phoneScallerFactor),
              12.h,
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                child: EColumn(
                  children: [
                    6.h,
                    EText("Choisir le type de la question"),
                         Obx(
                            () => Column(
                children: [
                  RadioListTile(
                    // ignore: deprecated_member_use
                    fillColor: MaterialStateColor.resolveWith((states) =>
                        type.value == QuestionType.qcm
                            ? Colors.amber
                            : Colors.grey),
                    value: QuestionType.qcm,
                    groupValue: type.value,
                    onChanged: (value) {
                      type.value = value!;
                    },
                    title: EText("QCM"),
                  ),
                  RadioListTile(
                    fillColor: MaterialStateColor.resolveWith((states) =>
                        type.value == QuestionType.qcu
                            ? Colors.amber
                            : Colors.grey),
                    value: QuestionType.qcu,
                    groupValue: type.value,
                    onChanged: (value) {
                      type.value = value!;
                    },
                    title: EText("QCU"),
                  ),
                  RadioListTile(
                    fillColor: MaterialStateColor.resolveWith((states) =>
                        type.value == QuestionType.qct
                            ? Colors.amber
                            : Colors.grey),
                    value: QuestionType.qct,
                    groupValue: type.value,
                    onChanged: (value) {
                      type.value = value!;
                    },
                    title: EText("QCT"),
                  ),
                ],
                            ),
                          ),
                      
                  ],
                ),
              ),
              3.h,
         9.h,
          3.h,
          Obx(
            () => AnimatedSwitcher(
              duration: 666.milliseconds,
              child: type.value == QuestionType.qct
                  ? EColumn(
                      children: [
                        EText("Entrez la réponse"),
                        ETextField(
                            placeholder: "Saisissez la reponse à la question",
                            onChanged: (value) {
                              qctResponse = value;
                            },
                            phoneScallerFactor: phoneScallerFactor),
                        12.h,
                      ],
                    )
                  : EColumn(children: [
                      EText("Ajouter une proposition"),
                      6.h,
                      ...propositions.map((element) {
                        var index = propositions.indexOf(element);
                        return type.value == QuestionType.qcm
                            ? CheckboxListTile(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        qcmResponse.contains(index.toString())
                                            ? Colors.amber
                                            : Colors.transparent),
                                activeColor: Colors.amber,
                                side: BorderSide(width: 2, color: Colors.grey),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: qcmResponse.contains(index.toString()),
                                onChanged: (value) {
                                  if (qcmResponse.contains(index.toString())) {
                                    qcmResponse.remove(index.toString());
                                  } else {
                                    qcmResponse.add(index.toString());
                                  }
                                },
                                title: isFirebaseStorageLink(element)
                                    ? Container(
                                        height: 90,
                                        decoration: BoxDecoration(),
                                        alignment: Alignment.centerLeft,
                                        child: EFadeInImage(
                                          radius: 12,
                                          image: NetworkImage(element),
                                        ))
                                    : EText(element),
                              )
                            : RadioListTile(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        qcuResponse.value == index.toString()
                                            ? Colors.amber
                                            : Colors.grey),
                                value: index.toString(),
                                groupValue: qcuResponse.value,
                                onChanged: (value) {
                                  qcuResponse.value = value!;
                                },
                                title: isFirebaseStorageLink(element)
                                    ? Container(
                                        width: Get.width,
                                        alignment: Alignment.centerLeft,
                                        height: 90,
                                        child: EFadeInImage(
                                          radius: 12,
                                          image: NetworkImage(element),
                                        ))
                                    : EText(element),
                              );
                      }).toList(),
                      SimpleOutlineButton(
                        radius: 3,
                        onTap: () {
                          showAddPropositionDialog();
                        },
                        child: EText(
                          "Ajouter",
                          color: Colors.amber,
                        ),
                      )
                    ]),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SimpleButton(
            radius: 3,
            color: Colors.amber,
            onTap: () async {
              var user = Utilisateur.currentUser.value!;
              if (title.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Veuillez saisir l'intitulé de la question");
                return;
              }
              if (type.value != QuestionType.qct && propositions.length < 2) {
                Fluttertoast.showToast(
                    msg: "Veuillez ajouter au-moins deux propositions");
                return;
              }
              ArdoiseQuestion question;

              //liste en map
              Map<String, String> choix = {};
              propositions.forEach((value) {
                var index = propositions.indexOf(value);
                choix.putIfAbsent(index.toString(), () => value);
              });
              //liste en map
              if (type == QuestionType.qcu) {
                if (qcuResponse.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Veuillez choisir la reponse");
                  return;
                }
                question = ArdoiseQuestion(
                    date: DateTime.now().toString(),
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    maked: {},
                    question: title,
                    choix: choix,
                    reponse: qcuResponse.value,
                    type: QuestionType.qcu);
              } else if (type == QuestionType.qcm) {
                if (qcmResponse.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Veuillez choisir la reponse");
                  return;
                }
                question = ArdoiseQuestion(
                    date: DateTime.now().toString(),
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    maked: {},
                    question: title,
                    choix: choix,
                    reponse: qcmResponse.value,
                    type: QuestionType.qcm);
              } else {
                if (qctResponse.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Veuillez saisir la réponse à la question");
                  return;
                }
                question = ArdoiseQuestion(
                    date: DateTime.now().toString(),
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    maked: {},
                    question: title,
                    choix: choix,
                    reponse: qctResponse,
                    type: QuestionType.qct);
              }
              // questions.add(question);
              _loading.value = true;
              await DB
                  .firestore(Collections.classes)
                  .doc(user.classe)
                  .collection(Collections.ardoise)
                  .doc(question.id)
                  .set(question.toMap());
              _loading.value = false;

              Get.back(id: 2);
            },
            child: Obx(
              () => _loading.value
                  ? ECircularProgressIndicator(
                      height: 20,
                      color: Colors.black,
                    )
                  : EText(
                      "Enregistrer",
                      color: Colors.black,
                    ),
            )),
      ),
    );
  }

  void showAddPropositionDialog() {
    String proposition = "";
    var loadingImage = false.obs;

    Get.dialog(Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            EColumn(crossAxisAlignment: CrossAxisAlignment.center, children: [
          EText("Entrez la proposition"),
          9.h,
          ETextField(
              placeholder: "Saisissez une proposition",
              onChanged: (value) {
                proposition = value;
              },
              onSubmitted: (value){
                 if (proposition.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Veuillez saisir une proposition valable");
                return;
              }
              if (propositions.contains(proposition)) {
                Fluttertoast.showToast(
                    msg: "Evitez d'entrer des propositions identiques");
                return;
              }
              propositions.add(proposition);
              Get.back();
              },
              phoneScallerFactor: phoneScallerFactor),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EText("Ou"),
          ),
          GestureDetector(
            onTap: () async {
              await ImagePicker()
                  .pickImage(
                source: ImageSource.gallery,
              )
                  .then(
                (value) async {
                  loadingImage.value = true;

                  var link;
                  if (kIsWeb) {
                    link = await FStorage.putData(await value!.readAsBytes());
                  } else {
                    link = await FStorage.putFile(File(value!.path));
                  }
                  loadingImage.value = false;
                  print(link);
                  proposition = link;
                  propositions.add(proposition);

                  Get.back();
                },
              ).onError((_, __) {
                loadingImage.value = false;
              });
            },
            child: Obx(() => Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(18)),
                  child: loadingImage.value
                      ? ECircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Icon(Icons.image_outlined, color: Colors.black,),
                )),
          ),
          9.h,
          SimpleOutlineButton(
            color: Colors.amber,
            radius: 3,
            onTap: () {
              if (proposition.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Veuillez saisir une proposition valable");
                return;
              }
              if (propositions.contains(proposition)) {
                Fluttertoast.showToast(
                    msg: "Evitez d'entrer des propositions identiques");
                return;
              }
              propositions.add(proposition);
              Get.back();
            },
            child: EText(
              "Ajouter",
              color: Colors.amber,
            ),
          )
        ]),
      ),
    ));
  }
}

bool isFirebaseStorageLink(String url) {
  final RegExp firebaseStorageRegex = RegExp(
    r'^https:\/\/firebasestorage\.googleapis\.com\/v0\/b\/[a-zA-Z0-9.-]+\.appspot\.com\/o\/.+\?alt=media&token=[a-zA-Z0-9-]+$',
  );
  return firebaseStorageRegex.hasMatch(url);
}

class QuestionType {
  static String qcu = "qcu";
  static String qcm = "qcm";
  static String qct = "qct";
}
