import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/presence/presence_list.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/presence/scan/scan.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';

class Presence extends StatelessWidget {
  const Presence({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Formateur.currentUser.value!;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return EScaffold(
        appBar: AppBar(
          leading: Get.width > 600
              ? null
              : MenuBoutton(user: user, constraints: constraints, width: width),
          title: EText("Verification de présence"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.dialog(Dialog(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300, minWidth: 300),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: EColumn(children: [
                          EText(
                            "Historique",
                            size: 24,
                            weight: FontWeight.bold,
                          ),
                          12.h,
                          FutureBuilder(
                              future: DB.firestore(Collections.presence).orderBy("date", descending: true).get(),
                              builder: (context, snapshot) {
                                if (DB.waiting(snapshot)) {
                                  return ECircularProgressIndicator();
                                }
                                var dates = <String>[];
                                snapshot.data?.docs.forEach((element) {
                                  dates.add(element.data()['date']);
                                });
                                return dates.isEmpty
                                    ? Empty(constraints: constraints)
                                    : EColumn(
                                        children: dates
                                            .map((date) => InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    Get.to(
                                                        PresenceList(
                                                            user: user,
                                                            date: date),
                                                        id: 5);
                                                  },
                                                  child: Container(
                                                      width: Get.width,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: EText(
                                                          GFunctions.isToday(
                                                                  date)
                                                              ? "Aujourd'hui"
                                                              : date)),
                                                ))
                                            .toList());
                              })
                        ]),
                      ),
                    ),
                  ));
                },
                icon: Icon(Icons.history_rounded)),
            12.w,
          ],
        ),
        body: Center(
          child: EColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.qrcode_viewfinder,
                size: 200,
              ),
              SimpleButton(
                width: 100,
                onTap: () {
                  var date = DateTime.now().toString().split(" ")[0];
                  DB
                      .firestore(Collections.presence)
                      .doc(date)
                      .set({"date": date});
                  Get.to(Scanner(), id: 5);
                },
                text: "Debuter",
              ),
            ],
          ),
        ),
      );
    });
  }
}


// import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:immobilier_apk/scr/config/app/export.dart';
// import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
// import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';
// import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/student_card.dart';
// import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
// import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
// import 'package:http/http.dart' as http;
// import 'package:ntp/ntp.dart';

// class Presence extends StatelessWidget {
//   Presence({super.key});
//   final formateur = Formateur.currentUser.value!;
//   var users = Rx<List<Utilisateur>?>(null);

//   var user = Formateur.currentUser.value!;

//   var ipAdress = "".obs;

//   var presenceAnimation = false.obs;

//   var useIP = true.obs;
//   @override
//   Widget build(BuildContext context) {
//     waitAfter(555, () {
//       presenceAnimation.value = !presenceAnimation.value;
//     });
//     var code = Random().nextDouble().toString().split(".")[1].substring(0, 5);

