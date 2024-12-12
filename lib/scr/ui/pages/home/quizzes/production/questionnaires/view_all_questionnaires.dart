import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/create_questionnaire.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/questionnaire_card.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/data/models/questionnaire.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = RxList<Questionnaire>([]);
  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;

      return StreamBuilder(
          stream: DB
              .firestore(Collections.classes)
              .doc(user.classe)
              .collection(Collections.questionnaires)
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot)) {
              return ECircularProgressIndicator();
            }

            var telephone = Utilisateur.currentUser.value!.telephone_id;
            questionnaires.clear();
            var tempQuestionnaires = <Questionnaire>[];
            snapshot.data!.docs.forEach((element) {
              tempQuestionnaires.add(Questionnaire.fromMap(element.data()));
            });
            questionnaires.value = tempQuestionnaires;

            return EScaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: EText(
                  "Questionnaires",
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: width / 3,
                      child: ETextField(
                          radius: 12,
                          border: true,
                          placeholder: "Rechercher",
                          onChanged: (value) {
                            questionnaires.value = tempQuestionnaires
                                .where((element) => (element.title)
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          },
                          phoneScallerFactor: phoneScallerFactor),
                    ),
                  )
                ],
              ),
              body: Obx(
                () => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: questionnaires.isEmpty
                      ? Lottie.asset(Assets.image("empty.json"), height: 400)
                      : DynamicHeightGridView(
                          physics: BouncingScrollPhysics(),
                          key: Key(questionnaires.length.toString()),
                          itemCount: questionnaires.length,
                          crossAxisCount: crossAxisCount.toInt() <= 0
                              ? 1
                              : crossAxisCount.toInt(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          builder: (ctx, index) {
                            var questionnaire = questionnaires[index];
                            var dejaRepondu =
                                questionnaire.maked.containsKey(telephone).obs;
                            return QuestionnaireCard(
                                navigationId: 1,
                                dejaRepondu: dejaRepondu,
                                questionnaire: questionnaire,
                                width: width);
                          }),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.to(SizedBox(width: 600, child: CreateQuestionnaire()),
                      id: 1);
                },
                child: Icon(Icons.add),
              ),
            );
          });
    });
  }
}
