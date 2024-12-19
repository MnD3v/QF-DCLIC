import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/others/db.dart';
import 'package:my_widgets/widgets/scaffold.dart';

class PresenceDetails extends StatelessWidget {
  final Utilisateur user;
  PresenceDetails({super.key, required this.user});
  var ids = [];
  @override
  Widget build(BuildContext context) {
    return EScaffold(
        appBar: AppBar(
          title: EText(
            "${user.nom} ${user.prenom}",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width / 250;
          return FutureBuilder(
              future: DB
                  .firestore(Collections.classes)
                  .doc(user.classe)
                  .collection(Collections.presence)
                  .orderBy("date")
                  .get(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
                print(snapshot.data!.docs.length);
                snapshot.data!.docs.forEach((element) {
                  if (element.id != "Verification") {
                    ids.add(element.id);
                  }
                });
                return DynamicHeightGridView(
                    key: Key(ids.length.toString()),
                    physics: BouncingScrollPhysics(),
                    itemCount: ids.length,
                    crossAxisCount: crossAxisCount.toInt() <= 0
                        ? 1
                        : crossAxisCount.toInt(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    builder: (ctx, index) {
                      return NewWidget(
                        element: ids[index],
                        user: user,
                      );
                    });
              });
        }));
  }
}

class NewWidget extends StatelessWidget {
  final Utilisateur user;
  final String element;
  NewWidget({super.key, required this.element, required this.user});

  var present = Rx<bool?>(null);
  @override
  Widget build(BuildContext context) {
    presence();
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          EText(element),
          Obx(
            () => present.value == null
                ? ECircularProgressIndicator()
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

  presence() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.presence)
        .doc(element)
        .collection(Collections.presence)
        .doc(user.telephone_id)
        .get();

    if (q.exists) {
      present.value = true;
    } else {
      present.value = false;
    }
  }
}
