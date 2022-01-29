import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:myhome_for_hoval_devices/models/history.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class HistoryProvider extends ChangeNotifier {
  String state = "None";
  History history=History(index: 0, paramName: "", devType: 0, funcGroup: 0, funcNum: 0, id: 0, xValues: [], yValues:[]);

  Future<History> fetchHistory(int index, String paramName, int devType, int funcGroup, int funcNum, int id) async {
    history.index=index;
    history.paramName=paramName;
    history.devType=devType;
    history.funcGroup=funcGroup;
    history.funcNum=funcNum;
    history.id=id;
    var url;
    bool remoteAccessMode = Settings.getValue<bool>('key-enable-ra',false);
    if(!remoteAccessMode) {
      url ='http://'+Settings.getValue<String>('key-ip-address-cgw','192.168.0.0')+'/getparamhist?num=${index+1}';
    } else {
      final addr=Settings.getValue<String>('key-ra-address', '192.168.0.0');
      url = ((addr.startsWith('http://') || addr.startsWith('https://'))?'':'http://') + addr + ':' +
          Settings.getValue<String>('key-ra-port', '8181') +
          '/getparamhist?num=${index+1}';
    }
    try {
      //print("!!!!!!!!!!!!!!!! GOT !!!!!!!!!!!!!!!!!!!");
      state="wait";
      history.xValues.clear();
      history.yValues.clear();
      notifyListeners();
      var response = await http.get(Uri.parse(url));
      var decodeddata = await DecodeData(response, remoteAccessMode, Settings.getValue<String>('key-ra-key', ''));
      //print(response.body);
      List<String> pairs=decodeddata.split('\n');
      for(int i=0;i<pairs.length;i++) {
        List<String> temp=pairs[i].split(";");
        if(temp.length==2 && temp[1]!="NA") {
          history.xValues.add(temp[0]);
          history.yValues.add(temp[1]);
        }
      }
      state="got";
      notifyListeners();
      return Future.value(history);
    } catch (e) {
      print(e);
      return Future.error('An error occured');
    }
  }
}