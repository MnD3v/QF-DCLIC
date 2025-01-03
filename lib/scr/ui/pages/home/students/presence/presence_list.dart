import 'package:csv/csv.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/others/db.dart';
import 'package:my_widgets/widgets/scaffold.dart';
import 'package:universal_html/html.dart';

class PresenceList extends StatelessWidget {
  final Formateur user;
  final String date;
  PresenceList({super.key, required this.user, required this.date});
  var presenceList;

  var downloadLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return EScaffold(
        appBar: AppBar(
          title: EText(
            date,
            size: 24,
            weight: FontWeight.bold,
          ),
          actions: [
            Obx(
              () => downloadLoading.value
                  ? SizedBox(
                      height: 25,
                      width: 25,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => CircularProgressIndicator(
                              color: Colors.pinkAccent,
                              backgroundColor: Colors.white30,
                              strokeWidth: 2.2,
                              // value: effectue.value,
                            ),
                          ),
                          Icon(
                            Icons.download_rounded,
                            color: Colors.pinkAccent,
                            size: 18,
                          )
                        ],
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        save();
                      },
                      icon: Icon(Icons.download_rounded)),
            ),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width / 250;
          return FutureBuilder(
              future: presenceList != null ? null : presenceVerification(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }

                return presenceList.isEmpty
                    ? Empty(constraints: constraints)
                    : DynamicHeightGridView(
                        key: Key(presenceList.length.toString()),
                        physics: BouncingScrollPhysics(),
                        itemCount: presenceList.length,
                        crossAxisCount: crossAxisCount.toInt() <= 0
                            ? 1
                            : crossAxisCount.toInt(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        builder: (ctx, index) {
                          var presence = presenceList[index];
                          return UserPresenceCard(
                            present: presence["present"],
                            user: presence["etudiant"],
                          );
                        });
              });
        }));
  }

  save() {
    List<List<dynamic>> rows = [
      [
        "Matricule",
        "Nom complet",
        "Module",
        "Statut",
      ], // En-tête
      for (var presence in presenceList)
        [
          "001", // Ajout de guillemets pour les champs texte
          "${presence["etudiant"].nom} ${presence["etudiant"].prenom}",
          "${presence["etudiant"].formation}",
          presence["present"] ? "Present" : "Absent",
        ]
    ];

    // Convertit les lignes en contenu CSV
    String csvContent = const ListToCsvConverter().convert(rows);

    // Encode en UTF-8 pour obtenir des octets
    final bytes = utf8.encode(csvContent);

    // Crée un blob avec les octets
    final blob = Blob([bytes], 'text/csv;charset=utf-8');
    final url = Url.createObjectUrlFromBlob(blob);

    // Crée un lien de téléchargement
    final anchor = AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'etudiants_${DateTime.now()}.csv'
      ..click();

    // Nettoie l'URL après le téléchargement
    Url.revokeObjectUrl(url);
  }

  presenceVerification() async {
    presenceList = [];
    var qEtudiants = user.admin
        ? await DB.firestore(Collections.utilistateurs).get()
        : await DB
            .firestore(Collections.utilistateurs)
            .where("classe", isEqualTo: user.classe)
            .get();
    var qEtudiantsPresents = user.admin
        ? await DB
            .firestore(Collections.presence)
            .doc(date)
            .collection(Collections.etudiants)
            .get()
        : await DB
            .firestore(Collections.presence)
            .doc(date)
            .collection(Collections.etudiants)
            .where("classe", isEqualTo: user.classe)
            .get();
    print(qEtudiantsPresents.docs.length);

    var presentsID = [];

    for (var element in qEtudiantsPresents.docs) {
      presentsID.add(element.id);
    }
    print("^pr");

    print(presentsID);

    var etudiants = [];

    for (var element in qEtudiants.docs) {
      var etudiant = Utilisateur.fromMap(element.data());
      etudiants.add(etudiant);
      if (presentsID.contains(etudiant.telephone_id)) {
        presenceList.add({"present": true, "etudiant": etudiant});
      } else {
        presenceList.add({"present": false, "etudiant": etudiant});
      }
    }
    print(presenceList);
  }
}

class UserPresenceCard extends StatelessWidget {
  final Utilisateur user;
  bool present;

  UserPresenceCard({super.key, required this.user, required this.present});

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
          EText("${user.nom} ${user.prenom}"),
          EText(user.telephone_id),
          present == true
              ? EText(
                  "Présent",
                  color: Colors.greenAccent,
                  weight: FontWeight.bold,
                )
              : EText(
                  "Absent",
                  color: Colors.red,
                  weight: FontWeight.bold,
                )
        ],
      ),
    );
  }
}
