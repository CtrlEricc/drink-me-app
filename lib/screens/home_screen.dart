import 'package:drink_me/utils/colors.dart';
import 'package:drink_me/utils/size_config.dart';
import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/widgets/add_button.dart';
import 'package:drink_me/widgets/big_add_button.dart';
import 'package:drink_me/widgets/water_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<DailyDatabase>(context, listen: false).loadDailyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailyDatabase>(context);

    int waterLGoal = 0;
    double waterLCurrent;
    double percentConvertValue = 0.0;

    setState(() {
      waterLGoal = provider.waterLGoal;
      waterLCurrent = provider.waterLCurrent;
      percentConvertValue = provider.percentConvertValue;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          WaterEffect(),
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: CircularPercentIndicator(
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 500,
                      radius: 260,
                      lineWidth: 22,
                      linearGradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[kTertiaryColor, kPrimaryColor]),
                      backgroundColor: kQuaternaryColor,
                      percent: provider.goalFinished == true
                          ? 1.0
                          : percentConvertValue,
                      center: Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${waterLCurrent.toStringAsFixed(0)} ml',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'ingeridos de',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  '$waterLGoal ml',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AddButton(
                              mlString: '180 ml',
                              mlValue: 180,
                              icon: SvgPicture.asset(
                                  'assets/icons/glass_icon.svg',
                                  width: 23)),
                          AddButton(
                              mlString: '250 ml',
                              mlValue: 250,
                              icon: SvgPicture.asset(
                                  'assets/icons/glass_icon.svg',
                                  width: 23)),
                          AddButton(
                              mlString: '300 ml',
                              mlValue: 300,
                              icon: SvgPicture.asset(
                                  'assets/icons/glass_icon.svg',
                                  width: 23)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AddButton(
                              mlString: '400 ml',
                              mlValue: 400,
                              icon: SvgPicture.asset(
                                  'assets/icons/bottle_icon.svg',
                                  width: 30)),
                          AddButton(
                              mlString: '500 ml',
                              mlValue: 500,
                              icon: SvgPicture.asset(
                                  'assets/icons/bottle_icon.svg',
                                  width: 30)),
                          AddButton(
                              mlString: '600 ml',
                              mlValue: 600,
                              icon: SvgPicture.asset(
                                  'assets/icons/bottle_icon.svg',
                                  width: 30)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigAddButton(),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
