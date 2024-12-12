import 'package:fl_chart/fl_chart.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class BarCharte extends StatelessWidget {
  final List<double> points;
  const BarCharte({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData(),
        borderData: borderData,
        barGroups: barGroups(points),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 15,
      ),
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            "${(rod.toY * 10).round()}%",
            TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.sevenSegment
            ),
          );
        },
      ),
    );

Widget getTitles(double value, TitleMeta meta) {

  String text;
  switch (value.toInt()) {
    case 0:
      text = '1';
      break;
    case 1:
      text = '2';
      break;
    case 2:
      text = '3';
      break;
    case 3:
      text = '4';
      break;
    case 4:
      text = '5';
      break;
    case 5:
      text = '6';
      break;
    case 6:
      text = '7';
      break;
    case 7:
      text = '8';
      break;
    case 8:
      text = '9';
      break;
    case 9:
      text = '10';
      break;
   
      
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: TextStyle(fontFamily: Fonts.poppins, color: Colors.white)),
  );
}

FlTitlesData titlesData() {
  return FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );
}

FlBorderData get borderData => FlBorderData(
      show: false,
    );

LinearGradient get _barsGradient => LinearGradient(
      colors: [
        Colors.pink,
        Colors.amber,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

List<BarChartGroupData> barGroups(List<double> points) {
  var bars = <BarChartGroupData>[];
  for (var i = 0; i < points.length; i++) {
    bars.add(BarChartGroupData(
    
      x: i,
      barRods: [
        BarChartRodData(
          width: 12,
          toY: points[i],
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ));
  }
  return bars;
}
