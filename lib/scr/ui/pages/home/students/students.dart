import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/chart.dart';

class Students extends StatelessWidget {
  Students({super.key});

  final _user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      print(crossAxisCount);
      return FutureBuilder(
          future: DB
              .firestore(Collections.utilistateurs)
              .where("classe", isEqualTo: _user.classe)
              // .orderBy("points", descending: true)
              .get(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot)) {
              return ECircularProgressIndicator();
            }
            var users = <Utilisateur>[];

            snapshot.data!.docs.forEach((element) {
              users.add(Utilisateur.fromMap(element.data()));
            });
            return EScaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: EText(
                  "Etudiants",
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
              body: DynamicHeightGridView(
                  itemCount: users.length,
                  crossAxisCount:
                      crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  builder: (ctx, index) {
                    var user = users[index];
                    return StudentCard(user: user);
                  }),
            );
          });
    });
  }
}

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
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 16, 0, 43), const Color.fromARGB(255, 29, 0, 75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(24)),
      child: EColumn(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: CircleAvatar(
                    backgroundColor: Colors.purple,
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
          SizedBox(
            height: 200,
            width: double.infinity,
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (DB.waiting(snapshot)) {
                    return ECircularProgressIndicator();
                  }
                  return BarCharte(
                    points: points,
                  );
                }),
          ),
          12.h,
          Center(
            child: EText(
              "Graphique de l'evolution des 10 derniers Quiz",
              align: TextAlign.center,
              color: Colors.amber,
              underline: true,
            ),
          )
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
            10);
      } else {
        points.add(0);
      }
    });
    print("..........");
    print(points);
    print("..........");
  }
}
