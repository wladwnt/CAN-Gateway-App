import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
//import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cryptography/cryptography.dart';

List<String> GetParamList(int devType, int funcGroup, int funcNum, int paramID, BuildContext context) {
  if(devType==8 && funcGroup==50 && funcNum==0 && paramID==39652)
    return [AppLocalizations.of(context)!.ssOff,
      AppLocalizations.of(context)!.ssNormal,
      AppLocalizations.of(context)!.ssVOC,
      AppLocalizations.of(context)!.ssHumidity,
      AppLocalizations.of(context)!.ssFrostProtect,
      AppLocalizations.of(context)!.ssCoolVent,
      AppLocalizations.of(context)!.ssFault,
      AppLocalizations.of(context)!.ssSummerHumidity,
    ];
  if(devType==8 && funcGroup==50 && funcNum==0 && paramID==39600)
    return [AppLocalizations.of(context)!.ssOff, AppLocalizations.of(context)!.ssOn];
  if(devType==4 && funcGroup==2 && funcNum==0 && paramID==1066)
    return [AppLocalizations.of(context)!.ssOff, AppLocalizations.of(context)!.ssOn];
  if(devType==8 && funcGroup==50 && funcNum==0 && paramID==40650)
    return [AppLocalizations.of(context)!.ssStandby,
      AppLocalizations.of(context)!.ssWeek1,
      AppLocalizations.of(context)!.ssWeek2, "",
      AppLocalizations.of(context)!.ssConstant,
      AppLocalizations.of(context)!.ssEco];
  if((devType==0 || devType==3 || devType==4) && funcGroup==1 && funcNum<=4 && paramID==3050)
    return [AppLocalizations.of(context)!.ssStandby,
      AppLocalizations.of(context)!.ssWeek1,
      AppLocalizations.of(context)!.ssWeek2, "",
      AppLocalizations.of(context)!.ssConstant,
      AppLocalizations.of(context)!.ssEco,
      AppLocalizations.of(context)!.ssManualHeating,
      AppLocalizations.of(context)!.ssManualCooling];
  if((devType==0 || devType==3 || devType==4) && funcGroup==2 && funcNum<=4 && paramID==5050)
    return [AppLocalizations.of(context)!.ssStandby,
      AppLocalizations.of(context)!.ssWeek1,
      AppLocalizations.of(context)!.ssWeek2, "",
      AppLocalizations.of(context)!.ssConstant,
      AppLocalizations.of(context)!.ssEco];
  if(devType==0 && funcGroup==10 && funcNum<=1 && paramID==9075)
    return [AppLocalizations.of(context)!.ssOff,
      AppLocalizations.of(context)!.ssAuto, "", "",
      AppLocalizations.of(context)!.ssHeating,
      AppLocalizations.of(context)!.ssCooling];
  if(devType==3 && funcGroup==0 && funcNum==0 && paramID==21044)
    return [AppLocalizations.of(context)!.ssOff, "FE=1", "FE=2", "FE=3", "FE=4", "FE=5"];
  if(devType==0 && funcGroup==10 && funcNum==0 && paramID==2053)
    return [AppLocalizations.of(context)!.ssOff,
      AppLocalizations.of(context)!.ssHeating,
      AppLocalizations.of(context)!.ssPreHeating,
      AppLocalizations.of(context)!.ssExtOff,
      AppLocalizations.of(context)!.ssCooling,
      AppLocalizations.of(context)!.ssPreCooling, "", "", "", "", "", "", "", "", "",
      AppLocalizations.of(context)!.ssAlarm,
      AppLocalizations.of(context)!.ssError,
      AppLocalizations.of(context)!.ssBlocked, "", "", "",
      AppLocalizations.of(context)!.ssWFmaxOff,
      AppLocalizations.of(context)!.ssWFsollOff, "", "", "",
      AppLocalizations.of(context)!.ssBivalentOff,
      AppLocalizations.of(context)!.ssWarmWaterClosed,
      AppLocalizations.of(context)!.ssMinOff,
      AppLocalizations.of(context)!.ssMinOn,
      AppLocalizations.of(context)!.ssHeatingUp,
      AppLocalizations.of(context)!.ssBurnOff,
      AppLocalizations.of(context)!.ssPostCarriage,
      AppLocalizations.of(context)!.ssVerzFolgeWE,
      AppLocalizations.of(context)!.ssOvertemperature];
  if(devType==3 && funcGroup==1 && funcNum<=4 && paramID==2051)
    return [AppLocalizations.of(context)!.ssOff,
      AppLocalizations.of(context)!.ssNormal,
      AppLocalizations.of(context)!.ssComfort,
      AppLocalizations.of(context)!.ssEco,
      AppLocalizations.of(context)!.ssFrostOp,
      AppLocalizations.of(context)!.ssForceTaking,
      AppLocalizations.of(context)!.ssForceSlowdown,
      AppLocalizations.of(context)!.ssHolidayOperation,
      AppLocalizations.of(context)!.ssParty,
      AppLocalizations.of(context)!.ssNormalCooling,
      AppLocalizations.of(context)!.ssComfortCooling,
      AppLocalizations.of(context)!.ssEcoCooling,
      AppLocalizations.of(context)!.ssError,
      AppLocalizations.of(context)!.ssManual,
      AppLocalizations.of(context)!.ssSafeCooling,
      AppLocalizations.of(context)!.ssPartyCooling,
      AppLocalizations.of(context)!.ssDryDownHeatUp,
      AppLocalizations.of(context)!.ssDryDownNormal,
      AppLocalizations.of(context)!.ssDryDownCoolDown,
      AppLocalizations.of(context)!.ssDryDownEnd, "", "",
      AppLocalizations.of(context)!.ssCoolingExtConst,
      AppLocalizations.of(context)!.ssHeatingExtConst, "", "",
      AppLocalizations.of(context)!.ssSmartGrid];
  if(devType==3 && funcGroup==2 && funcNum<=4 && paramID==2052)
    return [AppLocalizations.of(context)!.ssOff,
      AppLocalizations.of(context)!.ssNormal,
      AppLocalizations.of(context)!.ssComfort,
      AppLocalizations.of(context)!.ssForceTaking,
      AppLocalizations.of(context)!.ssForceCharge,
      AppLocalizations.of(context)!.ssError,
      AppLocalizations.of(context)!.ssWWTaking,
      AppLocalizations.of(context)!.ssWarning,
      AppLocalizations.of(context)!.ssReducedChargeMode, "", "", "",
      AppLocalizations.of(context)!.ssPreferredSmartGridOp,
      AppLocalizations.of(context)!.ssForceSmartGridTaking];
  if(devType==3 && funcGroup==0 && funcNum==0 && paramID==23084)
    return [AppLocalizations.of(context)!.ssOff, AppLocalizations.of(context)!.ssOn];
  if(devType==3 && funcGroup==0 && funcNum==0 && (paramID>=23031 && paramID<=21039))
    return [AppLocalizations.of(context)!.ssOff, AppLocalizations.of(context)!.ssOn];
  if(devType==3 && funcGroup==0 && funcNum==0 && (paramID>=23045 && paramID<=21047))
    return [AppLocalizations.of(context)!.ssOff, AppLocalizations.of(context)!.ssOn];
  return [];
}


