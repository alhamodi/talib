import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/iconly-broken_icons.dart';
import 'package:talib/modules/chat_screen/friends_screen/friends_screen.dart';
import 'package:talib/modules/chat_screen/recent_messages_screen/recent_messages_screen.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Widget> chatScreens = [
    RecentMessagesScreen(),
    FriendsScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark),
              elevation: 0,
              backgroundColor: Colors.green.withOpacity(0.4),
              backwardsCompatibility: false,
              titleSpacing: 5,
              leading: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, top: 5, bottom: 5, right: 5),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(
                        '${HomeCubit.get(context).model!.profileImage}',
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                'Chats',
                style: TextStyle(
                  color: subColor,
                ),
              ),
            ),
            body: chatScreens[currentIndex],
            bottomNavigationBar: CurvedNavigationBar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                Icon(Iconly_Broken.Message),
                Icon(Iconly_Broken.User),
              ],
              height: 60,
              color: Colors.green.withOpacity(0.3),
              backgroundColor: Colors.white,
            ),
          );
        },
        listener: (context, state) {});
  }
}
