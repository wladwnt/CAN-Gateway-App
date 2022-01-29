import 'package:flutter/material.dart';
import 'dart:async';
import "package:upnp_ns/upnp.dart";

class DevicesProvider extends ChangeNotifier {
  int length = 0;
  List<String> _devices = [];
  String searchState = "";
  String runState = "ready";

  DevicesProvider(){
    refresh();
  }

  Future<void> fetchDevices() async {
    var disc = new DeviceDiscoverer();
    await disc.start(ipv6: false);
    disc.quickDiscoverClients(timeout: const Duration(seconds: 10)).listen((client) async {
      try {
        var dev = await client.getDevice();
        if(dev!.modelName=="CANGateway") {
        //if(dev!=null) {
          _devices.add(Uri.parse(dev.url.toString()).host.toString());
          //print("!!!!!!!!!!!!  DEV added ${Uri.parse(dev.url.toString()).host.toString()}");
          length = _devices.length;
          searchState='found';
          notifyListeners();
        }
      } catch (e, stack) {
        print("ERROR: ${e} - ${client.location}");
        print(stack);
      }
    });
  }

  Future<void> refresh() async {
    _devices.clear();
    length=0;
    searchState='dosearch';
    runState = 'busy';
    notifyListeners();
    await fetchDevices();
    await Future.delayed(Duration(seconds: 11));
    if(length==0) {
      searchState='nofound';
      runState = 'ready';
      notifyListeners();
    } else {
      runState = 'ready';
      notifyListeners();
    }
  }

  List<String> get devices => [..._devices];
}