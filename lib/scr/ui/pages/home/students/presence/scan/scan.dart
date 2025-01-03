import 'dart:isolate';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/students/presence/scan/scanner_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:universal_html/html.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController(
      facing: CameraFacing.back, autoStart: true, torchEnabled: false);
  bool detected = false;
  String lastUser = '';
  RxBool retour = false.obs;

  int nombrePayes = 0;

  @override
  void initState() {
    waitAfter(600, () {
      scan_start.value = !scan_start.value;
    });
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  RxBool detect = true.obs;
  RxBool scan_start = false.obs;
  List<String> payes = [];
  @override
  Widget build(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 330.0;

    return Scaffold(
        backgroundColor: Colors.black45,
        body: SafeArea(
          child: Stack(alignment: Alignment.center, children: [
            MobileScanner(
              controller: cameraController,
              onDetect: (capture) async {
                if (detect.value && capture.barcodes[0].rawValue != lastUser) {
                  detect.value = false;
                  loading();
                  try {
                    var date = DateTime.now().toString().split(' ')[0];
                    var heure = DateTime.now().toString().split(' ')[1];
                    await DB
                        .firestore(Collections.presence)
                        .doc(date)
                        .collection(Collections.etudiants)
                        .doc(capture.barcodes[0].rawValue!)
                        .set({
                      "classe": Formateur.currentUser.value!.classe!,
                      "heure": heure
                    });
                    Vibrate.vibrate();
                    AssetsAudioPlayer.newPlayer().open(success!);
                    Get.back();
                    lastUser = capture.barcodes[0].rawValue!;
                  } catch (e) {
                    Get.back();
                    Get.dialog(
                        WarningWidget(message: "Une erreur s'est produite"));
                    // AssetsAudioPlayer.newPlayer().open(error!);
                    await Future.delayed(
                      1.seconds,
                    );
                    Get.back();
                  }

                  detect.value = true;
                }
              },
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.6), BlendMode.srcOut),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: scanArea,
                      width: scanArea,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomPaint(
                foregroundPainter: BorderPainter(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: scanArea + 25,
                      height: scanArea + 25,
                    ),
                    Obx(
                      () => AnimatedPositioned(
                        onEnd: () {
                          scan_start.value = !scan_start.value;
                        },
                        top: scan_start.value ? scanArea : 25,
                        duration: 3.seconds,
                        child: Container(
                          height: 2.82,
                          width: scanArea,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    cameraController.dispose();
                    Get.back(id: 5);
                    // payes.isEmpty
                    //     ? null
                    //     : Repository()
                    //         .setStatistiqueData(data: payes.join(','));
                    // Get.back();
                    // nombrePayes == 0
                    //     ? null
                    //     : Repository().savePayes(nombrePayes: nombrePayes);
                    // f_equalizer();
                  },
                  child: Container(
                      width: 150,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(3)),
                      child: EText('Terminer',
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
            ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       children: [
            //         InkWell(
            //           onTap: () {
            //             M_history_dialog();
            //           },
            //           child: Container(
            //               width: 40,
            //               height: 40,
            //               alignment: Alignment.center,
            //               decoration: BoxDecoration(
            //                   color: Colors.grey,
            //                   borderRadius: BorderRadius.circular(3)),
            //               child: Icon(Icons.history, color: Colors.white)),
            //         ),
            //         12.w,
            //       ],
            //     ),
            //   ),
            // ),

            Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      cameraController.toggleTorch();
                    },
                    child: Icon(CupertinoIcons.lightbulb_fill,
                        color: Colors.orange, size: 33),
                  ),
                ))
          ]),
        ));
  }

  Future<dynamic> M_history_dialog() {
    return Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EColumn(children: [
              EText(
                'Payés',
                color: Colors.pinkAccent,
                size: 24,
              ),
              6.h,
              // ...DriverHomePage.dayScans
              //     .map(
              //       (e) => Padding(
              //         padding: const EdgeInsets.all(3.0),
              //         child: Container(
              //           width: double.maxFinite,
              //           color: Colors.white,
              //           child: Padding(
              //             padding: const EdgeInsets.all(12.0),
              //             child: EText(e,
              //                 color: EColors.textColor,
              //                 font: Fonts.interMedium,
              //                 size: 22),
              //           ),
              //         ),
              //       ),
              //     )
              //     .toList(),
            ]),
          ),
        ),
      ),
    );
  }
}
