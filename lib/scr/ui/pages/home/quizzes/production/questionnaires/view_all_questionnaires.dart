import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/create_questionnaire.dart';

import 'package:immobilier_apk/scr/ui/pages/home/quizzes/production/questionnaires/widgets/questionnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/menu_boutton.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/data/models/questionnaire.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = Rx<List<Questionnaire>?>(null);

  var user = Formateur.currentUser.value!;

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
              .doc(user.classe)
              .collection(Collections.production)
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot) && questionnaires.value.isNul) {
              return ECircularProgressIndicator();
            }

            var telephone = Formateur.currentUser.value!.telephone_id;

            var tempQuestionnaires = <Questionnaire>[];

            waitAfter(0, () async {
              for (var element in snapshot.data!.docs) {
                tempQuestionnaires
                    .add(await Questionnaire.fromMap(element.data(), classe: user.classe!), );
              }
              questionnaires.value = tempQuestionnaires;
            });

            return EScaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                     leading:Get.width>600?null: MenuBoutton(user: user, constraints: constraints, width: width),   title: EText(
                  "Questionnaires",
                  size: 24,
                  weight: FontWeight.bold,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white24,),
                        SizedBox(
                          width: width / 3,
                          child: ETextField(
                            smallHeight: true,
                              radius: 40,
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
                      ],
                    ),
                  )
                ],
              ),
              body: Obx(
                () => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: questionnaires.value.isNul
                      ? ECircularProgressIndicator()
                      : questionnaires.value!.isEmpty
                          ?Empty(
                            )
                          : DynamicHeightGridView(
                              physics: BouncingScrollPhysics(),
                              key: Key(questionnaires.value!.length.toString()),
                              itemCount: questionnaires.value!.length,
                              crossAxisCount: crossAxisCount.toInt() <= 0
                                  ? 1
                                  : crossAxisCount.toInt(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              builder: (ctx, index) {
                                var questionnaire =
                                    questionnaires.value![index];
                                var dejaRepondu = questionnaire.maked
                                    .containsKey(telephone)
                                    .obs;
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
