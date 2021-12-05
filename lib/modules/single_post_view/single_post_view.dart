import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/models/post_model.dart';
import 'package:talib/modules/comments_screen/comments_screen.dart';
import 'package:talib/modules/image_view_screen/image_view_screen.dart';
import 'package:talib/modules/person_profile/person_profile.dart';
import 'package:talib/modules/profile/profile.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class SinglePostViewScreen extends StatefulWidget {
  final String? postUid;
  const SinglePostViewScreen({Key? key, this.postUid}) : super(key: key);

  @override
  _SinglePostViewScreenState createState() =>
      _SinglePostViewScreenState(postUid!);
}

class _SinglePostViewScreenState extends State<SinglePostViewScreen> {
  final String? postUid;

  _SinglePostViewScreenState(this.postUid);
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
              title: Text(
                'Posts',
                style: TextStyle(color: subColor),
              ),
            ),
            body: Builder(
              builder: (context) {
                return HomeCubit.get(context).singlePost != null
                    ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                        child: singlePost(
                            HomeCubit.get(context).singlePost!, context))
                    : Center(
                        child: CircularProgressIndicator(
                        color: Colors.green,
                      ));
              },
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget singlePost(
    PostModel post,
    context,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 5, right: 5),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                if (post.uid == uid) {
                  navigateTo(context, ProfileScreen());
                } else {
                  HomeCubit.get(context)
                      .getAllPersonUsers(personUid: post.uid);
                  HomeCubit.get(context)
                      .getAnotherPersonData(personUid: post.uid);
                  HomeCubit.get(context).getPersonPosts(personUid: post.uid);
                  navigateTo(
                      context,
                      PersonProfileScreen(
                        personUid: post.uid,
                      ));
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      '${post.profileImage}',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.name}',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: subColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${post.datetime}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          if (post.body != '')
            Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, bottom: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.body}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.5),
                    ),
                    // Wrap(
                    //   // alignment: WrapAlignment.start,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#fashion',
                    //           style: TextStyle(color: Colors.green),
                    //         )),
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#girls',
                    //           style: TextStyle(color: Colors.green),
                    //         )),
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#cofee',
                    //           style: TextStyle(color: Colors.green),
                    //         )),
                    //   ],
                    // ),
                  ],
                )),
          if (post.postImage != '')
            InkWell(
              onTap: () {
                navigateTo(
                    context,
                    ImageViewScreen(
                      image: post.postImage,
                      body: post.body,
                    ));
              },
              child: Container(
                height: 300,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Image(
                  image: NetworkImage('${post.postImage}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Iconly_Broken.Heart,
                      color: red,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${HomeCubit.get(context).singlePostLikes}'),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    // Text('${HomeCubit.get(context).commentsNumber[index]} comments'),
                    InkWell(
                        onTap: () {
                          navigateTo(
                              context, CommentsScreen(postUid, post.uid));
                        },
                        child: Text('Comments')),
                  ],
                ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(
              left: 0,
              right: 0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      '${HomeCubit.get(context).model!.profileImage}',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            print('comment');
                            navigateTo(
                                context, CommentsScreen(postUid, post.uid));
                          },
                          child: Text(
                            'comment..',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: subColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Iconly_Broken.Upload)),
                  IconButton(
                      onPressed: () {
                        if (HomeCubit.get(context).singlePostIsLikedByMe ==
                            true) {
                          HomeCubit.get(context).disLikePost(postUid!);
                          HomeCubit.get(context).singlePostIsLikedByMe =
                              false;
                          HomeCubit.get(context).singlePostLikes--;
                        } else {
                          HomeCubit.get(context).likePost(postUid!);
                          HomeCubit.get(context).singlePostIsLikedByMe = true;
                          HomeCubit.get(context).singlePostLikes++;
                          //send notification to post owner with your like
                          HomeCubit.get(context).sendNotifications(
                              action: 'LIKE',
                              targetPostUid: postUid,
                              receiverUid: post.uid,
                              dateTime: DateTime.now().toString());
                        }
                      },
                      icon: Icon(
                        Iconly_Broken.Heart,
                        color: HomeCubit.get(context).singlePostIsLikedByMe ==
                                true
                            ? Colors.red
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
