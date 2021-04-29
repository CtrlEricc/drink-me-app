import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoricScreen extends StatefulWidget {
  @override
  _HistoricScreenState createState() => _HistoricScreenState();
}

class _HistoricScreenState extends State<HistoricScreen> {
  var list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<DailyDatabase>(
        child: Center(
            child: Text('Você ainda não tem histórico',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17))),
        builder: (ctx, dailyDatabase, ch) => dailyDatabase.itemsCount == 0
            ? ch
            : ListView.builder(
                itemCount: dailyDatabase.itemsCount,
                itemBuilder: (ctx, i) => Container(
                  decoration: BoxDecoration(
                    color: dailyDatabase.itemByIndex(i).goalFinished == true
                        ? kWaterEffect
                        : Colors.white,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text(
                        dailyDatabase.itemByIndex(i).date.substring(0, 2),
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: kPrimaryColor,
                    ),
                    title: Text(
                      'Consumido no dia: ${dailyDatabase.itemByIndex(i).currentLDay.toStringAsFixed(0)} ml',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: dailyDatabase.itemByIndex(i).goalFinished == true
                        ? Text(
                            'Sua meta foi cumprida!',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          )
                        : Text(
                            'Beba mais água ;)',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
