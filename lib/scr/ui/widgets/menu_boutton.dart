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
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.white12, borderRadius: BorderRadius.circular(6)),
          child: IconButton(
            onPressed: () {
              Get.generalDialog(
                  barrierColor: Colors.white12,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(-(1 - animation.value) * 100, 0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: Scaffold(
                                  backgroundColor: Colors.black38,
                                  body: 
                                  GestureDetector(
                                    onTap: (){
                                      
                                    },
                                    child: Menu(
                                        maxHeight: constraints.maxHeight,
                                        width: width,
                                        user: user,
                                        currentIndex: currentMenuIndex,
                                        showBrouillonElements: true.obs),
                                  ),
                                ),
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
                    );
                  },
                  barrierLabel: "");
            },
            icon: Icon(Icons.menu),
          )),
    );
  }
}
