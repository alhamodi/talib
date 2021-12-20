import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:talib/modules/chat_screen/recent_messages_screen/recent_messages_screen.dart';
import 'package:talib/modules/new_post_screen/new_post_screen.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  var refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);

          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) => cubit.posts.length >= 0&&cubit.model!=null,
            widgetBuilder: (BuildContext context) => Scaffold(
              backgroundColor: grey100,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    cacheImage(
                      url:
                          "https://image.freepik.com/free-vector/group-young-children-cartoon-character-white-background_1308-51457.jpg",
                      height: 150,
                      width: double.infinity,
                    ),
                // RecentMessagesScreen(),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => singlePostBuilder(
                            cubit.posts[index], context, index, false),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: cubit.posts.length),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              floatingActionButton: addPost(context)
            ),
            fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(
              color: mainColor,
            )),
          );
        });
  }


}
