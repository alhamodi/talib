import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/models/post_model.dart';
import 'package:talib/modules/comments_screen/comments_screen.dart';
import 'package:talib/modules/image_view_screen/image_view_screen.dart';
import 'package:talib/modules/new_post_screen/new_post_screen.dart';
import 'package:talib/modules/person_profile/person_profile.dart';
import 'package:talib/modules/profile/profile.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talib/models/recent_messages_model.dart';
import 'package:talib/models/user_model.dart';
import 'package:talib/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:talib/modules/login_screen/login_screen.dart';

import 'colors.dart';

navigateAndReplacement(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigateTo(BuildContext context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

String? uid;

Widget defaultButton({
  double width = double.infinity,
  Color? color,
  double? fontSize = 17,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: MaterialButton(
          color: color ?? mainColor,
          onPressed: () {
            function();
          },
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

Widget defaultTextField({
  required TextEditingController controller,
  bool isPassword = false,
  required TextInputType type,
  Function? onSubmit,
  double horizontalPadding = 0,
  double verticalPadding = 0,
  required String text,
  required IconData prefix,
  IconData? suffix,
  Function? suffixFunction,
  String textForUnValid = 'this element is required',
  //required Function validate,
}) =>
    Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      height: 80,
      decoration: BoxDecoration(),
      child: TextFormField(
        enableSuggestions: true,
        autocorrect: true,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return textForUnValid;
          }
          return null;
        },
        onChanged: (value) {},
        onFieldSubmitted: (value) {
          onSubmit!(value);
        },
        obscureText: isPassword ? true : false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            labelText: text,
            prefixIcon: Icon(prefix),
            suffixIcon: IconButton(
              onPressed: () {
                suffixFunction!();
              },
              icon: Icon(suffix),
            ),
            border: OutlineInputBorder()),
      ),
    );

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

void showToast({
  required String? msg,
  required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: chooseToastColor(state),
      fontSize: 14.0);
}

enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = mainColor;
      break;

    case ToastState.ERROR:
      color = red;
      break;

    case ToastState.WARNING:
      color = Colors.orange;
      break;
  }
  return color;
}

