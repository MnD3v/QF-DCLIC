import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/inscription.dart';

class Menu extends StatelessWidget {
  Menu({
    super.key,
    required this.width,
    required this.user,
    required this.maxHeight,
    required this.currentIndex,
    required this.showBrouillonElements,
  });
  final double maxHeight;
  final double width;
  final Utilisateur user;
  final RxInt currentIndex;
  final RxBool showBrouillonElements;
  RxBool showStudentsElements = true.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 0, 43),
      ),
      child: SizedBox(
        height: maxHeight,
        child: EColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Image(
            image: AssetImage(Assets.image("logo.png")),
            height: 60,
          )),
          12.h,
          DottedDashedLine(
            height: 1,
            width: width,
            axis: Axis.horizontal,
            dashColor: Colors.white38,
          ),
          12.h,
          Row(
            children: [
              SizedBox(
                height: 65,
                width: 65,
                child: CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                ),
              ),
              6.w,
              EColumn(children: [
                EText(
                  "${user.nom} ${user.prenom}",
                  weight: FontWeight.bold,
                ),
                6.h,
                EText(
                  "Formateur",
                  size: 16,
                ),
              ])
            ],
          ),

          12.h,
          DottedDashedLine(
            height: 1,
            width: width,
            axis: Axis.horizontal,
            dashColor: Colors.white38,
          ),
          12.h,

          InkWell(
            onTap: () {
              showStudentsElements.value = !showStudentsElements.value;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.person_2_alt,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      9.w,
                      EText("Etudiants",
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: 333.milliseconds,
                      child: Icon(
                        key: Key(showStudentsElements.value.toString()),
                        !showStudentsElements.value
                            ? Icons.keyboard_arrow_right_rounded
                            : Icons.keyboard_arrow_down_outlined,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          12.h,
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Obx(
              () => AnimatedContainer(
                duration: 333.milliseconds,
                height: showStudentsElements.value ? 100 : 0,
                child: EColumn(children: [
                  MenuItem(
                    subElement: true,
                    currentIndex: currentIndex,
                    label: "Evolution",
                    icon: CupertinoIcons.person_2_fill,
                    index: 0,
                  ),
                  MenuItem(
                    subElement: true,
                    currentIndex: currentIndex,
                    label: "Presence",
                    icon: CupertinoIcons.square,
                    index: 5,
                  ),
                ]),
              ),
            ),
          ),

          12.h,
          MenuItem(
            currentIndex: currentIndex,
            label: "Ardoise",
            icon: CupertinoIcons.square,
            index: 1,
          ),
          MenuItem(
            currentIndex: currentIndex,
            label: "Questionnaires",
            icon: CupertinoIcons.question_diamond_fill,
            index: 2,
          ),
          12.h,
          InkWell(
            onTap: () {
              showBrouillonElements.value = !showBrouillonElements.value;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.archivebox,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      9.w,
                      EText("Brouillon",
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: 333.milliseconds,
                      child: Icon(
                        key: Key(showBrouillonElements.value.toString()),
                        !showBrouillonElements.value
                            ? Icons.keyboard_arrow_right_rounded
                            : Icons.keyboard_arrow_down_outlined,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          12.h,
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Obx(
              () => AnimatedContainer(
                duration: 333.milliseconds,
                height: showBrouillonElements.value ? 100 : 0,
                child: EColumn(children: [
                  MenuItem(
                    subElement: true,
                    currentIndex: currentIndex,
                    label: "Questionnaires",
                    icon: CupertinoIcons.question_diamond_fill,
                    index: 3,
                  ),
                  MenuItem(
                    subElement: true,
                    currentIndex: currentIndex,
                    label: "Ardoise",
                    icon: CupertinoIcons.square,
                    index: 4,
                  ),
                ]),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 40.0),
          //   child: Obx(
          //     () => AnimatedContainer(
          //       duration: 333.milliseconds,
          //       height: showBrouillonElements.value ? 100 : 0,
          //       child: EColumn(
          //         children: [
          //           3.h,
          //           InkWell(
          //             onTap: () {
          //               if (Get.isDialogOpen ?? false) {
          //                 Get.back();
          //               }
          //               currentIndex.value = 3;
          //               // waitAfter(50, () {
          //               //   Get.to(QuestionnaireBrouillon(), id: 3);
          //               // });
          //             },
          //             child: Container(
          //               height: 40,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(24),
          //                   color: Colors.transparent),
          //               child: Row(
          //                 children: [
          //                   Icon(
          //                     CupertinoIcons.question_diamond,
          //                     color: currentIndex.value == 3
          //                         ? Colors.pink
          //                         : Colors.white60,
          //                   ),
          //                   6.w,
          //                   EText(
          //                     "Questionnaires",
          //                     color: currentIndex.value == 3
          //                         ? Colors.pink
          //                         : Colors.white60,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           6.h,
          //           InkWell(
          //             onTap: () {
          //               if (Get.isDialogOpen ?? false) {
          //                 Get.back();
          //               }
          //               currentIndex.value = 4;
          //             },
          //             child: Container(
          //               height: 40,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(24),
          //                   color: Colors.transparent),
          //               child: Row(
          //                 children: [
          //                   Icon(
          //                     CupertinoIcons.square,
          //                     color: currentIndex.value == 4
          //                         ? Colors.pink
          //                         : Colors.white60,
          //                   ),
          //                   6.w,
          //                   EText(
          //                     "Ardoise",
          //                     color: currentIndex.value == 4
          //                         ? Colors.pink
          //                         : Colors.white60,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          12.h,
          DottedDashedLine(
            height: 1,
            width: width,
            axis: Axis.horizontal,
            dashColor: Colors.white38,
          ),
          24.h,
          !user.admin
              ? 0.h
              : SimpleButton(
                  onTap: () {
                    Custom.showDialog(
                        dialog: Dialog(child: Inscription(function: () {})));
                  },
                  child: EText("Ajouter un foramteur"),
                ),
          12.h,
          SimpleOutlineButton(
            radius: 12,
            color: Colors.pink,
            onTap: () {
              Custom.showDialog(
                  dialog: TwoOptionsDialog(
                      confirmationText: "Me deconnecter",
                      confirmFunction: () {
                        FirebaseAuth.instance.signOut();
                        Utilisateur.currentUser.value = null;

                        //  Get.off(Connexion());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Connexion(),
                          ),
                          (route) => false,
                        );
                        Toasts.success(context,
                            description:
                                "Vous vous êtes déconnecté avec succès");
                      },
                      body: "Voulez-vous vraiment vous deconnecter ?",
                      title: "Déconnexion"));
            },
            child: EText("Deconnexion"),
          ),
          64.h,
        ]),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  String label;
  IconData icon;
  RxInt currentIndex;
  int index;
  bool? subElement;
  MenuItem(
      {super.key,
      required this.icon,
      this.subElement,
      required this.currentIndex,
      required this.label,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: subElement == true ? .6 : 1,
      child: InkWell(
          onTap: () {
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            currentIndex.value = index;
          },
          child: Obx(
            () => AnimatedContainer(
                duration: 333.milliseconds,
                height: 40,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12),
                margin: EdgeInsets.symmetric(vertical: 6),
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: currentIndex.value == index
                              ? Colors.pinkAccent
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        9.w,
                        EText(
                          label,
                          color: currentIndex.value == index
                              ? Colors.pinkAccent
                              : const Color.fromARGB(255, 255, 255, 255),
                          weight: currentIndex.value == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: currentIndex.value == index
                          ? Colors.pinkAccent
                          : const Color.fromARGB(0, 255, 255, 255),
                      size: 15,
                    )
                  ],
                )),
          )),
    );
  }
}
