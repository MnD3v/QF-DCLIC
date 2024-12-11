import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/brouillon/ardoise/ardoise_brouillon.dart';
import 'package:immobilier_apk/scr/ui/pages/home/brouillon/questionnaire/questionnaire_brouillon.dart';

class Brouillon extends StatelessWidget {
  Brouillon({super.key});

  var widgets = [
    GestureDetector(
      onTap: (){
        Get.to(QuestionnaireBrouillon(), id: 3);
      },
      child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),

        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: AppColors.background),
        child: Column(
          children: [
           Icon(CupertinoIcons.question_diamond, color: Colors.amber,size: 60,),
            9.h,

            EText("Questionnaires", color: Colors.amber,size: 24,),
          ],
        ),
      ),
    ),
      GestureDetector(
      onTap: (){
        Get.to(ArdoiseBrouillon(), id: 3);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: AppColors.background),
        child: Column(
          children: [
            Icon(CupertinoIcons.square, color: Colors.amber,size: 60,),
            9.h,

            EText("Ardoise", color: Colors.amber,size: 24,),
          ],
        ),
      ),
    )
  ];
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
            "Brouillon",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DynamicHeightGridView(
                itemCount: 2,
                crossAxisCount: crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                builder: (ctx, index) {
                  return widgets[index];
                }),
          ));
    });
  }
}
