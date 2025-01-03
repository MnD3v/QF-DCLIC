import 'package:csv/csv.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/others/db.dart';
import 'package:my_widgets/widgets/scaffold.dart';
import 'package:universal_html/html.dart';

class PresenceList extends StatefulWidget {
  final Formateur user;
  final String date;
  PresenceList({super.key, required this.user, required this.date});

  @override
  State<PresenceList> createState() => _PresenceListState();
}

class _PresenceListState extends State<PresenceList> {
  var presenceList;

  var downloadLoading = false.obs;

  var classes = <String>[];

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      body: FutureBuilder(
          future:  presenceVerification(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot)) {
              return ECircularProgressIndicator();
            }
            return EScaffold(
                appBar: AppBar(
                  title: EText(
                    GFunctions.isToday(widget.date)
                        ? "Aujourd'hui"
                        : GFunctions.isYesterday(widget.date)
                            ? "Hier"
                            : widget.date.split("-").reversed.join('-'),
                    weight: FontWeight.bold,
                    size: 24,
                  ),
                  actions:!widget.user.admin
                        ? []
                        : [
                          IconButton(onPressed: (){
                            setState(() {
                              
                            });
                          }, icon: Icon(Icons.refresh)),
                          12.w,
                     IconButton(
                            onPressed: () {
                              Custom.showDialog(
                                  dialog: Dialog(
                                child: SizedBox(
                                  width: 330,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: EColumn(children: [
                                      EText(
                                        "Classes Verifiées",
                                        size: 24,
                                        weight: FontWeight.bold,
                                        color: Colors.pinkAccent,
                                      ),
                                      12.h,
                                      classes.isEmpty
                                          ? Empty(
                                              size: 60,
                                            )
                                          : EColumn(
                                              children: classes.map((element) {
                                              return Container(
                                                  padding: EdgeInsets.all(6),
                                                  margin: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: EText(
                                                    element,
                                                    color: Colors.black,
                                                  ));
                                            }).toList())
                                    ]),
                                  ),
                                ),
                              ));
                            },
                            icon: Icon(CupertinoIcons.app_badge)),
                    12.w,
             !kIsWeb? 0.h:       Obx(
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
                    12.w,
                  ],
                ),
                body: LayoutBuilder(builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width / 250;
                  return presenceList.isEmpty
                      ? Empty()
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
                }));
          }),
    );
  }

  save() {
    List<List<dynamic>> rows = [
      [
        "Date",
        "Matricule",
        "Nom complet",
        "Module",
        "Statut",
      ], // En-tête
      for (var presence in presenceList)
        [
          widget.date.split("-").reversed.join('-'),
          presence["etudiant"].classe.toString().substring(0, 2) +
              presence["etudiant"].formation.toString().substring(0, 1) +
              goodRankString(presenceList.indexOf(presence) +
                  1), // Ajout de guillemets pour les champs texte
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
    var qEtudiants = widget.user.admin
        ? await DB.firestore(Collections.utilistateurs).get()
        : await DB
            .firestore(Collections.utilistateurs)
            .where("classe", isEqualTo: widget.user.classe)
            .get();
    var qEtudiantsPresents = widget.user.admin
        ? await DB
            .firestore(Collections.presence)
            .doc(widget.date)
            .collection(Collections.etudiants)
            .get()
        : await DB
            .firestore(Collections.presence)
            .doc(widget.date)
            .collection(Collections.etudiants)
            .where("classe", isEqualTo: widget.user.classe)
            .get();

    var presentsID = [];

    for (var element in qEtudiantsPresents.docs) {
      presentsID.add(element.id);
      if (!classes.contains(element.data()["classe"])) {
        classes.add(element.data()["classe"]);
      }
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
    presenceList.sort((a, b) {
      String fullNameA = "${a["etudiant"].nom} ${a["etudiant"].prenom}";
      String fullNameB = "${b["etudiant"].nom} ${b["etudiant"].prenom}";
      return fullNameA.toLowerCase().compareTo(fullNameB.toLowerCase());
    });
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

goodRankString(int rank) {
  if (rank < 10) {
    return "00$rank";
  } else if (rank < 100) {
    return "0$rank";
  }
  return rank.toString();
}
