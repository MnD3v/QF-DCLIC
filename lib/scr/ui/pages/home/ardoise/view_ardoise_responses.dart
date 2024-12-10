import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/widgets/ardoise_card.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/widgets/user_ardoise_card.dart';

class ViewArdoiseResponses extends StatelessWidget {
  final String id;
  ViewArdoiseResponses({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc(Utilisateur.currentUser.value!.classe)
            .collection(Collections.ardoise)
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }

          ArdoiseQuestion question =
              ArdoiseQuestion.fromMap(snapshot.data!.data()!);
          return EScaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: EText(
                "Reponses",
                size: 24,
                weight: FontWeight.bold,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: EColumn(children: [
                EText(question.question,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    weight: FontWeight.bold),
                ...(sortByDate(question.maked)
                    .map((key) =>
                        UserArdoiseQuestionCard(id: key, question: question))
                    .toList()),
              ]),
            ),
          );
        });
  }
 List sortByDate(Map map){
    List sortedKeys = map.keys.toList()
    ..sort((a, b) => map[a]!.date.compareTo(map[b]!.date));
    return sortedKeys.reversed.toList();
  }
}
