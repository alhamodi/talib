import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:talib/modules/image_view_screen/image_view_screen.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class PersonProfileScreen extends StatefulWidget {
  final personUid;
  const PersonProfileScreen({Key? key, this.personUid}) : super(key: key);

  @override
  _PersonProfileScreenState createState() =>
      _PersonProfileScreenState(this.personUid);
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  final personUid;

  // a variable for detect page index to display pages (posts,photos,followers,following)
  int pageIndex = 0;
  // boolean variable for grid and full screen detection
  bool isGrid = true;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  _PersonProfileScreenState(this.personUid);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        // HomeCubit.get(context).getAnotherPersonData(personUid: personUid);
        // HomeCubit.get(context).getPersonPosts(personUid: personUid);
        return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            HomeCubit cubit = HomeCubit.get(context);
            return Scaffold(
                // modify users to friends later
                body: cubit.personModel != null &&
                        cubit.personPosts.length >= 0 &&
                        // modify person followers to his followers
                        cubit.users.length > 0
                    ? SmartRefresher(
                        physics: BouncingScrollPhysics(),
                        controller: refreshController,
                        onRefresh: () async {
                          cubit.getAnotherPersonData(
                              personUid: personUid);
                          cubit.getPersonPosts(personUid: personUid);
                          refreshController.refreshCompleted();
                        },
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 290,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: InkWell(
                                        onTap: ()
                                        {
                                          navigateTo(context, ImageViewScreen(image: cubit.personModel!.coverImage, body: ''));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.green.withOpacity(0.4),
                                                  BlendMode.dstOut),
                                              image: NetworkImage(
                                                  '${cubit.personModel!.coverImage}'),
                                            ),
                                          ),
                                          width: double.infinity,
                                          height: 235,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        navigateTo(context, ImageViewScreen(image: cubit.personModel!.profileImage, body: ''));
                                      },
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 64,
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage: NetworkImage(
                                                '${cubit.personModel!.profileImage}',
                                              ),
                                            ),
                                          ),
                                          if(cubit.personModel!.isEmailVerified==true)
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.green,
                                                child: Icon(Icons.done,color: Colors.white,size: 18,),
                                              ),
                                            ),
                                        ],
                                      )

                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  '${cubit.personModel!.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 21),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 15, left: 15),
                                child: Text(
                                  '${cubit.personModel!.bio}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: subColor,
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(onPressed: (){
                                    navigateTo(context, PersonChatScreen(cubit.personModel));
                                  }, icon: Icon(Iconly_Broken.Message,size: 30,)),
                                  SizedBox(width: 15,),
                                  IconButton(onPressed: (){}, icon: Icon(Iconly_Broken.User,size: 30,)),
                                ],
                              ),
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
                                        '${cubit.personPosts.length}\nPosts',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: pageIndex == 0
                                                ? Colors.green
                                                : Colors.black54),
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
                                        print('photos');
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      child: Text(
                                        '${cubit.personImages.length}\nPhotos',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: pageIndex == 1
                                                ? Colors.green
                                                : Colors.black54),
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
                                        print('friends');
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      child: Text(
                                        '${cubit.personUsers.length}\nFriends',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: pageIndex == 2
                                                ? Colors.green
                                                : Colors.black54),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              if (pageIndex == 0)
                                cubit.personPosts.length >= 0
                                    ? Container(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                  child: postsBuilder(context),
                                )
                                    : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    )),
                              if (pageIndex == 1)
                                Container(
                                  color:
                                  Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          if(cubit.personImages.length!=0)
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isGrid = !isGrid;
                                                isGrid
                                                    ? print('grid')
                                                    : print('list');
                                              });
                                            },
                                            icon: !isGrid
                                                ? Icon(
                                              Icons.grid_view,
                                              color: Colors.green,
                                            )
                                                : Icon(
                                              Icons.fullscreen,
                                              size: 32,
                                              color: Colors.green,
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
                                              top: 0,
                                              bottom: 0,
                                              right: 0,
                                              left: 0),
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          childAspectRatio: 1 / 1,
                                          children: List.generate(
                                              cubit.personImages.length,
                                                  (index) => singlePhotoBuilder(
                                                  cubit.personImages[index],cubit.personTexts[index])),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (pageIndex == 2)
                                Container(
                                  color:
                                  Theme.of(context).scaffoldBackgroundColor,
                                  child: followersBuilder(),
                                ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: Colors.green,
                      )));
          },
        );
      },
    );
  }


  Widget postsBuilder(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => singlePersonPostBuilder(
              HomeCubit.get(context).personPosts[index], context, index),
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          itemCount: HomeCubit.get(context).personPosts.length),
    );
  }

  Widget singlePhotoBuilder(String image,String body) {
    return InkWell(
      onTap: ()
      {
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

  Widget followersBuilder() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            singleUserBuilder(HomeCubit.get(context).personUsers[index],context,
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
        itemCount: HomeCubit.get(context).personUsers.length);
  }
}
