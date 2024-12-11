import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
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
          return LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width / 400;
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
                child: DynamicHeightGridView(
                    itemCount: sortByDate(question.maked).length,
                    crossAxisCount: crossAxisCount.toInt(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    builder: (ctx, index) {
                      return UserArdoiseQuestionCard(
                          id: sortByDate(question.maked)[index],
                          question: question);
                    }),
             
              ),
            );
          });
        });
  }

  List sortByDate(Map map) {
    List sortedKeys = map.keys.toList()
      ..sort((a, b) => map[a]!.date.compareTo(map[b]!.date));
    return sortedKeys.reversed.toList();
  }
}
