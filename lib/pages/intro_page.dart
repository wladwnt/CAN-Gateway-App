import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myhome_for_hoval_devices/main.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Settings.setValue<bool>('enable-intro', false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MainWidget()), (Route<dynamic> route) => false,
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/icon/icon.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.introSkipIntroCompletely,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.welcome,
          body: AppLocalizations.of(context)!.introControlUsingApp,
          image: _buildImage('icon/icon.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.introStep1Title,
          body: AppLocalizations.of(context)!.introStep1Body,
          image: _buildImage('image/intro1.jpg'),
          decoration: pageDecoration,
          footer: InkWell(
              child: Text('https://github.com/wladwnt/CAN-Gateway', style: TextStyle(color:Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
              onTap: () => launch('https://github.com/wladwnt/CAN-Gateway')
          ),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.introStep2Title,
          body: AppLocalizations.of(context)!.introStep2Body,
          image: _buildImage('image/intro2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.introEnjoy,
          body: AppLocalizations.of(context)!.introEnjoyBody,
          image: _buildImage('image/intro3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      isTopSafeArea: true,
      //rtl: true, // Display as right-to-left
      skip: Text(AppLocalizations.of(context)!.introSkip),
      next: const Icon(Icons.arrow_forward),
      done:  Text(AppLocalizations.of(context)!.introDone, style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}