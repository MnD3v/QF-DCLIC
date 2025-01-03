import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/others/db.dart';
import 'package:my_widgets/widgets/scaffold.dart';

class PresenceDetails extends StatelessWidget {
  final Utilisateur user;
  final String date;
  PresenceDetails({super.key, required this.user, required this.date});
  var ids = [];
  var presence = Rx<Map<String, bool>>({});
  @override
  Widget build(BuildContext context) {
    waitAfter(5000, () {
      print(presence);
    });

    return EScaffold(
        appBar: AppBar(
          title: EText(
            "${user.nom} ${user.prenom}",
            size: 24,
            weight: FontWeight.bold,
          ),
          actions: [
            Obx(
              () => Row(
                children: [
                  12.w,
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                  3.w,
                  EText(
                    presence.value.values.length.toString(),
                    font: Fonts.sevenSegment,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                  12.w,
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.greenAccent,
                  ),
                  3.w,
                  EText(
                    presence.value.values
                        .where((element) => element)
                        .length
                        .toString(),
                    font: Fonts.sevenSegment,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                  12.w,
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.red,
                  ),
                  3.w,
                  EText(
                    presence.value.values
                        .where((element) => !element)
                        .length
                        .toString(),
                    font: Fonts.sevenSegment,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                  12.w,
                ],
              ),
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width / 250;
          return FutureBuilder(
              future: presenceVerification(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
            
                return ids.isEmpty
                    ? Empty()
                    : DynamicHeightGridView(
                        key: Key(ids.length.toString()),
                        physics: BouncingScrollPhysics(),
                        itemCount: ids.length,
                        crossAxisCount: crossAxisCount.toInt() <= 0
                            ? 1
                            : crossAxisCount.toInt(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        builder: (ctx, index) {
                          return UserPresenceCard(
                            presence: presence,
                            session: ids[index],
                            user: user,
                          );
                        });
              });
        }));
  }

  presenceVerification() async {
    var qEtudiants = await DB
        .firestore(Collections.utilistateurs)
        .where("formateur", isNotEqualTo: true)
        .where("classe", isEqualTo: user.classe)
        .get();
    var qEtudiantsPresents = await DB
        .firestore(Collections.presence)
        .doc(date)
        .collection(Collections.etudiants)
        .get();
    var presentsID = [];

    for (var element in qEtudiantsPresents.docs) {
      presentsID.add(element.id);
    }

    var etudiants = [];

    for (var element in qEtudiants.docs) {
      etudiants.add(Utilisateur.fromMap(element.data()));
    }
  }
}

class UserPresenceCard extends StatelessWidget {
  final Utilisateur user;
  final String session;
  Rx<Map<String, bool>> presence;

  UserPresenceCard(
      {super.key,
      required this.session,
      required this.user,
      required this.presence});

  var present = Rx<bool?>(null);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: AppColors.background900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          EText(session),
          Obx(
            () => present.value == null
                ? ECircularProgressIndicator(
                    height: 20,
                  )
                : present.value == true
                    ? EText(
                        "Présent",
                        color: Colors.greenAccent,
                        weight: FontWeight.bold,
                      )
                    : EText(
                        "Absent",
                        color: Colors.red,
                        weight: FontWeight.bold,
                      ),
          )
        ],
      ),
    );
  }
}
