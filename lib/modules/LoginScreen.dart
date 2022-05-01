import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Shopsultant/cubit/LoginCubit.dart';
import 'package:Shopsultant/cubit/shopCubit.dart';
import 'package:Shopsultant/cubit/states.dart';
import 'package:Shopsultant/modules/registerScreen.dart';
import 'package:Shopsultant/Layouts/shopLayout.dart';
import 'package:Shopsultant/remoteNetwork/cacheHelper.dart';
import 'package:Shopsultant/shared/component.dart';
import 'package:Shopsultant/shared/constants.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool hidePassword = true;
var loginFormKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  get obscureText => null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, ShopStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            showToast2(
                text: " ${state.loginUserModel.message}",
                state: ToastStates.SUCCESS);
            if (state.loginUserModel.status) {
              CacheHelper.saveData(
                      key: 'token', value: state.loginUserModel.data?.token)
                  .then((value) {
                token = state.loginUserModel.data?.token;
                navigateAndKill(context, ShopLayout());
                emailController.clear();
                passwordController.clear();
                ShopCubit.get(context).currentIndex = 0;
                ShopCubit.get(context).getHomeData();
                ShopCubit.get(context).getProfileData();
                ShopCubit.get(context).getFavoriteData();
                ShopCubit.get(context).getCartData();
                ShopCubit.get(context).getAddresses();
              });
            } else
              showToast2(
                  text: " ${state.loginUserModel.message}",
                  state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: loginFormKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(children: [
                            Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 40,
                              height: 40,
                            ),
                            Text(
                              'ShopSultant',
                              style: TextStyle(fontSize: 25),
                            ),
                          ]),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            ' Welcome back!',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                              context: context,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: 'Email Address',
                              prefix: Icons.email,
                              validate: (value) {
                                if (value!.isEmpty)
                                  return 'Email Address must be filled';
                              }),
                          SizedBox(
                            height: 40,
                          ),
                          defaultFormField(
                              context: context,
                              controller: passwordController,
                              label: 'Password',
                              prefix: Icons.lock,
                              isPassword: !LoginCubit.get(context).showPassword
                                  ? true
                                  : false,
                              validate: (value) {
                                if (value!.isEmpty)
                                  return 'Password must be filled';
                              },
                              onSubmit: (value) {
                                if (loginFormKey.currentState!.validate()) {
                                  LoginCubit.get(context).signIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              suffix: LoginCubit.get(context).suffixIcon,
                              suffixPressed: () {
                                LoginCubit.get(context)
                                    .changeSuffixIcon(context);
                              }),
                          Container(
                            width: double.infinity,
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forget Your Password ?',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                )),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          state is LoginLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : defaultButton(
                                  text: 'LOGIN',
                                  onTap: () {
                                    if (loginFormKey.currentState!.validate()) {
                                      LoginCubit.get(context).signIn(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      token = CacheHelper.getData('token');
                                    }
                                  },
                                ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text('Register Now')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
