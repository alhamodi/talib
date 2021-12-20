import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talib/modules/edit_profile_screen/edit_profile_screen.dart';
import 'package:talib/modules/image_view_screen/image_view_screen.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // a variable for detect page index to display pages (posts,photos,followers,following)
  int pageIndex = 0;

  // boolean variable for grid and full screen detection
  bool isGrid = false;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 230,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                ImageViewScreen(
                                    image: cubit.model!.coverImage, body: ''));
                          },
                          child: cacheImage(
                              url: '${cubit.model!.coverImage}',
                              width: double.infinity,
                              height: 180),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                ImageViewScreen(
                                    image: cubit.model!.profileImage,
                                    body: ''));
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: cacheImage(
                                    url: '${cubit.model!.profileImage}',
                                    width: 120,
                                    height: 120,shape: BoxShape.circle),
                              ),
                              if (cubit.model!.isEmailVerified == true)
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: mainColor,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                            ],
                          )),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8,top: 10),
                  child: Text(
                    '${cubit.model!.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 21),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15,bottom: 15),
                  child: Text(
                    '${cubit.model!.bio}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: subColor,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

                defaultButton(
                    function: () {
                      navigateTo(
                        context,
                        EditProfileScreen(),
                      );
                    },
                    text: 'Edit your profile',
                    width: MediaQuery.of(context).size.width / 2.2,
                    color: mainColor,
                    fontSize: 14),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                          print('posts');
                        });
                      },
                      child: Container(
                        width: 70,
                        child: Text(
                          '${cubit.myPosts.length}\nPosts',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color:
                                  pageIndex == 0 ? mainColor : Colors.black54),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          pageIndex = 1;

                        });
                      },
                      child: Container(
                        width: 70,
                        child: Text(
                          '${cubit.myImages.length}\nPhotos',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color:
                                  pageIndex == 1 ? mainColor : Colors.black54),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          pageIndex = 2;

                        });
                      },
                      child: Container(
                        width: 70,
                        child: Text(
                          '${cubit.users.length}\nFriends',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color:
                                  pageIndex == 2 ? mainColor : Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                if (pageIndex == 0)
                  cubit.myPosts.length >= 0
                      ? Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => singlePostBuilder(
                                  HomeCubit.get(context).myPosts[index], context, index, true),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemCount: HomeCubit.get(context).myPosts.length),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                          color: mainColor,
                        )),
                if (pageIndex == 1)
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isGrid = !isGrid;
                                  isGrid ? print('grid') : print('list');
                                });
                              },
                              icon: !isGrid
                                  ? Icon(
                                      Icons.grid_view,
                                      color: mainColor,
                                    )
                                  : Icon(
                                      Icons.fullscreen,
                                      size: 32,
                                      color: mainColor,
                                    ),
                            ),
                          ],
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: isGrid ? 2 : 1,
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, right: 0, left: 0),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1 / 1,
                            children: List.generate(
                              cubit.myImages.length,
                              (index) => singlePhotoBuilder(
                                  cubit.myImages[index],
                                  cubit.myTextOfImages[index],
                                  context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (pageIndex == 2)
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: followersBuilder(context),
                  ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          floatingActionButton: addPost(context),
        );
      },
    );
  }
}
