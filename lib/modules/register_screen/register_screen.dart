import 'package:talib/home/home/home_view.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talib/modules/login_screen/login_screen.dart';
import 'package:talib/modules/register_screen/register_cubit/cubit.dart';
import 'package:talib/modules/register_screen/register_cubit/states.dart';
import 'package:talib/shared/components.dart';

class RegisterScreen extends StatelessWidget {
  final bool afterLoginOrRegister;

  RegisterScreen({Key? key, required this.afterLoginOrRegister})
      : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameControl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is RegisterErrorState) {
          showToast(msg: state.error, state: ToastState.ERROR);
        }

        if (state is UserCreateSuccessState) {
          CacheHelper.saveData(key: 'uid', value: state.model.uid);
          uid = state.model.uid;
          print(uid);
          navigateAndFinish(
              context,
              HomePage(
                afterLoginOrRegister: true,
                // afterLoginOrRegister: true,
              ));
        }
      },
      builder: (context, state) {
        RegisterCubit cubit = RegisterCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
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
                            'assets/images/flat2.jpg',
                          ),
                        ),
                      ),
                      width: double.infinity,
                      height: 250,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          defaultTextField(
                              onSubmit: (value) {
                                print(value);
                              },
                              textForUnValid: 'Enter your name',
                              controller: nameControl,
                              type: TextInputType.name,
                              text: 'Name',
                              prefix: Icons.person),
                          defaultTextField(
                              onSubmit: (value) {
                                print(value);
                              },
                              textForUnValid: 'Enter your email',
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              text: 'Email',
                              prefix: Icons.alternate_email),
                          defaultTextField(
                              onSubmit: (value) {
                                if (formKey.currentState!.validate() == true) {}
                              },
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
                          state is! RegisterLoadingState
                              ? defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate() ==
                                        true) {
                                      cubit.userRegister(
                                        name: nameControl.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    } else {}
                                  },
                                  text: 'sign up')
                              : Center(
                                  child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: CircularProgressIndicator(
                                    color: subColor,
                                  ),
                                )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don you have an account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, LoginScreen());
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
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
          ),
        );
      },
    );
  }
}
