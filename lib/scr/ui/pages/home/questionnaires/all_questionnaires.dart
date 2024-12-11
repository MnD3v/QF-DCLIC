import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_responses.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = <Questionnaire>[];
  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;

      return EScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: EText(
            "Questionnaires",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: StreamBuilder(
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
              snapshot.data!.docs.forEach((element) {
                questionnaires.add(Questionnaire.fromMap(element.data()));
              });

              return DynamicHeightGridView(
                  itemCount: questionnaires.length,
                  crossAxisCount: crossAxisCount.toInt(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  builder: (ctx, index) {
                    var questionnaire = questionnaires[index];
                    var dejaRepondu =
                        questionnaire.maked.containsKey(telephone).obs;
                    return QuestionnaireCard(
                        dejaRepondu: dejaRepondu,
                        questionnaire: questionnaire,
                        width: width);
                  });
            }),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Get.to(SizedBox(width: 600, child: CreateQuestionnaire()), id: 1);
        }),
      );
    });
  }
}

class QuestionnaireCard extends StatelessWidget {
  const QuestionnaireCard({
    super.key,
    required this.dejaRepondu,
    required this.questionnaire,
    required this.width,
  });

  final RxBool dejaRepondu;
  final Questionnaire questionnaire;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            SizedBox(
     
              child: ViewQuestionnaire(
                dejaRepondu: dejaRepondu,
                questionnaire: questionnaire,
              ),
            ),
            id: 1);
      },
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0d1b2a), const Color.fromARGB(255, 29, 0, 75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EText(
              questionnaire.title,
              color: Colors.white,
              size: 22,
            ),
            EText(
              questionnaire.date
                  .split(" ")[0]
                  .split("-")
                  .reversed
                  .join("-"),
              color: const Color.fromARGB(255, 190, 76, 0),
              size: 18,
              weight: FontWeight.bold,
            ),
            9.h,
            Row(
              children: [
                SimpleButton(
                  width: 122,
                  height: 35,
                  onTap: () {
                    Get.to(
                        ViewResponses(
                          id: questionnaire.id,
                        ),
                        id: 1);
                  },
                  child: EText(
                    "Reponses",
                    color: Colors.black,
                  ),
                ),
                6.w,
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.white12,
                  ),
                  height: 35,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 9.0, top: 3),
                        child: EText(
                          "Voir",
                          color:
                              const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
