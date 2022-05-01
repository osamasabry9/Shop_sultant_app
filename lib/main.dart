import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Shopsultant/cubit/appCubit.dart';
import 'package:Shopsultant/cubit/shopCubit.dart';
import 'package:Shopsultant/cubit/states.dart';
import 'package:Shopsultant/modules/LoginScreen.dart';
import 'package:Shopsultant/Layouts/shopLayout.dart';
import 'package:Shopsultant/remoteNetwork/cacheHelper.dart';
import 'package:Shopsultant/remoteNetwork/dioHelper.dart';
import 'package:Shopsultant/shared/bloc_observer.dart';
import 'package:Shopsultant/shared/constants.dart';
import 'package:Shopsultant/shared/themes.dart';
import 'modules/OnBoardingScreen.dart';

Future<void> main() async {
//Forced to work in order.
  WidgetsFlutterBinding.ensureInitialized();

//Helps me figure out how the program moves (claas BlocObserver).
  Bloc.observer = MyBlocObserver();

  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
//Take the values from the cache helper
  bool? isDark = CacheHelper.getData('isDark');
  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  token = CacheHelper.getData('token');

  if (showOnBoard == false) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = LoginScreen();
  } else
    widget = OnBoarding();
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AppCubit()..changeMode(fromCache: isDark)),
          BlocProvider(
              create: (context) => ShopCubit()
                ..getHomeData()
                ..getCategoryData()
                ..getFavoriteData()
                ..getProfileData()
                ..getCartData()
                ..getAddresses()),
        ],
        child: BlocConsumer<AppCubit, ShopStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: startWidget,
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: cubit.appMode,
              );
            }));
  }
}
