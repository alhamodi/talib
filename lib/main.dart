import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_view.dart';
import 'package:talib/modules/login_screen/login_cubit/cubit.dart';
import 'package:talib/modules/login_screen/login_screen.dart';
import 'package:talib/modules/onboarding.dart';
import 'package:talib/modules/register_screen/register_cubit/cubit.dart';
import 'package:talib/shared/bloc_obsever.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();


  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  Bloc.observer = MyBlocObserver();
  uid = CacheHelper.getData( 'uid') != null
      ? CacheHelper.getData( 'uid')
      : null;

  late Widget widget = OnBoardingScreen();
  if (showOnBoard != null) {
    if (uid != null) {
      widget =  HomePage(
        afterLoginOrRegister: false,
      );
    } else {
      widget = LoginScreen();
    }
  } else {
    OnBoardingScreen();
  }


  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  Widget startWidget;

  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(
            create: (context) => HomeCubit()
              ..getUserData()
              ..getPosts()
              ..getMyPosts()
              ..getNotifications()
              ..getRecentMessages()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: mainColor,
        ),
        home: startWidget,
      ),
    );
  }
}
