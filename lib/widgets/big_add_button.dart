import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BigAddButton extends StatefulWidget {
  final Function(double) pressButton;

  BigAddButton({this.pressButton});

  @override
  _BigAddButtonState createState() => _BigAddButtonState();
}

class _BigAddButtonState extends State<BigAddButton> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailyDatabase>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 220,
        height: 60,
        child: TextButton(
          onPressed: () => Alert(
              context: context,
              title: "Inserir quantidade",
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_drink_rounded),
                      labelText: 'Insira aqui (ml)',
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  color: kPrimaryColor,
                  onPressed: () {
                    provider.buttonPress(double.parse(_controller.text));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show(),
          child: Column(children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              'Adicionar outra quantidade',
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ]),
          style: TextButton.styleFrom(
            backgroundColor: kSecondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
