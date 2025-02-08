import 'package:assignment/core/dependency_injection.dart';
import 'package:assignment/core/local_storage.dart';
import 'package:assignment/features/home/bloc/home_bloc.dart';
import 'package:assignment/features/home/home_screen.dart';
import 'package:assignment/share/theme/theme_colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  await LocalStorage.instance.initHive();
  await LocalStorage.instance.registerAdapters();
  await LocalStorage.instance.openBox();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Assignment',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeColors.primary,
            primary: ThemeColors.primary,
          ),
          primaryTextTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: ThemeColors.textColor,
            ),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocProvider(
          create: (context) => getIt<HomeBloc>(),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
