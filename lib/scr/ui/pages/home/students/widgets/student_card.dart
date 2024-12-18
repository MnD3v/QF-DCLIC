import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/evolution/student_details.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';
import 'package:immobilier_apk/scr/ui/widgets/fl_chart.dart';
import 'package:immobilier_apk/test.dart';

// class StudentCard extends StatelessWidget {
//   StudentCard({
//     super.key,
//     required this.user,
//   });

//   final Utilisateur user;

//   var points = <double>[];
//   @override
//   Widget build(BuildContext context) {
//     getData();
//     return Container(
//       padding: EdgeInsets.all(12),
//       margin: EdgeInsets.all(6),
//       width: double.infinity,
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//             Color.fromARGB(255, 16, 0, 43),
//             const Color.fromARGB(255, 29, 0, 75)
//           ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//           border: Border.all(color: Colors.white30),
//           borderRadius: BorderRadius.circular(24)),
//       child: EColumn(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                           SizedBox(
//                             width: 45,
//                             height: 45,
//                             child: CircleAvatar(
//                                 backgroundColor: Colors.pink,
//                                 child: EText(
//                                   user.nom[0],
//                                   size: 26,
//                                   weight: FontWeight.bold,
//                                 )),
//                           ),
//               9.w,
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   EText("${user.nom} ${user.prenom}"),
//                   ETextRich(
//                     textSpans: [
//                       ETextSpan(
//                           text: user.points.toStringAsFixed(2),
//                           color: Colors.greenAccent),
//                     ],
//                     size: 30,
//                     font: Fonts.sevenSegment,
//                   )
//                 ],
//               ),

//                 ],
//               ),
//               IconButton(onPressed: () {
//                 Get.to(AllQuizes(user: user), id: 0);
//               }, icon: Icon(Icons.remove_red_eye))
//             ],
//           ),
//           9.h,
//           FutureBuilder(
//               future: getData(),
//               builder: (context, snapshot) {
//                 if (DB.waiting(snapshot)) {
//                   return ECircularProgressIndicator();
//                 }
//                 return LineChartSample2(
//                   points: points,
//                 );
//               }),
//           6.h,
//         ],
//       ),
//     );
//   }

//   getData() async {
//     var q = await DB
//         .firestore(Collections.classes)
//         .doc(user.classe)
//         .collection(Collections.questionnaires)
//          .doc(user.classe)
//         .collection(Collections.production)
//         .orderBy(
//           "date",
//         )
//         .limit(10)
//         .get();
//     var questionnaires = <Questionnaire>[];

//     for (var element in q.docs) {
//       questionnaires.add(await Questionnaire.fromMap(element.data()));
//     }
//         print("....1......");
//     print(questionnaires);
//     print("......r....");
//     points = [];
//     questionnaires.forEach((element) {
//       if (element.maked.containsKey(user.telephone_id)) {
//         points.add(((element.maked[user.telephone_id]!.pointsGagne) /
//                 element.questions.length) *
//             100);
//       } else {
//         points.add(0);
//       }
//     });
//     print("..........");
//     print(points);
//     print("..........");
//   }

// }

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.user,
  });

  final Utilisateur user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(StudentDetails(user: user), id: 0);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 16, 0, 43),
                  const Color.fromARGB(255, 29, 0, 75)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    9.h,
                    SizedBox(
                        width: 165,
                        child: Center(
                            child: EText(
                          "${user!.nom} ${user.prenom}",
                          maxLines: 1,
                        ))),
                  ],
                ),
                ETextRich(
                  textSpans: [
                    ETextSpan(
                        text: user.points.toStringAsFixed(2),
                        weight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ],
                  size: 30,
                  font: Fonts.sevenSegment,
                ),
                6.h,
                Icon(Icons.remove_red_eye)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentPresenceCard extends StatelessWidget {
  const StudentPresenceCard({
    super.key,
    required this.user,
  });

  final Utilisateur user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(StudentDetails(user: user), id: 0);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 16, 0, 43),
                  const Color.fromARGB(255, 29, 0, 75)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    9.h,
                    SizedBox(
                        width: 165,
                        child: Center(
                            child: EText(
                          "${user!.nom} ${user.prenom}",
                          maxLines: 1,
                        ))),
                  ],
                ),
                ETextRich(
                  textSpans: [
                    ETextSpan(
                        text: user.heuresTotal.toString(),
                        weight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ],
                  size: 30,
                  font: Fonts.sevenSegment,
                ),
                6.h,
                Icon(Icons.remove_red_eye)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
