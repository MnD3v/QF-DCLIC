import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/all_quizes.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';
import 'package:immobilier_apk/test.dart';

class StudentCard extends StatelessWidget {
  StudentCard({
    super.key,
    required this.user,
  });

  final Utilisateur user;

  var points = <double>[];
  @override
  Widget build(BuildContext context) {
    getData();
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(6),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 16, 0, 43),
            const Color.fromARGB(255, 29, 0, 75)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(24)),
      child: EColumn(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: CircleAvatar(
                                backgroundColor: Colors.pink,
                                child: EText(
                                  user.nom[0],
                                  size: 26,
                                  weight: FontWeight.bold,
                                )),
                          ),
              9.w,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EText("${user.nom} ${user.prenom}"),
                  ETextRich(
                    textSpans: [
                      ETextSpan(
                          text: user.points.toStringAsFixed(2),
                          color: Colors.greenAccent),
                    ],
                    size: 30,
                    font: Fonts.sevenSegment,
                  )
                ],
              ),
          
                ],
              ),
              IconButton(onPressed: () {
                Get.to(AllQuizes(user: user), id: 0);
              }, icon: Icon(Icons.remove_red_eye))
            ],
          ),
          9.h,
          FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
                return LineChartSample2(
                  points: points,
                );
              }),
          6.h,
        ],
      ),
    );
  }

  getData() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .orderBy(
          "date",
        )
        .limit(10)
        .get();
    var questionnaires = <Questionnaire>[];

    q.docs.forEach((element) {
      questionnaires.add(Questionnaire.fromMap(element.data()));
    });
    points = [];
    questionnaires.forEach((element) {
      if (element.maked.containsKey(user.telephone_id)) {
        points.add(((element.maked[user.telephone_id]!.pointsGagne) /
                element.questions.length) *
            100);
      } else {
        points.add(0);
      }
    });
    print("..........");
    print(points);
    print("..........");
  }
}
