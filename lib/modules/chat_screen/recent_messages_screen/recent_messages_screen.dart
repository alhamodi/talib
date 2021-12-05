import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/components.dart';

class RecentMessagesScreen extends StatefulWidget {
  const RecentMessagesScreen({Key? key}) : super(key: key);

  @override
  _RecentMessagesScreenState createState() => _RecentMessagesScreenState();
}

class _RecentMessagesScreenState extends State<RecentMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return HomeCubit.get(context).recentMessages.length >= 0
              ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 130,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            onlinePersonBuilder(
                                HomeCubit.get(context).users[index],
                                context),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 0,
                        ),
                        itemCount: HomeCubit.get(context).users.length),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => personMessage(HomeCubit.get(context).recentMessages[index],context,index),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 7,
                      ),
                      itemCount:
                      HomeCubit.get(context).recentMessages.length),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator(color: Colors.green,));
        },
      );
    });
  }
}
