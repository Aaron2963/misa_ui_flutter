import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:misa_ui_flutter/controller/auth_controller.dart';
import 'package:misa_ui_flutter/controller/storage.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/login.dart';
import 'package:provider/provider.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';
import 'package:misa_ui_flutter/view/main_menu/main_menu.dart';
import 'package:misa_ui_flutter/view/top_navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _authController = AuthController();

void main() async {
  await dotenv.load(fileName: '.env');
  await storage.ready();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MisaLocale()),
        ChangeNotifierProvider(create: (_) => BodyStateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<MisaLocale>().setLangCode('zhTW'),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Resource Management',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'TW'),
          ],
          locale: context.watch<MisaLocale>().locale,
          routes: {
            '/login': (context) => LoginPage(),
            '/main': (context) => const MainFrame(),
          },
          home: const IndexPage(),
        );
      },
    );
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authController.checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return const MainFrame();
          } else {
            return LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class MainFrame extends StatelessWidget {
  const MainFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final viewSettings = ViewSettings();
    return Scaffold(
      appBar: TopNavigationBar(
        AppLocalizations.of(context)!.siteDisplayName,
        () async {
          final navi = Navigator.of(context);
          await _authController.logout();
          navi.pushNamedAndRemoveUntil('/login', (route) => false);
        },
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            children: [
              SizedBox(
                width: viewSettings.sideBarWidth,
                height: constraints.maxHeight,
                child: const MainMenu(),
              ),
              Expanded(
                child: Container(
                  height: constraints.maxHeight,
                  padding: const EdgeInsets.all(16),
                  child: Body(
                    pageSchema: context.watch<BodyStateProvider>().pageSchema,
                    viewMenuItem:
                        context.watch<BodyStateProvider>().viewMenuItem,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
