
import 'package:immobilier_apk/scr/config/app/export.dart';

class Empty extends StatelessWidget {
  final double? size;
  const Empty({super.key, this.size});


  @override
  Widget build(BuildContext context) {
    return Center(
        child: EColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Image(
          image: AssetImage(Assets.image("empty-2.png")),
          width:size?? 120,
          fit: BoxFit.contain,
        ),
       
      ],
    ));
  }
}
