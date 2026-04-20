import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/app_config.dart';
import 'package:aitota_business/core/services/role_provider.dart';
import 'package:aitota_business/firebase_options.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(RoleProvider());
  Get.put(AppConfig(Get.find<RoleProvider>()));
  Get.put(GoogleSignIn(
    serverClientId:
        '292669454952-fdfl4qrfb42nupprmm88m91v60duej9b.apps.googleusercontent.com',
  ));
Get.lazyPut(() => CallsController(), fenix: true);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aitota Business',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
      builder: (context, child) {
        ScreenUtil.init(
          context,
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: DismissKeyboard(child: child!),
        );
      },
    );
  }
}
