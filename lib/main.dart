import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_view.dart';
import 'package:talib/modules/onboarding.dart';
import 'package:talib/shared/bloc_obsever.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  Widget? widget;

  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  Bloc.observer = MyBlocObserver();
  if (showOnBoard == false)
    // if (token != null) {
    //   widget = ShopLayout();
    // } else {
    widget = HomePage();
  else
    widget = OnBoardingScreen();

  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({
    required this.startWidget
});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: mainColor,
      ),
      home: startWidget,
    );
  }
}
