import 'package:drink_me/models/user_model.dart';
import 'package:drink_me/utils/db_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Para os dados que são adicinados diariamente
class DailyDatabase with ChangeNotifier {
  // Serviço de notificação
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Variáveis de dados atualizveis
  double waterLCurrent = 0;
  double percentConvertValue = 0.0;
  bool goalFinished = false;
  List<DailyData> _storeDataByDate = [];
  List<DailyData> _reversedStoreDataByDate() =>
      _storeDataByDate.reversed.toList();

  // Variáveis de dados constantes
  int waterLGoal;
  bool notificationActive = false;
  bool introFinished = false;

  // Getters
  List<DailyData> get items {
    return [..._storeDataByDate];
  }

  int get itemsCount {
    return _storeDataByDate.length;
  }

  String get dateFormated {
    return '${DateFormat("dd/MM/yyyy").format(DateTime.now())}';
  }

  DailyData itemByIndex(int index) {
    return _reversedStoreDataByDate()[index];
  }

  // Converte para o valor usado no progressindicator
  void converter(double mlValue) {
    double result1 = mlValue * 100;
    print(result1);
    print('water L Goal: $waterLGoal');
    double finalResult = result1 / waterLGoal;
    print('Final result: $finalResult');
    double fnPercentConvertedValue = finalResult < 10
        ? double.parse('0.0${finalResult.toStringAsFixed(0)}')
        : double.parse('0.${finalResult.toStringAsFixed(0)}');
    print(fnPercentConvertedValue);
    percentConvertValue = percentConvertValue + fnPercentConvertedValue;
    notifyListeners();
  }

  // Carrega os dados do BD e adiciona na lista temporária
  Future<void> loadData() async {
    final dataList = await DbUtil.getData('dailydata');
    // O map transforma cada registro em DailyData
    _storeDataByDate = dataList
        .map(
          (item) => DailyData(
            date: item['date'],
            currentLDay: item['currentLDay'],
            goalFinished: item['goalFinished'] == 1 ? true : false,
          ),
        )
        .toList();
    notifyListeners();
  }

  // Encontra na lista apenas o dado correspondente ao dia atual e
  // altera as variáveis
  void loadDailyData() async {
    await loadData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    waterLGoal = int.parse(prefs.getString('waterGoal')) ?? 2000; // --- Mesmo q n haja regs ainda o goal vai ser setado
    notificationActive = prefs.getBool('notificationActive') ?? false;
    initializeNotification(); // --- Inicializa o serviço de notificação
    print('Water l Current: $waterLCurrent');
    print('Water l Goal: $waterLGoal');
    print('Goal Finished: $goalFinished');
    var list = items;
    if (list.length > 0) {
      var dailyData =
          list.where((element) => element.date == dateFormated).toList();
      if (dailyData.length > 0) {
        print(dailyData[0]);
        DailyData item = dailyData[0];
        waterLCurrent = item.currentLDay;
        goalFinished = item.goalFinished;
        converter(waterLCurrent);
      }
    }

    notifyListeners();
  }

  // Adiciona um novo registro na lista temporária e insere um novo registro no BD
  void addData(double currentLDay, bool goalFinshed) {
    final newData = DailyData(
      date: dateFormated,
      currentLDay: currentLDay,
      goalFinished: goalFinshed,
    );

    _storeDataByDate.removeWhere((element) => element.date == newData.date);
    _storeDataByDate.add(newData);

    DbUtil.insert('dailydata', {
      'date': newData.date,
      'currentLDay': newData.currentLDay,
      'goalFinished': newData.goalFinished ? 1 : 0,
    });
    notifyListeners();
  }

  // Função de ação dos botões de inserção de água ao dia atual
  void buttonPress(double mlButtonValue) {
    // Se o dia for diferente, zera o progresso diário
    var list = items;
    var dailyData =
        list.where((element) => element.date == dateFormated).toList();
    if (dailyData.length == 0) {
      waterLCurrent = 0;
      percentConvertValue = 0.0;
      print('Data diferente, progresso zerado!!!!!');
    }

    converter(mlButtonValue);

    waterLCurrent = waterLCurrent + mlButtonValue;

    if (waterLCurrent >= waterLGoal) {
      goalFinished = true;
    }
    if (waterLCurrent < waterLGoal) {
      goalFinished = false;
    }

    // Envia para o provider
    addData(waterLCurrent, goalFinished);
    notifyListeners();
  }

  // Set a meta diária, a conversão em int será feita em loadDailyData
  void setWaterGoal(String goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waterGoal', goal);
    notifyListeners();
  }

  // Marcador para o switch de ativar ou desativar notificações
  Future<void> setNotification(bool notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationActive = notification;
    prefs.setBool('notificationActive', notification);
    // Ativa ou desativa a função de notificação
    if (notification == true) {
      sheduledNotification();
    }
    if (notification == false) {
      cancelNotification();
    }
    print('Async DB call DONE.');
    notifyListeners();
  }

  //Inicialização do serviço de notificação
  Future<void> initializeNotification() async {
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("icon_notification");

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Ativa as notificações a cada minuto
  Future<void> sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;

    var android = AndroidNotificationDetails("id", "channel", "description",
        largeIcon: DrawableResourceAndroidBitmap("icon"));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      "Hora de beber água!",
      "Toque para abrir o aplicativo",
      interval,
      platform,
    );
  }

  // Cancela as notificações
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
