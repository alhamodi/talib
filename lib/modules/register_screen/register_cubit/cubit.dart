import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/models/user_model.dart';
import 'package:talib/modules/register_screen/register_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  void changePasswordShow() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(RegisterSuccessState());
      print(value.user!.uid);
      print(value.user!.email);
      userCreate(
          name: name,
          email: email,
          uid: value.user!.uid,
          isEmailVerified: false,
          );
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uid,
    required bool isEmailVerified,
  }) async {
    UserModel model = UserModel(
      email: email,
      name: name,
      uid: uid,
      isEmailVerified: false,
      profileImage: 'https://firebasestorage.googleapis.com/v0/b/social-app-3e9b6.appspot.com/o/default%20images%2Fundraw_male_avatar_323b.png?alt=media&token=44295a5e-8c15-4159-a818-1bd3b6192ac1',
      coverImage:
          'https://firebasestorage.googleapis.com/v0/b/social-app-3e9b6.appspot.com/o/default%20images%2Fundraw_conversation_h12g.png?alt=media&token=9f1bc126-81ed-4239-92b3-4595c0e44f8e',
      bio: 'SAWA User',
    );
    // emit(UserCreateLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      emit(UserCreateSuccessState(model));
      print('${model.name} created');
    }).catchError((error) {
      emit(UserCreateErrorState(error.toString()));
      print(error.toString());
    });
  }
}
