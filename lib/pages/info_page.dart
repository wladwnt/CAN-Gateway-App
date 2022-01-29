import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoPage extends StatelessWidget {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Column(
        children: [
          SizedBox(height: 8,),
          Center(child: Text(AppLocalizations.of(context)!.infoMyHomeApp, style: optionStyle,textAlign: TextAlign.center,)),
          SizedBox(height: 8,),
          Center(child: Text(AppLocalizations.of(context)!.infoForHovalDevices, style: optionStyle,textAlign: TextAlign.center,)),
          SizedBox(height: 16,),
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 0.25,
            child: Image(image: AssetImage('assets/icon/icon.png')),
          ),
          SizedBox(height: 16,),
          InkWell(
              child: Text(AppLocalizations.of(context)!.infoMoreInfoGithub, style: TextStyle(color:Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
              onTap: () => launch('https://github.com/wladwnt/CAN-Gateway')
          ),
          SizedBox(height: 16,),
          Center(child: Text(AppLocalizations.of(context)!.infoNeedGateway, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,)),
          SizedBox(height: 16,),
          Image(image: AssetImage('assets/image/system.jpg')),
          SizedBox(height: 16,),
          Center(child: Text(AppLocalizations.of(context)!.infoHovalCompatible, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,)),
          SizedBox(height: 16,),
          Center(child: Text('(c) W. Waag, 2021, cangateway@gmx.de', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,)),
        ]
      ),
    );
  }
}