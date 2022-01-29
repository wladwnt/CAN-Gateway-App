import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:myhome_for_hoval_devices/models/parameter.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';

class ParametersProvider extends ChangeNotifier {
  int length = 0;
  bool allUnused=false;
  String state = "search";
  List<Parameter> _parameters = [];

  ParametersProvider(){
    fetchParameters(true);
    new Timer.periodic(Duration(seconds:20), (Timer t) => refreshValues());
  }

  Future<List<Parameter>> fetchParameters([bool withResetState=false]) async {
    var url;
    bool remoteAccessMode = Settings.getValue<bool>('key-enable-ra',false);
    if(!remoteAccessMode) {
      url = 'http://' +
          Settings.getValue<String>('key-ip-address-cgw', '192.168.0.0') +
          '/json/getallsettings';
    } else {
      final addr=Settings.getValue<String>('key-ra-address', '192.168.0.0');
      url = ((addr.startsWith('http://') || addr.startsWith('https://'))?'':'http://') + addr + ':' +
          Settings.getValue<String>('key-ra-port', '8181') +
          '/json/getallsettings';
    }
    try {
      if(withResetState) {
        length=0;
        allUnused=false;
        state = "search";
        notifyListeners();
      }
      var response = await http.get(Uri.parse(url));
      var decodeddata = await DecodeData(response, remoteAccessMode, Settings.getValue<String>('key-ra-key', ''));
      var data = json.decode(decodeddata);
      _parameters.addAll(_formatParameter(data));
      length=_parameters.length;
      fetchValues();
      state = "found";
      notifyListeners();
      return Future.value(_parameters);
    } catch (e) {
      print(e);
      state = "error";
      notifyListeners();
      return Future.error('An error occured');
    }
  }

  Future<void> fetchValues() async {
    var url;
    bool remoteAccessMode = Settings.getValue<bool>('key-enable-ra',false);
    if(!remoteAccessMode) {
      url ='http://'+Settings.getValue<String>('key-ip-address-cgw','192.168.0.0')+'/json/getallvalues';
    } else {
      final addr=Settings.getValue<String>('key-ra-address', '192.168.0.0');
      url = ((addr.startsWith('http://') || addr.startsWith('https://'))?'':'http://') + addr + ':' +
          Settings.getValue<String>('key-ra-port', '8181') +
          '/json/getallvalues';
    }
    try {
      var response = await http.get(Uri.parse(url));
      var decodeddata = await DecodeData(response, remoteAccessMode, Settings.getValue<String>('key-ra-key', ''));
      List<dynamic> data = json.decode(decodeddata);
      data.forEach((dataset) {
        setValueByIndex(dataset['i'],dataset['v']);
      });
      notifyListeners();
    } catch (e) {
      print(e);
      return Future.error('An error 2 occured');
    }
  }

  void setValueByIndex(int index, String value) {
    _parameters.forEach((element) {
      if(element.index==index) {
        element.value=value;
        return;
      }
    });
    return;
  }

  Future<void> refresh() async {
    _parameters.clear();
    length=0;
    state = "search";
    await fetchParameters();
  }

  Future<void> refreshValues() async {
    if(length==0) {
      await fetchParameters();
    } else {
      await fetchValues();
    }
  }

  List<Parameter> _formatParameter(List<dynamic> jsonData) {
    List<Parameter> _temp= jsonData.map((json) {
      return Parameter(
        index: json['i'],
        devType: json['t'],
        devAddr: json['a'],
        funcGroup: json['g'],
        funcNum: json['n'],
        rw: json['w'],
        id: json['d'],
        name: json['m'].replaceAll("_"," ").replaceAll("gradC","[°C]").replaceAll("percent","[%]"),
        value: "",
      );
    }).toList();
    var _fulllength=_temp.length;
    // remove from list elements that have rw=0 meaning they are not used
    _temp.removeWhere((element) => element.rw==0);
    if(_fulllength>0 && _temp.length==0) {
      allUnused=true;
    } else {
      allUnused=false;
    }
    return _temp;
  }

  List<Parameter> get parameters => [..._parameters];
}