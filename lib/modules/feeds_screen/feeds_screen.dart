import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talib/modules/new_post_screen/new_post_screen.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';

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
            conditionBuilder: (BuildContext context) =>
                cubit.posts.length >= 0 == true,
            widgetBuilder: (BuildContext context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(children: [
                      cacheImage(
                        url:
                        "https://image.freepik.com/free-photo/young-man-using-his-phone-by-purple-glitter-wall_53876-98101.jpg",
                        height: 150,
                        width: double.infinity,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Communicate With Friends',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),
                  ),

                  Card(
                    color: subColor,
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              cacheImage(
                                url:'${cubit.model!.profileImage}',
                                  width: 50,
                                  height: 50,
                                  shape: BoxShape.circle),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(context, NewPostScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1.1)
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Share your creativity ...',
                                        style: TextStyle(color: Colors.black,fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          singlePostBuilder(cubit.posts[index], context, index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: cubit.posts.length),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(
              color: mainColor,
            )),
          );
        });
  }
}
