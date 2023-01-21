import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:provider/provider.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';
import 'package:misa_ui_flutter/view/main_menu/main_menu.dart';
import 'package:misa_ui_flutter/view/top_navigation_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MisaLocale()),
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
          home: const MainFrame(),
        );
      }
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
          context.watch<MisaLocale>().translate('_SiteDisplayName')),
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
                  color: Colors.green,
                  child: const Text('Main'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
