import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:myhome_for_hoval_devices/models/rainfo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RainfoProvider extends ChangeNotifier {
  String state = "None";
  Rainfo rainfo=Rainfo(address: "", port: 8181, key: "");

  Future<Rainfo> fetchRainfo() async {
    final url ='http://'+Settings.getValue<String>('key-ip-address-cgw','192.168.0.0')+'/json/getrainfo';
    try {
      state="wait";
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);
      rainfo.address = data['addr'];
      rainfo.port = data['port'];
      rainfo.key = data['key'];
      state="got";
      notifyListeners();
      return Future.value(rainfo);
    } catch (e) {
      print(e);
      return Future.error('An error occured');
    }
  }
}