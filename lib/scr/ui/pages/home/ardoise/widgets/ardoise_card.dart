import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/ardoise/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/view_ardoise_responses.dart';

class ArdoiseQuestionCard extends StatelessWidget {
  ArdoiseQuestionCard(
      {super.key,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.qctResponse,
      required this.qcmResponse,
      required this.question});
  final ArdoiseQuestion question;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final RxString qctResponse;
  final RxList<String> qcmResponse;

  var sendLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 333.milliseconds,
      width: Get.width,
      decoration: BoxDecoration(
        // color: Color.fromARGB(0, 30, 95, 145),
        // gradient: LinearGradient(colors: [Colors.transparent, const Color.fromARGB(255, 15, 53, 88)]),
        border: Border.all(width: .6, color: Colors.white24),
        boxShadow: [
          BoxShadow(
              color: Colors.white12,
              offset: Offset(3, 3),
              blurStyle: BlurStyle.inner,
              blurRadius: 15),
        ],
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(9),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                child: ETextRich(
                  textSpans: [
                    ETextSpan(
                        text: question.question,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        weight: FontWeight.bold),
                  ],
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        // DottedDashedLine(
        //   height: 0,
        //   width: Get.width - 24,
        //   axis: Axis.horizontal,
        //   dashColor: Colors.white54,
        // ),
        question.type == QuestionType.qct
            ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 18),
                    child: EColumn(
                      children: [

                        EText(
                          question.reponse,
                          color: Colors.greenAccent,
                        )
                      ],
                    ),
                  )
              
            : Obx(
                () => EColumn(
                    children: question.choix.keys.map((e) {
                  return !(question.type == QuestionType.qcm)
                      ? IgnorePointer(
                          ignoring: dejaRepondu.value,
                          child: RadioListTile(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcuResponse.value == e
                                    ? Colors.amber
                                    : Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            value: e,
                            groupValue: qcuResponse.value,
                            onChanged: (value) {
                              qcuResponse.value = value as String;
                            },
                            title: isFirebaseStorageLink(question.choix[e]!)
                                ? Container(
                                    width: Get.width,
                                    alignment: Alignment.centerLeft,
                                    height: 90,
                                    child: EFadeInImage(
                                      radius: 12,
                                      image: NetworkImage(question.choix[e]!),
                                    ))
                                : EText(
                                    question.choix[e],
                                    color: 
                                            question.reponse == e
                                        ? Colors.greenAccent
                                        : Colors.white,
                                  ),
                          ),
                        )
                      : CheckboxListTile(
                          enabled: !dejaRepondu.value,
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              qcmResponse.contains(e)
                                  ? Colors.amber
                                  : Colors.transparent),
                          activeColor: Colors.amber,
                          side: BorderSide(width: 2, color: Colors.grey),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          value: qcmResponse.contains(e),
                          onChanged: (value) {
                            qcmResponse.contains(e)
                                ? qcmResponse.remove(e)
                                : qcmResponse.add(e);
                          },
                          title: isFirebaseStorageLink(question.choix[e]!)
                              ? Container(
                                  width: Get.width,
                                  alignment: Alignment.centerLeft,
                                  height: 90,
                                  child: EFadeInImage(
                                    radius: 12,
                                    image: NetworkImage(question.choix[e]!),
                                  ))
                              : EText(
                                  question.choix[e],
                                  color: 
                                          question.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : Colors.white,
                                ),
                        );
                }).toList()),
              ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleButton(
        height: 35,
        width: 140,
        onTap: (){
          Get.to(ViewArdoiseResponses(id: question.id), id: 2);
      }, child: EText("Reponses", color: Colors.black,),),
    )
      ]),
    );
  }
}
