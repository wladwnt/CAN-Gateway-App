import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myhome_for_hoval_devices/pages/paramlist_page.dart';
import 'package:myhome_for_hoval_devices/pages/settings_page.dart';
import 'package:myhome_for_hoval_devices/pages/info_page.dart';
import 'package:myhome_for_hoval_devices/providers/parameters.dart';
import 'package:myhome_for_hoval_devices/providers/devices.dart';
import 'package:myhome_for_hoval_devices/providers/history.dart';
import 'package:myhome_for_hoval_devices/providers/set_value.dart';
import 'package:myhome_for_hoval_devices/providers/ra_info.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:myhome_for_hoval_devices/pages/intro_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer' as developer;

void main() {
  initSettings().then((_) {
    runApp(MyApp());
  });
}

Future<void> initSettings() async {
  await Settings.init();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ParametersProvider()),
          ChangeNotifierProvider(create: (context) => DevicesProvider()),
          ChangeNotifierProvider(create: (context) => HistoryProvider()),
          ChangeNotifierProvider(create: (context) => SetValueProvider()),
          ChangeNotifierProvider(create: (context) => RainfoProvider()),
        ],
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('de', ''), // German, no country code
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Settings.getValue<bool>('enable-intro', true)? OnBoardingPage(): MainWidget(),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      ParamListPage(),
      SingleChildScrollView(child: SettingsPage(),),
      SingleChildScrollView(child: InfoPage(),),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}