import 'package:talib/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);

          return cubit.users.length >= 0
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              singleUserBuilder(cubit.users[index],context,() {
                                navigateTo(
                                    context,
                                    PersonChatScreen(
                                      cubit.users[index],
                                    ));
                              },),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: cubit.users.length),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: Colors.green,
                ));
        },
        listener: (context, state) {});
  }
}
