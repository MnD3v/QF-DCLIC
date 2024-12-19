import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:my_widgets/my_widgets.dart';

class AddQuestion extends StatelessWidget {
  RxList<Question> questions;
  AddQuestion({super.key, required this.questions});
  var qcuResponse = "".obs;
  var qcmResponse = RxList<String>();
  var qctResponse = "";

  var propositions = RxList<String>();

  var type = "qcm".obs;

  String title = "";
  var titleImage = Rx<String?>(null);
  var loadingImage = false.obs;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.background900,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 9),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              EColumn(children: [
                75.h,
                EText("Intitulé de la question"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth - 85,
                      child: ETextField(
                          placeholder: "Saisissez l'intitulé de la question",
                          onChanged: (value) {
                            title = value;
                          },
                          phoneScallerFactor: phoneScallerFactor),
                    ),
                    6.w,
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
                              link = await FStorage.putData(
                                  await value!.readAsBytes());
                            } else {
                              link = await FStorage.putFile(File(value!.path));
                            }
                            loadingImage.value = false;
                            print(link);
                            titleImage.value = link;
                          },
                        ).onError((_, __) {
                          loadingImage.value = false;
                        });
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: Colors.pinkAccent)),
                          child: Obx(
                            () => titleImage.value != null
                                ? EFadeInImage(
                                    height: 50,
                                    width: 50,
                                    radius: 9,
                                    image: NetworkImage(titleImage.value!))
                                : loadingImage.value
                                    ? ECircularProgressIndicator(
                                        height: 16,
                                      )
                                    : Icon(
                                        Icons.image_outlined,
                                        color: Colors.pinkAccent,
                                      ),
                          )),
                    )
                  ],
                ),
                12.h,
                EText("Type de la question"),
                Obx(
                  () => Column(
                    children: [
                      RadioListTile(
                        fillColor: MaterialStateColor.resolveWith((states) =>
                            type.value == QuestionType.qcm
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
                        fillColor: MaterialStateColor.resolveWith((states) =>
                            type.value == QuestionType.qcu
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
                        fillColor: MaterialStateColor.resolveWith((states) =>
                            type.value == QuestionType.qct
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
                9.h,
                3.h,
                Obx(
                  () => type.value == QuestionType.qct
                      ? EColumn(
                          children: [
                            EText("Réponse attendue"),
                            ETextField(
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
                          EText("Ajouter des propositions"),
                          propositions.isEmpty
                              ? Column(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                        Assets.image("empty-2.png"),
                                      ),
                                      height: 80,
                                    ),
                                    EText(
                                      "Aucune question ajouté",
                                      color: Colors.pinkAccent,
                                    )
                                  ],
                                )
                              : 0.h,
                          ...propositions.value.map((element) {
                            var index = propositions.value.indexOf(element);
                            return type.value == QuestionType.qcm
                                ? CheckboxListTile(
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => qcmResponse
                                                .contains(index.toString())
                                            ? Colors.pinkAccent
                                            : Colors.transparent),
                                    activeColor: Colors.pinkAccent,
                                    side: BorderSide(
                                        width: 2, color: Colors.grey),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value:
                                        qcmResponse.contains(index.toString()),
                                    onChanged: (value) {
                                      if (qcmResponse
                                          .contains(index.toString())) {
                                        qcmResponse.remove(index.toString());
                                      } else {
                                        qcmResponse.add(index.toString());
                                      }
                                    },
                                    title: isFirebaseStorageLink(element)
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: EFadeInImage(
                                              width: 120,
                                              height: 120,
                                              image: NetworkImage(element),
                                            ),
                                          )
                                        : EText(element),
                                  )
                                : RadioListTile(
                                    fillColor: MaterialStateColor.resolveWith(
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
                                              height: 120,
                                              image: NetworkImage(element),
                                            ),
                                          )
                                        : EText(element),
                                  );
                          }).toList(),
                          12.h,
                          SimpleButton(
                            radius: 12,
                            onTap: () {
                              showAddPropositionDialog(context);
                            },
                            child: EText(
                              "Ajouter une proposition",
                              color: Colors.white,
                            ),
                          )
                        ]),
                ),
              ]),
              Container(
                decoration: BoxDecoration(color: AppColors.background900),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SimpleButton(
                          radius: 12,
                          width: 120,
                          color: Colors.pinkAccent,
                          onTap: () {
                            if (loadingImage.value) {
                              Toasts.error(context,description: 
                                      "Attendez que l'image finisse de charger");
                              return;
                            }
                            if (title.isEmpty) {
                              Toasts.error(context,description: 
                                      "Veuillez saisir l'intitulé de la question");
                              return;
                            }
                            if (type.value != QuestionType.qct &&
                                propositions.length < 2) {
                              Toasts.error(context,description: 
                                      "Veuillez ajouter au-moins deux propositions");
                              return;
                            }
                            Question? question;

                            //liste en map
                            Map<String, String> choix = {};
                            propositions.forEach((value) {
                              var index = propositions.indexOf(value);
                              choix.putIfAbsent(index.toString(), () => value);
                            });
                            //liste en map
                            if (type == QuestionType.qcu) {
                              if (qcuResponse.value.isEmpty) {
                                Toasts.error(context,description:  "Veuillez choisir la reponse");
                                return;
                              }
                              question = Question(
                                  question: title,
                                  choix: choix,
                                  reponse: qcuResponse.value,
                                  type: QuestionType.qcu);
                            } else if (type == QuestionType.qcm) {
                              if (qcmResponse.value.isEmpty) {
                                Toasts.error(context,description:  "Veuillez choisir la reponse");
                                return;
                              }
                              question = Question(
                                  question: title,
                                  choix: choix,
                                  reponse: qcmResponse.value,
                                  type: QuestionType.qcm);
                            } else {
                              if (qctResponse.isEmpty) {
                                Toasts.error(context,description: 
                                        "Veuillez saisir la réponse à la question");
                                return;
                              }
                              question = Question(
                                  question: title,
                                  choix: choix,
                                  reponse: qctResponse,
                                  type: QuestionType.qct);
                            }
                            question.image = titleImage.value;
                            questions.add(question);
                            Get.back();
                          },
                          child: EText(
                            "Ajouter",
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void showAddPropositionDialog(context) {
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
                    Toasts.error(context,description:  "Veuillez saisir une proposition valable");
                    return;
                  }
                  if (propositions.contains(proposition)) {
                    Toasts.error(context,description:  "Evitez d'entrer des propositions identiques");
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
                  Toasts.error(context,description:  "Veuillez saisir une proposition valable");
                  return;
                }
                if (propositions.contains(proposition)) {
                  Toasts.error(context,description:  "Evitez d'entrer des propositions identiques");
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
