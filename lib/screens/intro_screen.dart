import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/utils/app_routes.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:drink_me/widgets/water_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String _dropdownValue;

  final List listItem = [
    '1000',
    '1250',
    '1500',
    '1750',
    '2000',
    '2250',
    '2500',
    '2750',
    '3000',
    '3250',
    '3500',
    '3750',
    '4000',
    '4250',
    '4500',
    '4750',
    '5000',
    '5250',
    '5500',
    '5750',
    '6000',
  ];

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width * 0.024;
    double defaultHeight = MediaQuery.of(context).size.height * 0.024;

    TextStyle _textStyle(double size) {
      return TextStyle(color: kPrimaryColor, fontSize: size);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("assets/images/logo_white.png",
            width: defaultWidth * 15),
        backgroundColor: kPrimaryColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor,
                    kQuaternaryColor,
                  ],
                ),
              ),
            ),
          ),
          WaterEffect(),
          Consumer<DailyDatabase>(
            builder: (context, db, child) {
              return Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: defaultHeight * 0.4),
                        Text(
                          'Hidrate-se bem e viva melhor!',
                          style: TextStyle(
                              color: kWaterEffect,
                              fontSize: defaultWidth * 3,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: defaultHeight * 0.5),
                        Text(
                          'O recomendado é ingerir pelo menos 2 litros de água por dia. Se você pratica algum exercício físico regularmente, ingira de 3 a 4 litros por dia.*',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: defaultWidth * 2.2),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Selecione sua meta diária (ml)',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: defaultWidth * 2.2,
                          ),
                        ),
                        DropdownButton(
                          hint: Text(
                            '${db.waterLGoal ?? 'Selecione'}',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: defaultWidth * 2.2,
                                fontFamily: 'Kollektif'),
                          ),
                          style: _textStyle(
                            defaultWidth * 2.2,
                          ),
                          value: _dropdownValue,
                          onChanged: (newValue) async {
                            setState(() {
                              _dropdownValue = newValue;
                            });
                            print(_dropdownValue);
                            db.setWaterGoal(_dropdownValue);
                            db.percentConvertValue = 0;
                            db.loadDailyData();
                          },
                          items: listItem.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(
                                valueItem,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: defaultWidth * 2.2,
                                    fontFamily: 'Kollektif'),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: defaultHeight * 1.5),
                        Text(
                          'Toque para ativar as notificações',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: defaultWidth * 2.2,
                          ),
                        ),
                        Switch(
                          value: db.notificationActive,
                          onChanged: (value) {
                            print('Switch value: $value');
                            db.setNotification(value);
                          },
                        ),
                        SizedBox(height: defaultHeight * 1.75),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: kTertiaryColor),
                          onPressed: _dropdownValue == null
                              ? null
                              : () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.ROOT_SCREEN);
                                },
                          icon: Icon(Icons.check, color: kPrimaryColor),
                          label: Text(
                            'OK',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: defaultWidth * 2.2,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '*Fonte: Min. da Saúde',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: defaultWidth * 1.2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
