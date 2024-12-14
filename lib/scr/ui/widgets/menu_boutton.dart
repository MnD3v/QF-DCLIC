import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/widgets/menu.dart';

class MenuBoutton extends StatelessWidget {
  const MenuBoutton(
      {super.key,
      required this.user,
      required this.constraints,
      required this.width});
  final user;
  final constraints;
  final width;
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
          margin: EdgeInsets.all(6),
          height: 40,width: 40,
          decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(6)),
          child: IconButton(
            onPressed: () {
              Get.dialog(
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Scaffold(
                      backgroundColor: Colors.black38,
                      body: Menu(
                          maxHeight: constraints.maxHeight,
                          width: width,
                          user: user,
                          currentIndex: currentMenuIndex,
                          showBrouillonElements: true.obs),
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.pink, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close)),
                    )
                  ],
                ),
              );
            },
            icon: Icon(Icons.menu),
          )),
    );
  }
}
