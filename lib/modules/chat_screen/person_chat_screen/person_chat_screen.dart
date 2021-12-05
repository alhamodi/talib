import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:talib/models/message_model.dart';
import 'package:talib/models/user_model.dart';
// import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/shared/colors.dart';

class PersonChatScreen extends StatelessWidget {
  UserModel? user;

  PersonChatScreen(this.user);

  var messageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // HomeCubit cubit = HomeCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: Colors.green.withOpacity(0.4),
        titleSpacing: 5,
        leading: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(
                  '${user!.profileImage}',
                ),
              ),
            ),
          ],
        ),
        title: Text(
          '${user!.name}',
          style: TextStyle(
            color: subColor,
          ),
        ),
      ),
    );
  }

  Widget buildFriendMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.only(right: 40, left: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${message.text}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMyMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 40, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.3),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${message.text}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
