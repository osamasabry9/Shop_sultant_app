
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Shopsultant/cubit/states.dart';
import 'package:Shopsultant/models/profileModels/userModel.dart';
import 'package:Shopsultant/remoteNetwork/dioHelper.dart';
import 'package:Shopsultant/remoteNetwork/endPoints.dart';
import 'package:Shopsultant/shared/constants.dart';

class SignInCubit extends Cubit<ShopStates>
{
  SignInCubit() : super(InitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  late UserModel signInModel;

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());
    DioHelper.postData(
        url: SIGNUP,
        token: token,
        data:
        {
          'name': '$name',
          'email': '$email',
          'phone': '$phone',
          'password': '$password',
        }).then((value) {
      signInModel = UserModel.fromJson(value.data);
      emit(SignUpSuccessState(signInModel));
    }).catchError((error) {
      print(error.toString());
      emit(SignUpErrorState());
    });
  }

  bool showPassword = false;
  IconData suffixIcon = Icons.visibility;
  void changeSuffixIcon(context){
    showPassword =! showPassword;
    if(showPassword)
      suffixIcon = Icons.visibility_off;
    else
      suffixIcon = Icons.visibility;
    emit(ChangeSuffixIconState());
  }

  bool showConfirmPassword = false;
  IconData confirmSuffixIcon = Icons.visibility;
  void changeConfirmSuffixIcon(context){
    showConfirmPassword =! showConfirmPassword;
    if(showConfirmPassword)
      confirmSuffixIcon = Icons.visibility_off;
    else
      confirmSuffixIcon = Icons.visibility;
    emit(ChangeSuffixIconState());
  }

}