import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/home/home/home_view.dart';
import 'package:talib/modules/login_screen/login_cubit/cubit.dart';
import 'package:talib/modules/register_screen/register_screen.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';

import 'login_cubit/states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var disKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(msg: state.error, state: ToastState.ERROR);
        }

        if (state is LoginSuccessState) {
          CacheHelper.saveData(key: 'uid', value: state.uid);
          uid = state.uid;
          print(uid);
          navigateAndFinish(
              context,
              HomePage(
                afterLoginOrRegister: true,
              ));
        }
      },
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark));
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(
                              'assets/images/flat1.jpg',
                            ),
                          ),
                        ),
                        width: double.infinity,
                        height: 250,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your username',
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  text: 'Email',
                                  prefix: Icons.alternate_email),
                              defaultTextField(
                                  onSubmit: (value) {
                                    if (formKey.currentState!.validate() ==
                                        true) {
                                      // cubit.userLogin(
                                      //     email: emailController.text,
                                      //     password: passwordController.text);
                                    }
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter you password',
                                  controller: passwordController,
                                  type: TextInputType.visiblePassword,
                                  text: 'Password',
                                  prefix: Icons.lock,
                                  isPassword: cubit.isPassword,
                                  suffix: cubit.isPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  suffixFunction: () {
                                    cubit.changePasswordShow();
                                  }),
                              SizedBox(
                                height: 10,
                              ),
                              state is! LoginLoadingState
                                  ? Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            print('button taped');
                                            if (formKey.currentState!
                                                    .validate() ==
                                                true) {
                                              cubit.userLogin(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text);
                                            } else {
                                              print('else button');
                                            }
                                          },
                                          child: Text("LOGIN")),
                                    )
                                  : Center(
                                      child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: CircularProgressIndicator(
                                        color: subColor,
                                      ),
                                    )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      navigateTo(
                                          context,
                                          RegisterScreen(
                                            afterLoginOrRegister: true,
                                          ));
                                    },
                                    child: Text(
                                      'Register now',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
