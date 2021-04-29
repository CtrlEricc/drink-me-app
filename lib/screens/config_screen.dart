import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String _url = 'https://www.github.com/CtrlEricc';

  // Foi necessário adicionar queries no manifest para permitir abertura de links no navegador
  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Não foi possível abrir $_url';

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
    TextStyle _textStyle(double size) {
      return TextStyle(color: kPrimaryColor, fontSize: size);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<DailyDatabase>(
        builder: (context, db, child) {
          return Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Alterar meta diária (ml)',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    DropdownButton(
                      hint: Text(
                        '${db.waterLGoal ?? 'Selecione'}',
                        style: TextStyle(
                            color: kPrimaryColor, fontFamily: 'Kollektif'),
                      ),
                      style: _textStyle(18),
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
                                color: kPrimaryColor, fontFamily: 'Kollektif'),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Ativar ou desativar notificações:',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Switch(
                      value: db.notificationActive,
                      onChanged: (value) {
                        print('Switch value: $value');
                        db.setNotification(value);
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Versão 1.0', style: _textStyle(17)),
                    SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Feito com ', style: _textStyle(17)),
                        Image.asset("assets/images/heart.png", width: 20),
                        Text(' e Flutter', style: _textStyle(17)),
                      ],
                    ),
                    SizedBox(height: 7),
                    TextButton.icon(
                      icon: SvgPicture.asset("assets/icons/gitbub_logo.svg",
                          width: 23, color: kPrimaryColor),
                      onPressed: _launchURL,
                      style:
                          TextButton.styleFrom(backgroundColor: kWaterEffect),
                      label: Text('Perfil no GitHub', style: _textStyle(17)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
