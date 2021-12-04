import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/modules/chat.dart';
import 'package:talib/modules/feeds.dart';
import 'package:talib/modules/notifications.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> navItem = [Feeds(), NotificationsScreen(), ChatScreen()];
  PageController pageController=PageController();
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(changeBottomNavState());
  }
}