void logOut(context) {
  CacheHelper.removeData('uid');
  HomeCubit.get(context).model = null;
  uid = '';
  HomeCubit.get(context).users = [];
  HomeCubit.get(context).myNotifications = [];
  HomeCubit.get(context).recentMessages = [];

  navigateAndFinish(context, LoginScreen());
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

// post builder
Widget singlePostBuilder(
    PostModel post, BuildContext context, int index, bool? myPost) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (post.uid == uid) {
              navigateTo(context, ProfileScreen());
            } else {
              HomeCubit.get(context).getAllPersonUsers(personUid: post.uid);
              HomeCubit.get(context).getAnotherPersonData(personUid: post.uid);
              HomeCubit.get(context).getPersonPosts(personUid: post.uid);
              navigateTo(
                  context,
                  PersonProfileScreen(
                    personUid: post.uid,
                  ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cacheImage(
                    url: '${post.profileImage}',
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle),
                SizedBox(
                  width: 10,
                ),
                Column(
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
                          color: mainColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${post.datetime!.substring(0, 16)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 9,
                          color: mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                myPost == true
                    ? Spacer()
                    : SizedBox(
                        height: 0,
                      ),
                myPost == true
                    ? defaultIconButton(
                        icon: Iconly_Broken.Delete,
                        function: () {
                          HomeCubit.get(context).deletePost(
                              HomeCubit.get(context).myPostsId[index]);
                        })
                    : SizedBox(
                        height: 0,
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
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${post.body}',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                  ),
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
              child: cacheImage(
                  url: '${post.postImage}',
                  width: double.infinity,
                  height: 200,
                  shape: BoxShape.rectangle),
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
                  Text('${HomeCubit.get(context).likes[index]}'),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  navigateTo(
                      context,
                      CommentsScreen(
                          HomeCubit.get(context).postsId[index], post.uid));
                },
                child: Row(
                  children: [
                    Icon(
                      Iconly_Broken.Chat,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${HomeCubit.get(context).commentsNumber[index]}'),
                  ],
                ),
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
                cacheImage(
                    url: '${HomeCubit.get(context).model!.profileImage}',
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle),
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
                              context,
                              CommentsScreen(
                                  HomeCubit.get(context).postsId[index],
                                  post.uid));
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
                      if (HomeCubit.get(context).likedByMe[index] == true) {
                        HomeCubit.get(context)
                            .disLikePost(HomeCubit.get(context).postsId[index]);
                        HomeCubit.get(context).likedByMe[index] = false;
                        HomeCubit.get(context).likes[index]--;
                      } else {
                        HomeCubit.get(context)
                            .likePost(HomeCubit.get(context).postsId[index]);
                        HomeCubit.get(context).likedByMe[index] = true;
                        HomeCubit.get(context).likes[index]++;
                        //send notification to post owner with your like
                        HomeCubit.get(context).sendNotifications(
                            action: 'LIKE',
                            targetPostUid:
                                HomeCubit.get(context).postsId[index],
                            receiverUid: post.uid,
                            dateTime: DateTime.now().toString());
                      }
                    },
                    icon: Icon(
                      Iconly_Broken.Heart,
                      color: HomeCubit.get(context).likedByMe[index] == true
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

// my post builder
Widget singleMyPostBuilder(PostModel post, context, index) {
  return Dismissible(
    direction: DismissDirection.startToEnd,
    background: Container(
      color: red.withOpacity(0.5),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete_outline_outlined,
          color: Colors.white,
        ),
      ),
    ),
    key: ObjectKey(index),
    onDismissed: (direction) {
      HomeCubit.get(context)
          .deletePost(HomeCubit.get(context).myPostsId[index]);
    },
    child: Card(
      color: subColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 5, right: 5),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cacheImage(
                    url: '${post.profileImage}',
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle),
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
                            color: mainColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${post.datetime!.substring(0, 16)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 9,
                            color: mainColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  ],
                )),
          if (post.postImage != '')
            InkWell(
              onTap: () {
                navigateTo(context,
                    ImageViewScreen(image: post.postImage, body: post.body));
              },
              child: Container(
                height: 300,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: cacheImage(
                  url: '${post.postImage}',
                  height: 220,
                  width: double.infinity,
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
                    Text('${HomeCubit.get(context).myLikes[index]}'),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              CommentsScreen(
                                  HomeCubit.get(context).myPostsId[index],
                                  post.uid));
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
                  cacheImage(
                      url: "${HomeCubit.get(context).model!.profileImage}",
                      width: 30,
                      height: 30,
                      shape: BoxShape.circle),
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
                                context,
                                CommentsScreen(
                                    HomeCubit.get(context).myPostsId[index],
                                    post.uid));
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
                  IconButton(
                      onPressed: () {}, icon: Icon(Iconly_Broken.Upload)),
                  IconButton(
                      onPressed: () {
                        if (HomeCubit.get(context).myLikedByMe[index] == true) {
                          HomeCubit.get(context).disLikePost(
                              HomeCubit.get(context).myPostsId[index]);
                          HomeCubit.get(context).myLikedByMe[index] = false;
                          HomeCubit.get(context).myLikes[index]--;
                        } else {
                          HomeCubit.get(context).likePost(
                              HomeCubit.get(context).myPostsId[index]);
                          HomeCubit.get(context).myLikedByMe[index] = true;
                          HomeCubit.get(context).myLikes[index]++;
                        }
                      },
                      icon: Icon(
                        Iconly_Broken.Heart,
                        color: HomeCubit.get(context).myLikedByMe[index] == true
                            ? Colors.red
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// person post
Widget singlePersonPostBuilder(PostModel post, context, index) {
  return Card(
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.only(left: 5, right: 5),
    elevation: 10,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
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
                      '${post.datetime!.substring(0, 16)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 9,
                          color: mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.body}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                ),
                // Wrap(
                //   // alignment: WrapAlignment.start,
                //   children: [
                //     TextButton(
                //         onPressed: () {},
                //         child: Text(
                //           '#fashion',
                //           style: TextStyle(color: mainColor),
                //         )),
                //     TextButton(
                //         onPressed: () {},
                //         child: Text(
                //           '#girls',
                //           style: TextStyle(color: mainColor),
                //         )),
                //     TextButton(
                //         onPressed: () {},
                //         child: Text(
                //           '#cofee',
                //           style: TextStyle(color: mainColor),
                //         )),
                //   ],
                // ),
              ],
            )),
        if (post.postImage != '')
          InkWell(
            onTap: () {
              navigateTo(context,
                  ImageViewScreen(image: post.postImage, body: post.body));
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
                  Text('${HomeCubit.get(context).personLikes[index]}'),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            CommentsScreen(
                                HomeCubit.get(context).personPostsId[index],
                                HomeCubit.get(context).personModel!.uid));
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
                              context,
                              CommentsScreen(
                                  HomeCubit.get(context).personPostsId[index],
                                  HomeCubit.get(context).personModel!.uid));
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
                      if (HomeCubit.get(context).personIsLikedByMe[index] ==
                          true) {
                        HomeCubit.get(context).disLikePost(
                            HomeCubit.get(context).personPostsId[index]);
                        HomeCubit.get(context).personIsLikedByMe[index] = false;
                        HomeCubit.get(context).personLikes[index]--;
                      } else {
                        HomeCubit.get(context).likePost(
                            HomeCubit.get(context).personPostsId[index]);
                        HomeCubit.get(context).personIsLikedByMe[index] = true;
                        HomeCubit.get(context).personLikes[index]++;
                      }
                    },
                    icon: Icon(
                      Iconly_Broken.Heart,
                      color: HomeCubit.get(context).personIsLikedByMe[index] ==
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

//replace every single follower by single user for inkwell is ready there
Widget singleFollowerBuilder(UserModel user, context) => Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cacheImage(
            url: '${user.profileImage}',
            width: 50,
            height: 50,
            shape: BoxShape.circle,
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
                  '${user.name}',
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 17,
                      color: mainColor,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '${HomeCubit.get(context).users.length - 1} mutual friends',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 9,
                      color: mainColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Icon(
            Iconly_Broken.Chat,
            color: mainColor,
          )
        ],
      ),
    );

Widget singleUserBuilder(
        UserModel user, BuildContext context, void Function()? onPressed) =>
    Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  if (user.uid == uid) {
                    navigateTo(context, ProfileScreen());
                  } else {
                    HomeCubit.get(context)
                        .getAllPersonUsers(personUid: user.uid);
                    HomeCubit.get(context)
                        .getAnotherPersonData(personUid: user.uid);
                    HomeCubit.get(context).getPersonPosts(personUid: user.uid);
                    navigateTo(
                        context,
                        PersonProfileScreen(
                          personUid: user.uid,
                        ));
                  }
                },
                child: cacheImage(
                    url: '${user.profileImage}',
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle)),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${HomeCubit.get(context).users.length - 1} mutual friends',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 9,
                        color: mainColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Iconly_Broken.Send,
                  color: mainColor,
                ))
          ],
        ),
      ),
    );

