import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';

class SetValueProvider extends ChangeNotifier {
  String state = "init";
  void resetState() {
    state="init";
  }

  Future<void> setValue(int index, String strValue) async {
    var url;
    bool remoteAccessMode = Settings.getValue<bool>('key-enable-ra',false);
    if(!remoteAccessMode) {
      url ='http://'+Settings.getValue<String>('key-ip-address-cgw','192.168.0.0')+'/setparam?num=${index+1}';
    } else {
      final addr=Settings.getValue<String>('key-ra-address', '192.168.0.0');
      url = ((addr.startsWith('http://') || addr.startsWith('https://'))?'':'http://') + addr + ':' +
          Settings.getValue<String>('key-ra-port', '8181') +
          '/setparam?num=${index+1}';
    }
    try {
      state="wait";
      notifyListeners();
      var response;
      if(remoteAccessMode) {
        //TODO encode data
        List<int> encodedData= await EncodeData(strValue, Settings.getValue<String>('key-ra-key', ''));
        Map<String,String> headers = {
          'Content-type' : 'application/bin',
          'Accept': 'application/bin',
        };
        response = await http.post(Uri.parse(url), body: encodedData, headers: headers);
      } else {
        response = await http.post(Uri.parse(url), body: strValue);
      }
      print(response.body);
      if(response.body=="OK") {
        state="set";
      } else {
        state="retry";
      }
      notifyListeners();
      return Future.value();
    } catch (e) {
      print(e);
      return Future.error('An error occured');
    }
  }
}