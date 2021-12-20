import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/modules/profile/profile.dart';
import 'package:talib/modules/search_screen/search_screen.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class HomePage extends StatefulWidget {
  final bool afterLoginOrRegister;

  const HomePage({Key? key, required this.afterLoginOrRegister})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(afterLoginOrRegister);
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final bool afterLoginOrRegister;

  _HomePageState(this.afterLoginOrRegister);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (afterLoginOrRegister == true) {
        HomeCubit.get(context).getUserData();
        HomeCubit.get(context).getPosts();
        HomeCubit.get(context).getMyPosts();
        HomeCubit.get(context).getAllUsers();
        HomeCubit.get(context).getNotifications();
        HomeCubit.get(context).getRecentMessages();
      }
      return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) => {},
          builder: (context, state) {
            final cubit = BlocProvider.of<HomeCubit>(context);

            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu_outlined, size: 25, color: white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                elevation: 0,
                backgroundColor: mainColor,
                actions: [
                  IconButton(
                      onPressed: () {
                        print('search');
                        navigateTo(context, SearchScreen());
                      },
                      icon: Icon(Iconly_Broken.Search, color: white)),
                  IconButton(
                      onPressed: () {
                        print('massenger');
                        // navigateTo(context, FriendsScreen(),);
                      },
                      icon: Icon(Iconly_Broken.Info_Circle, color: white)),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    cubit.headlines[cubit.currentIndex],
                    style: TextStyle(
                        color: white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                titleSpacing: 3,
              ),
              body: PageView(
                physics: BouncingScrollPhysics(),
                controller: cubit.pageController,
                children: cubit.navItem,
                onPageChanged: (index) {
                  cubit.changeBottomNav(index);
                },
              ),
              drawer: Padding(
                padding: const EdgeInsets.only(
                  bottom: 90,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(35)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Drawer(
                    child: cubit.model != null
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                if (true)
                                  DrawerHeader(
                                    curve: Curves.easeInCirc,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            cacheImage(
                                                url:
                                                    '${cubit.model?.profileImage}',
                                                width: 90,
                                                height: 90,
                                                shape: BoxShape.circle),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${cubit.model!.name}',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${cubit.model!.email}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          '${cubit.model!.bio}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ListTile(
                                  title: Text(
                                    'Profile',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    navigateTo(context, ProfileScreen());
                                  },
                                  leading: Icon(Iconly_Broken.Profile),
                                ),
                                ListTile(
                                  title: Text(
                                    'Setting',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {},
                                  leading: Icon(Iconly_Broken.Setting),
                                ),
                                ListTile(
                                  title: Text(
                                    'Log out',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    logOut(context);
                                  },
                                  leading: Icon(Iconly_Broken.Logout),
                                ),
                              ],
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
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
                  cubit.pageController.jumpToPage(index);
                },
              ),
            );
          });
    });
  }
}
