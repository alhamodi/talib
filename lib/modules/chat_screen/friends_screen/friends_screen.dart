import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return cubit.users.length >= 0
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  PersonChatScreen(
                                    cubit.users[index],
                                  ));
                            },
                            child: singleFollowerBuilder(cubit.users[index],context)),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: cubit.users.length),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ));
      },
    );
  }
}
