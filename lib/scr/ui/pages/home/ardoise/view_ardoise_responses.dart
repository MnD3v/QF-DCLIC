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
            body: EColumn(
              children: question.maked.keys
                  .map((key) => UserArdoiseQuestionCard(
                    id: key,

                      question: question))
                  .toList(),
            ),
          );
        });
  }
}