//     return LayoutBuilder(builder: (context, constraints) {
//       calculStats();
//       final width = constraints.maxWidth;
//       final crossAxisCount = width / 250;
//       print(crossAxisCount);
//       return StreamBuilder(
//           stream: DB
//               .firestore(Collections.classes)
//               .doc(formateur.classe)
//               .collection(Collections.utilistateurs)
//               .orderBy("heuresTotal", descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (DB.waiting(snapshot) && users.value.isNul) {
//               return ECircularProgressIndicator();
//             }
//             var tempUsers = <Utilisateur>[];
//             for (var element in snapshot.data!.docs) {
//               tempUsers.add(Utilisateur.fromMap(element.data()));
//             }
//             users.value = tempUsers;
//             return EScaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 surfaceTintColor: Colors.transparent,
//                 leading: Get.width > 600
//                     ? null
//                     : MenuBoutton(
//                         user: user, constraints: constraints, width: width),
//                 title: EText(
//                   "Etudiants",
//                   size: 24,
//                   weight: FontWeight.bold,
//                 ),
//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.search,
//                           color: Colors.white24,
//                         ),
//                         SizedBox(
//                           width: width / 3,
//                           child: ETextField(
//                               smallHeight: true,
//                               radius: 40,
//                               border: true,
//                               placeholder: "Rechercher",
//                               onChanged: (value) {
//                                 users.value = tempUsers
//                                     .where((element) =>
//                                         ("${element.nom} ${element.prenom}")
//                                             .toLowerCase()
//                                             .contains(value.toLowerCase()))
//                                     .toList();
//                               },
//                               phoneScallerFactor: phoneScallerFactor),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               body: Obx(
//                 () => AnimatedSwitcher(
//                   duration: 666.milliseconds,
//                   child: users.value!.isEmpty
//                       ? Empty(
//                           constraints: constraints,
//                         )
//                       : DynamicHeightGridView(
//                           key: Key(users.value!.length.toString()),
//                           physics: BouncingScrollPhysics(),
//                           itemCount: users.value!.length,
//                           crossAxisCount: crossAxisCount.toInt() <= 0
//                               ? 1
//                               : crossAxisCount.toInt(),
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                           builder: (ctx, index) {
//                             var user = users.value![index];
//                             return StudentPresenceCard(user: user);
//                           }),
//                 ),
//               ),
//               floatingActionButton: InkWell(
//                   onTap: () async {
//                     var date = DateTime.now().toString().split(" ")[0];
//                     var moment = "";
//                     var heure = int.parse(
//                         DateTime.now().toString().split(" ")[1].split(":")[0]);
//                     if (heure < 12) {
//                       moment = "Matin";
//                     } else {
//                       moment = "Soir";
//                     }
//                     date += " $moment";
//                     print(code);
//                     DB
//                         .firestore(Collections.classes)
//                         .doc(user.classe)
//                         .collection(Collections.sessions)
//                         .doc(date)
//                         .set({"date": date});

//                     waitAfter(0, () async {
//                       await getPublicIP();
//                       DB
//                           .firestore(Collections.classes)
//                           .doc(user.classe)
//                           .collection(Collections.verification)
//                           .doc("Verification")
//                           .set({
//                         "verification": true,
//                         "code": code,
//                         "useIP": true,
//                         "date": date,
//                         "ip": ipAdress.value,
//                         "heures": moment == "Matin" ? 4 : 3
//                       });
//                     });
//                     Custom.showDialog(
//                         dismissible: false,
//                         dialog: Dialog(
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(maxWidth: 500),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     12.h,
//                                     EText(
//                                       "Verification de présence",
//                                       size: 28,
//                                       weight: FontWeight.bold,
//                                     ),
//                                     12.h,
//                                     Obx(() => Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             EText("Adresse IP: "),
//                                             ipAdress.value.isEmpty
//                                                 ? ECircularProgressIndicator(
//                                                     height: 20,
//                                                   )
//                                                 : EText(ipAdress.value,
//                                                     color: Colors.pinkAccent),
//                                             Switch(
//                                                 value: useIP.value,
//                                                 activeTrackColor:
//                                                     const Color.fromARGB(
//                                                         255, 255, 156, 211),
//                                                 hoverColor: Colors.white,
//                                                 thumbColor:
//                                                     MaterialStateProperty.all(
//                                                         Colors.pink),
//                                                 onChanged: (value) {
//                                                   useIP.value = value;
//                                                   DB
//                                                       .firestore(
//                                                           Collections.classes)
//                                                       .doc(user.classe)
//                                                       .collection(Collections
//                                                           .verification)
//                                                       .doc("Verification")
//                                                       .set({
//                                                     "verification": true,
//                                                     "useIP": useIP.value,
//                                                     "date": date,
//                                                     "ip": ipAdress.value
//                                                   });
//                                                 })
//                                           ],
//                                         )),
//                                     Center(
//                                         child: EText(
//                                       code,
//                                       size: 50,
//                                     )),
//                                     12.h,
//                                     SimpleButton(
//                                       onTap: () {
//                                         DB
//                                             .firestore(Collections.classes)
//                                             .doc(user.classe)
//                                             .collection(
//                                                 Collections.verification)
//                                             .doc("Verification")
//                                             .set({
//                                           "verification": false,
//                                           "useIP": useIP.value,
//                                           "date": date,
//                                           "ip": ipAdress.value
//                                         });
//                                         Get.back();
//                                       },
//                                       text: "Arreter",
//                                     )
//                                   ]),
//                             ),
//                           ),
//                         ));
//                   },
//                   child: Obx(
//                     () => Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.greenAccent, width: 3),
//                       ),
//                       child: AnimatedContainer(
//                         onEnd: () {
//                           presenceAnimation.value = !presenceAnimation.value;
//                         },
//                         duration: 666.milliseconds,
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: presenceAnimation.value
//                                 ? Colors.greenAccent
//                                 : Colors.transparent),
//                       ),
//                     ),
//                   )),
//             );
//           });
//     });
//   }

//   Future<String> getPublicIP() async {
//     try {
//       final response =
//           await http.get(Uri.parse('https://api64.ipify.org?format=json'));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("********************************************");
//         print(data['ip']);
//         print("********************************************");
//         ipAdress.value = data['ip'];
//         return data['ip']; // Adresse IP publique
//       }
//       return 'Erreur : Impossible de récupérer l\'adresse IP';
//     } catch (e) {
//       return 'Erreur : $e';
//     }
//   }

//   calculStats() async {
//     var q = await DB
//         .firestore(Collections.classes)
//         .doc(user.classe)
//         .collection(Collections.sessions)
//         .get();
//     print(q.docs.length);
//   }
// }