Widget onlinePersonBuilder(UserModel user, context) {
  return InkWell(
    onTap: () {
      navigateTo(context, PersonChatScreen(user));
    },
    child: Container(
      width: 80,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  '${user.profileImage}',
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 9,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: mainColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            '${user.name}',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: subColor,
                height: 1.2),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

Widget personMessage(
  RecentMessageModel r,
  context,
  index,
) {
  return Dismissible(
    background: Container(
      color: mainColor.withOpacity(0.5),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Icon(
          Icons.archive,
          color: Colors.white,
        ),
      ),
    ),
    secondaryBackground: Container(
      color: red.withOpacity(0.5),
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Icon(
          Icons.delete_outline_outlined,
          color: Colors.white,
        ),
      ),
    ),
    key: ObjectKey(index),
    onDismissed: (direction) {
      switch (direction) {
        case DismissDirection.startToEnd:
          break;
        case DismissDirection.endToStart:
          HomeCubit.get(context)
              .deleteChat(r.receiverId == uid ? r.senderId : r.receiverId);
          break;
      }
    },
    child: InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection('users')
            .doc(r.receiverId == uid ? r.senderId : r.receiverId)
            .get()
            .then((value) {
          HomeCubit.get(context).userForRecentMessage =
              UserModel.fromJson(value.data());
        }).then((value) {
          navigateTo(context,
              PersonChatScreen(HomeCubit.get(context).userForRecentMessage));
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                '${r.receiverId == uid ? r.senderProfilePic : r.receiverProfilePic}',
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
                    '${r.receiverId == uid ? r.senderName : r.receiverName}',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: subColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          '${r.receiverId == uid ? r.lastMessage : r.lastMessage}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: r.receiverId == uid
                                  ? mainColor
                                  : Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${r.dateTimeOfLastMessage!.substring(11, 16)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 9,
                                color: subColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget cacheImage({
  required String url,
  required double width,
  required double height,
  BoxShape shape = BoxShape.rectangle,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget defaultIconButton(
    {required IconData icon, required var function, color}) {
  return IconButton(
      onPressed: function,
      icon: Icon(
        icon,
        color: color == null ? Colors.black : color,
      ));
}

FloatingActionButton addPost(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      navigateTo(context, NewPostScreen());
    },
    child: Icon(Iconly_Broken.Edit),
  );
}

Widget singlePhotoBuilder(String image, String body, context) {
  return InkWell(
    onTap: () {
      navigateTo(context, ImageViewScreen(image: image, body: body));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('$image'),
        ),
      ),
      width: 70,
      height: 70,
    ),
  );
}

Widget followersBuilder(context) {
  return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => singleUserBuilder(
            HomeCubit.get(context).users[index],
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
            height: 10,
          ),
      itemCount: HomeCubit.get(context).users.length);
}
