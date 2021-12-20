import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_cubit.dart';
import 'package:talib/home/home/home_state.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';
import 'package:talib/shared/iconly-broken_icons.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        nameController.text =
            cubit.model?.name == null ? '' : cubit.model!.name!;
        bioController.text = cubit.model?.bio == null ? '' : cubit.model!.bio!;

        return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: mainColor,
              leading: IconButton(
                icon: Icon(
                  Iconly_Broken.Arrow___Left_2,
                  color: white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                if (cubit.profileImage != null ||
                    cubit.coverImage != null ||
                    nameController.text != '' ||
                    nameController.text != cubit.model?.name ||
                    bioController.text != '' ||
                    bioController.text != cubit.model?.bio)
                  TextButton(
                      onPressed: () async {
                        if (cubit.profileImage != null ||
                            cubit.coverImage != null ||
                            nameController.text != '' ||
                            nameController.text != cubit.model?.name ||
                            bioController.text != '' ||
                            bioController.text != cubit.model?.bio) {
                          if (cubit.profileImage != null) {
                            await cubit.uploadProfileImage();
                          }
                          if (cubit.coverImage != null) {
                            await cubit.uploadCoverImage();
                          }
                          if (formKey.currentState!.validate()) {
                            await cubit.updateUser(
                                name: nameController.text,
                                bio: bioController.text);
                          } else {}
                        }

                        cubit.coverImage = null;
                        cubit.profileImage = null;

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: white),
                      )),
              ],
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: white,
                ),
              ),
            ),
            body: cubit.model != null
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 230,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        cubit.coverImage == null
                                            ? cacheImage(
                                                url:
                                                    '${cubit.model!.coverImage}',
                                                width: double.infinity,
                                                height: 180,
                                              )
                                            : Container(
                                                width: double.infinity,
                                                height: 180,
                                                child: Image.file(
                                                  File(cubit.coverImage!.path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                              child: defaultIconButton(
                                                  icon: Iconly_Broken.Image,
                                                  function: () {
                                                    cubit.getCoverImage();
                                                  },
                                                  color: white)),
                                        )
                                      ],
                                    )),
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      radius: 64,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: cubit.profileImage == null
                                          ? cacheImage(
                                              url:
                                                  '${cubit.model!.profileImage}',
                                              width: 120,
                                              height: 120,
                                              shape: BoxShape.circle)
                                          : CircleAvatar(
                                              radius: 60,
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(
                                                      cubit.profileImage!.path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
                                    CircleAvatar(
                                        child: defaultIconButton(
                                            icon: Iconly_Broken.Image,
                                            function: () {
                                              cubit.getProfileImage();
                                            },
                                            color: white))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextField(
                            horizontalPadding: 8,
                            controller: nameController,
                            type: TextInputType.name,
                            text: "Name",
                            textForUnValid: "name must not be empty",
                            prefix: Iconly_Broken.User,
                          ),
                          defaultTextField(
                            horizontalPadding: 8,
                            controller: bioController,
                            type: TextInputType.text,
                            text: "Bio",
                            textForUnValid: "bio must not be empty",
                            prefix: Iconly_Broken.Graph,
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: mainColor,
                  )));
      },
    );
  }
}
