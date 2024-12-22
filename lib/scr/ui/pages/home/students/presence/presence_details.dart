import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/others/db.dart';
import 'package:my_widgets/widgets/scaffold.dart';

class PresenceDetails extends StatelessWidget {
  final Utilisateur user;
  PresenceDetails({super.key, required this.user});
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
            Obx(()=>
               Row(
                children: [
                          12.w,
                         Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                  3.w,
                  EText(presence.value.values
                     
                      .length
                      .toString(), font: Fonts.sevenSegment, size: 24, weight: FontWeight.bold,),
                      12.w,
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.greenAccent,
                  ),
                  3.w,
                  EText(presence.value.values
                      .where((element) => element)
                      .length
                      .toString(), font: Fonts.sevenSegment, size: 24, weight: FontWeight.bold,),
                  12.w,
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.red,
                  ),
                  3.w,
       

                        EText(presence.value.values
                      .where((element) => !element)
                      .length
                      .toString(), font: Fonts.sevenSegment, size: 24, weight: FontWeight.bold,),
              

                     
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
              future: DB
                  .firestore(Collections.classes)
                  .doc(user.classe)
                  .collection(Collections.sessions)
                  .orderBy("date")
                  .get(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
                print(snapshot.data!.docs.length);
                snapshot.data!.docs.forEach((element) {
                  ids.add(element.id);
                });
                return ids.isEmpty
                    ? Empty(constraints: constraints)
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
    presenceVerification();
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

  presenceVerification() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.sessions)
        .doc(session)
        .collection(Collections.sessions)
        .doc(user.telephone_id)
        .get();

    if (q.exists) {
      present.value = true;
    } else {
      present.value = false;
    }
    presence.update((value) {
      value?.putIfAbsent(session, () => present.value!);
    });
  }
}
