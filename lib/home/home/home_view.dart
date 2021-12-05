import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) => {},
          builder: (context, state) {
            final cubit = BlocProvider.of<HomeCubit>(context);

            return Scaffold(
              backgroundColor: grey100,
              appBar: AppBar(
                backgroundColor: grey100,
                title: Text(
                  cubit.headlines[cubit.currentIndex],
                  style: TextStyle(color: black),
                ),
                elevation: 0,
                actions: [
                  defaultIconButton(
                      icon: Iconly_Broken.Setting, function: () {}),
                  defaultIconButton(
                      icon: Iconly_Broken.Info_Circle, function: () {})
                ],
              ),
              body: PageView(
                physics: BouncingScrollPhysics(),
                controller: cubit.pageController,
                children: cubit.navItem,
                onPageChanged: (index) {
                  cubit.changeBottomNav(index);
                },
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Iconly_Broken.Home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Iconly_Broken.Notification),
                        label: 'Notification'),
                    BottomNavigationBarItem(
                        icon: Icon(Iconly_Broken.Chat), label: 'Chat'),
                  ],
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeBottomNav(index);
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget defaultIconButton({required IconData icon, required var function}) {
    return IconButton(
        onPressed: function,
        icon: Icon(
          icon,
          color: black,
        ));
  }
}
