import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:my_widgets/my_widgets.dart';

class AddArdoiseQuestion extends StatefulWidget {
  final bool? brouillon;
  ArdoiseQuestion? question;

  AddArdoiseQuestion({super.key, this.brouillon, this.question});

  @override
  State<AddArdoiseQuestion> createState() => _AddArdoiseQuestionState();
}

class _AddArdoiseQuestionState extends State<AddArdoiseQuestion> {
  var qcuResponse = "".obs;

  var qcmResponse = RxList<String>();

  var qctResponse = "";

  var propositions = RxList<String>();

  var type = "qcm".obs;

  String title = "";

  var _loading = false.obs;

  @override
  void initState() {
    if (widget.question != null) {
      type.value = widget.question!.type;
      title = widget.question!.question;
      propositions.value = widget.question!.choix.values.toList();
      if (widget.question!.type == QuestionType.qct) {
        qctResponse = widget.question!.reponse;
      } else if (widget.question!.type == QuestionType.qcu) {
        qcuResponse.value = widget.question!.reponse;
      } else {
        print(widget.question!.reponse);
        qcmResponse.value = (widget.question!.reponse as List)
            .map((element) => element.toString())
            .toList();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

      return EScaffold(
        appBar: Get.width < 600
            ? null
            : AppBar(
                backgroundColor: AppColors.background900,
              ),
        body: Center(
          child: Container(
            margin: Get.width < 600 ? null : EdgeInsets.all(12),
            padding: Get.width < 600 ? null : EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.background900,
                borderRadius: BorderRadius.circular(12)),
            width: width,
            child: EScaffold(
              color: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: Get.width < 600,
                title: EText(
                  "Ajouter une question",
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SimpleButton(
                        radius: 12,
                        width: 140,
                        color: Colors.pink,
                        onTap: () async {
                          var user = Utilisateur.currentUser.value!;
                          if (title.isEmpty) {
                            Fluttertoast.showToast(
                                msg:
                                    "Veuillez saisir l'intitulé de la question");
                            return;
                          }
                          if (type.value != QuestionType.qct &&
                              propositions.length < 2) {
                            Fluttertoast.showToast(
                                msg:
                                    "Veuillez ajouter au-moins deux propositions");
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
                              Fluttertoast.showToast(
                                  msg: "Veuillez choisir la reponse");
                              return;
                            }
                            question = ArdoiseQuestion(
                                date: DateTime.now().toString(),
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                maked: {},
                                question: title,
                                choix: choix,
                                reponse: qcuResponse.value,
                                type: QuestionType.qcu);
                          } else if (type == QuestionType.qcm) {
                            if (qcmResponse.value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Veuillez choisir la reponse");
                              return;
                            }
                            question = ArdoiseQuestion(
                                date: DateTime.now().toString(),
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                maked: {},
                                question: title,
                                choix: choix,
                                reponse: qcmResponse.value,
                                type: QuestionType.qcm);
                          } else {
                            if (qctResponse.isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Veuillez saisir la réponse à la question");
                              return;
                            }
                            question = ArdoiseQuestion(
                                date: DateTime.now().toString(),
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                maked: {},
                                question: title,
                                choix: choix,
                                reponse: qctResponse,
                                type: QuestionType.qct);
                          }
                          // questions.add(question);
                          _loading.value = true;
                          //verifier si c'est une mise a jour
                          if (widget.question != null) {
                            question.id = widget.question!.id;
                          }
                          //verifier si c'est une mise a jour

                          if (widget.brouillon == true) {
                            question.save(brouillon: true);
                          } else {
                            question.save(brouillon: false);
                          }

                          _loading.value = false;

                          Get.back(id: widget.brouillon == true ? 4 : 2);
                        },
                        child: Obx(
                          () => _loading.value
                              ? ECircularProgressIndicator(
                                  height: 20,
                                  color: Colors.white,
                                )
                              : EText(
                                  widget.brouillon == true
                                      ? "Enregistrer"
                                      : "Publier",
                                  color: Colors.white,
                                ),
                        )),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: EColumn(children: [
                  EText("Ajoutez l'intitulé de la question"),
                  6.h,
                  ETextField(
                      initialValue: title,
                      placeholder: "Saisissez l'intitulé de la question",
                      onChanged: (value) {
                        title = value;
                      },
                      phoneScallerFactor: phoneScallerFactor),
                  12.h,
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12)),
                    child: EColumn(
                      children: [
                        6.h,
                        EText("Choisir le type de la question"),
                        Obx(
                          () => Column(
                            children: [
                              RadioListTile(
                                // ignore: deprecated_member_use
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => type.value == QuestionType.qcm
                                        ? Colors.pinkAccent
                                        : Colors.grey),
                                value: QuestionType.qcm,
                                groupValue: type.value,
                                onChanged: (value) {
                                  type.value = value!;
                                },
                                title: EText("QCM"),
                              ),
                              RadioListTile(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => type.value == QuestionType.qcu
                                        ? Colors.pinkAccent
                                        : Colors.grey),
                                value: QuestionType.qcu,
                                groupValue: type.value,
                                onChanged: (value) {
                                  type.value = value!;
                                },
                                title: EText("QCU"),
                              ),
                              RadioListTile(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => type.value == QuestionType.qct
                                        ? Colors.pinkAccent
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
                                    initialValue: qctResponse,
                                    placeholder:
                                        "Saisissez la reponse à la question",
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    qcmResponse.contains(
                                                            index.toString())
                                                        ? Colors.pinkAccent
                                                        : Colors.transparent),
                                        activeColor: Colors.pinkAccent,
                                        side: BorderSide(
                                            width: 2, color: Colors.grey),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: qcmResponse
                                            .contains(index.toString()),
                                        onChanged: (value) {
                                          if (qcmResponse
                                              .contains(index.toString())) {
                                            qcmResponse
                                                .remove(index.toString());
                                          } else {
                                            qcmResponse.add(index.toString());
                                          }
                                        },
                                        title: isFirebaseStorageLink(element)
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: EFadeInImage(
                                                  width: 120,
                                                  height: 90,
                                                  radius: 24,
                                                  image: NetworkImage(element),
                                                ),
                                              )
                                            : EText(element),
                                      )
                                    : RadioListTile(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => qcuResponse.value ==
                                                        index.toString()
                                                    ? Colors.pinkAccent
                                                    : Colors.grey),
                                        value: index.toString(),
                                        groupValue: qcuResponse.value,
                                        onChanged: (value) {
                                          qcuResponse.value = value!;
                                        },
                                        title: isFirebaseStorageLink(element)
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: EFadeInImage(
                                                  width: 120,
                                                  height: 90,
                                                  radius: 24,
                                                  image: NetworkImage(element),
                                                ),
                                              )
                                            : EText(element),
                                      );
                              }).toList(),
                              SimpleOutlineButton(
                                radius: 12,
                                color: Colors.pinkAccent,
                                onTap: () {
                                  showAddPropositionDialog();
                                },
                                child: EText(
                                  "Ajouter",
                                  color: Colors.pinkAccent,
                                ),
                              )
                            ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    });
  }

  void showAddPropositionDialog() {
    String proposition = "";
    var loadingImage = false.obs;
    Get.dialog(Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EColumn(children: [
            EText("Saisissez la proposition"),
            9.h,
            ETextField(
                placeholder: "Saisissez une proposition",
                onSubmitted: (value) {
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
                onChanged: (value) {
                  proposition = value;
                },
                phoneScallerFactor: phoneScallerFactor),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: EText("Ou"),
              ),
            ),
            EText("Selectionnez une image"),
            6.h,
            InkWell(
              onTap: () {
                ImagePicker()
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
                ;
              },
              child: Obx(() => Container(
                    height: 95,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.pinkAccent,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: loadingImage.value
                        ? ECircularProgressIndicator(
                            color: Colors.pinkAccent,
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: Colors.pinkAccent,
                          ),
                  )),
            ),
            18.h,
            SimpleButton(
              color: Colors.pinkAccent,
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
                color: Colors.white,
              ),
            )
          ]),
        ),
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
