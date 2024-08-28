import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'dbhelper1.dart'; // Import your DbHelper class

void main() {
  runApp(MaterialApp(
    home: HealthProgressPage(),
  ));
}

class HealthProgressPage extends StatefulWidget {
  @override
  _HealthProgressPageState createState() => _HealthProgressPageState();
}

class _HealthProgressPageState extends State<HealthProgressPage> {
  // final DbHelper _dbHelper = DbHelper();
  final List<Map<String, dynamic>> waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"},
  ];

  late DbHelper _dbHelper;
  double _sleepHours = 0;
  int _calories = 0;
  int _remainingCalories=0;
  @override
  void initState() {
    super.initState();
    _dbHelper = DbHelper();
    _fetchData();
  }

  Future<void> _fetchData() async {
    double sleepHours = await _dbHelper.getLatestCalories() ?? 0;
    int calories = await _dbHelper.getLatestSleepHour() ?? 0;
    int remainingCalories = (600 - _calories);

    setState(() {
      _sleepHours = sleepHours;
      _calories = calories;
      _remainingCalories=remainingCalories;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: media.width * 0.05),
                // Water Intake Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ],
                  ),
                  child: Row(
                    children: [
                      // Water Intake Progress Bar
                      SimpleAnimationProgressBar(
                        height: media.width * 0.85,
                        width: media.width * 0.07,
                        backgroundColor: Colors.grey.shade100,
                        foregrondColor: Colors.purple,
                        ratio: 0.5,
                        direction: Axis.vertical,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 3),
                        borderRadius: BorderRadius.circular(15),
                        gradientColor: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water Intake",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTRB(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ));
                              },
                              child: Text(
                                "4 Liters",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Real time updates",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                            // Water Intake History
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: waterArr.map((wObj) {
                                var isLast = wObj == waterArr.last;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: TColor.secondaryColor1.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        if (!isLast)
                                          DottedDashedLine(
                                            height: media.width * 0.078,
                                            width: 0,
                                            dashColor: TColor.secondaryColor1.withOpacity(0.5),
                                            axis: Axis.vertical,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          wObj["title"].toString(),
                                          style: TextStyle(
                                            color: TColor.gray,
                                            fontSize: 10,
                                          ),
                                        ),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                              colors: TColor.secondaryG,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ).createShader(Rect.fromLTRB(
                                              0,
                                              0,
                                              bounds.width,
                                              bounds.height,
                                            ));
                                          },
                                          child: Text(
                                            wObj["subtitle"].toString(),
                                            style: TextStyle(
                                              color: TColor.white.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                // Sleep and Calories Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sleep Section
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: media.width * 0.6,
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sleep",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTRB(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ));
                              },
                              child: Text(
                                "$_sleepHours hours",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              getSleepImage(_sleepHours),
                              width: double.maxFinite,
                              fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: media.width * 0.05),
                    // Calories Section
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: media.width * 0.45,
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Calories",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTRB(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ));
                              },
                              child: Text(
                                "600 kCal",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: media.width * 0.2,
                                height: media.width * 0.2,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: media.width * 0.15,
                                      height: media.width * 0.15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: TColor.primaryG,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          media.width * 0.075,
                                        ),
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          "$_remainingCalories\n kcal left",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SimpleCircularProgressBar(
                                      progressStrokeWidth: 10,
                                      backStrokeWidth: 10,
                                      progressColors: TColor.primaryG,
                                      backColor: Colors.grey.shade100,
                                      valueNotifier: ValueNotifier(50),
                                      startAngle: -180,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getSleepImage(double sleepHours) {
    if (sleepHours > 6) {
      return "assets/31829d1be0a1381998bbbcd5f3beb181_w.jpeg";
    } else {
      return "assets/2272.png";
    }
  }
}

class TColor {
  static const List<Color> primaryG = [
    Color(0xFF16BFFD),
    Color(0xFFCB3066),
  ];
  static const Color black = Color(0xFF2D2D2D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFA5A5A5);
  static const Color secondaryColor1 = Color(0xFF62B8AC);
  static const List<Color> secondaryG = [
    Color(0xFFCB3066),
    Color(0xFF8CDAFF),
  ];
}
