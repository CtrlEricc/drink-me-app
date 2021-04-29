import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  final String mlString;
  final double mlValue;
  final Widget icon;

  AddButton({this.mlString, this.mlValue, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: () {
            Provider.of<DailyDatabase>(context, listen: false)
                .buttonPress(mlValue);
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon,
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                mlString,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
