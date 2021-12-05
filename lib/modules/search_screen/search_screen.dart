import 'package:talib/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/models/user_model.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // This list holds the data for the list view
  List<UserModel> foundUsers = [];

  @override
  initState() {
    // at the beginning, all users are shown
    foundUsers = HomeCubit.get(context).users;
    super.initState();
  }

  // This function is called whenever the text field changes
  void runFilter(String enteredKeyword) {
    List<UserModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = HomeCubit.get(context).users;
    } else {
      results = HomeCubit.get(context)
          .users
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

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
              leading: IconButton(
                icon: Icon(
                  Iconly_Broken.Arrow___Left_2,
                  color: subColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: TextFormField(
                maxLines: 1,
                autofocus: true,
                keyboardType: TextInputType.text,
                enableInteractiveSelection: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                enableSuggestions: true,
                scrollPhysics: BouncingScrollPhysics(),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
                autocorrect: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The search can\'t be empty';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {},
                onChanged: (value) {
                  runFilter(value);
                },
              ),
            ),
            body: foundUsers.length > 0
                ? ListView.separated(
                    itemBuilder: (context, index) => singleUserBuilder(
                          foundUsers[index],
                          context,
                          () {
                            navigateTo(
                                context,
                                PersonChatScreen(
                                  HomeCubit.get(context).users[index],
                                ));
                          },
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 0,
                        ),
                    itemCount: foundUsers.length)
                : Center(child: Text('No result is found!')),
          );
        },
        listener: (context, state) {});
  }
}