bool ParamHasList(int devType, int funcGroup, int funcNum, int paramID, BuildContext context) {
  if (!GetParamList(devType, funcGroup, funcNum, paramID, context).isEmpty)
    return true;
  return false;
}


List<String> GetParamNonEmptyList(int devType, int funcGroup, int funcNum, int paramID, BuildContext context) {
  List<String> _list= GetParamList(devType, funcGroup, funcNum, paramID, context);
  List<String> _list1=[];
  for(int i=0;i<_list.length;i++) if(_list[i]!="") _list1.add(_list[i]);
  return _list1;
}

List<int> GetParamNonEmptyListIndexes(int devType, int funcGroup, int funcNum, int paramID, BuildContext context) {
  List<String> _list= GetParamList(devType, funcGroup, funcNum, paramID, context);
  List<int> _list1=[];
  for(int i=0;i<_list.length;i++) if(_list[i]!="") _list1.add(i);
  return _list1;
}

String ValueToDecodedValue(String value, int devType, int funcGroup, int funcNum, int paramID, BuildContext context) {
  List<String> _list= GetParamList(devType, funcGroup, funcNum, paramID, context);
  if (!_list.isEmpty){
    try {
      int _intValue = double.parse(value).toInt();
      if (_intValue < _list.length && _intValue >= 0) {
        return _list[_intValue];
      } else {
        return value;
      }
    } catch (e) {
      return value;
    }
  }
  return value;
}

Future<String> DecodeData(http.Response response, bool mustbedecoded, String key) async {
  if(!mustbedecoded) {
    return response.body;
  } else {
    //decode
    int contentLen=response.contentLength==null?0:response.contentLength!;
    //for(int i=0; i<contentLen; i++ ) print(response.bodyBytes[i].toRadixString(16));
    /*
    final Enckey = encrypt.Key(AsciiEncoder().convert(key));
    final iv = encrypt.IV(response.bodyBytes.sublist(contentLen-16));
    final encrypter = encrypt.Encrypter(encrypt.AES(Enckey, mode: encrypt.AESMode.ctr)); //, padding: null
    var decrypted = encrypter.decrypt(encrypt.Encrypted(response.bodyBytes.sublist(0,contentLen-16)),  iv: iv);
    */
    final ivLen=16;
    final tagLen=16;
    final algorithm = AesGcm.with256bits();
    final hash = await Sha256().hash(AsciiEncoder().convert(key));
    final keyHash = hash.bytes;
    final secretKey = await algorithm.newSecretKeyFromBytes(keyHash);
    final nonce = response.bodyBytes.sublist(contentLen-ivLen);
    final mac = response.bodyBytes.sublist(contentLen-tagLen-ivLen, contentLen-ivLen);
    SecretBox secretBox = SecretBox(response.bodyBytes.sublist(0,contentLen-tagLen-ivLen), mac: Mac(mac), nonce: nonce);
    var decrypted = await algorithm.decrypt(secretBox,
      secretKey: secretKey, // aad: AsciiEncoder().convert("encrypted1234567")
    );
    //print(AsciiDecoder(allowInvalid: true).convert(decrypted));
      return AsciiDecoder(allowInvalid: true).convert(decrypted);
  }
}

Future<List<int>> EncodeData(String data, String key) async {
  final algorithm = AesGcm.with256bits(nonceLength: 16);
  final hash = await Sha256().hash(AsciiEncoder().convert(key));
  final keyHash = hash.bytes;
  final secretKey = await algorithm.newSecretKeyFromBytes(keyHash);
  final nonce = algorithm.newNonce();
  print(nonce.toString());
  final secretBox = await algorithm.encrypt(
    AsciiEncoder().convert(data),
    secretKey: secretKey,
    nonce: nonce,
    //aad: AsciiEncoder().convert("encrypted1234567")
  );
  List<int> retVal=secretBox.cipherText+secretBox.mac.bytes+secretBox.nonce;
    return retVal;
}