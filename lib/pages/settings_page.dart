import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:myhome_for_hoval_devices/providers/parameters.dart';
import 'package:myhome_for_hoval_devices/providers/ra_info.dart';
import 'package:myhome_for_hoval_devices/models/rainfo.dart';
import 'package:provider/provider.dart';
import 'package:myhome_for_hoval_devices/providers/devices.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:validators/validators.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final RegExp _ipRegex = RegExp(
      r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
  @override
  Widget build(BuildContext context) {
    final devicesProvider = Provider.of<DevicesProvider>(context);
    final parametersProvider = Provider.of<ParametersProvider>(context);
    final rainfoProvider = Provider.of<RainfoProvider>(context);
    return Container(
        key: UniqueKey(),
        child: Column(
            children: <Widget> [
              TextInputSettingsTile(
                  title: AppLocalizations.of(context)!.setIPGateway,
                  settingKey: 'key-ip-address-cgw',
                  initialValue: '192.168.0.0',
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                  validator: (text) => _ipRegex.hasMatch(text==null?'':text)?null:AppLocalizations.of(context)!.setPleaseEnterIP,
                  onChange: (text) {
                    Settings.setValue<String>('key-ip-address-cgw', text);
                    parametersProvider.fetchParameters();
                  }
              ),
            Divider(),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 0,
                        bottom: 0,
                      ),
                      child: Row(
                      children: <Widget>[
                        Expanded(child:Text(AppLocalizations.of(context)!.setListCGW)),
                        ElevatedButton(
                          style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 14),),
                          onPressed: (devicesProvider.runState!='busy')?devicesProvider.refresh:null,
                          child: Text(AppLocalizations.of(context)!.setSearchAgain),
                        ),
                      ]
                    ),
                  ),
                  _buildDevList(context),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 0,
                  bottom: 0,
                ),
                child: Row(
                    children: <Widget>[
                      Expanded(child:Text(AppLocalizations.of(context)!.raSetTitle)),
                      ElevatedButton(
                        style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 14),),
                        onPressed: (rainfoProvider.state!='wait')?()
                        {
                          final Future<Rainfo> rainfoFuture=rainfoProvider.fetchRainfo();
                          rainfoFuture.then((rainfo) {
                            //print(rainfo.address);
                            //print(rainfo.port);
                            //print(rainfo.key);
                            Settings.setValue<String>('key-ra-address', rainfo.address);
                            Settings.setValue<String>('key-ra-port', rainfo.port.toString());
                            Settings.setValue<String>('key-ra-key', rainfo.key);
                            parametersProvider.fetchParameters();
                          });

                        }:null,
                        child: Text(AppLocalizations.of(context)!.raSearchButton),
                      ),
                    ]
                ),
              ),
              TextInputSettingsTile(
                  title: AppLocalizations.of(context)!.raAddressSetTitle,
                  settingKey: 'key-ra-address',
                  initialValue: '',
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                  validator: (text) => isURL(text, requireTld: false)?null:AppLocalizations.of(context)!.setPleaseEnterAddress,
                  onChange: (text) {
                    Settings.setValue<String>('key-ra-address', text);
                    parametersProvider.fetchParameters();
                  }
              ),
              TextInputSettingsTile(
                  title: AppLocalizations.of(context)!.raPortSetTitle,
                  settingKey: 'key-ra-port',
                  initialValue: '8181',
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                  validator: (text) => isNumeric(text!)?null:AppLocalizations.of(context)!.setPleaseEnterPort,
                  onChange: (text) {
                    Settings.setValue<String>('key-ra-port', text);
                    parametersProvider.fetchParameters();
                  }
              ),
              TextInputSettingsTile(
                  title: AppLocalizations.of(context)!.raKeySetTitle,
                  settingKey: 'key-ra-key',
                  initialValue: '',
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                  validator: (text) => (text!.length==32)?null:AppLocalizations.of(context)!.setPleaseEnterKey,
                  onChange: (text) {
                    Settings.setValue<String>('key-ra-key', text);
                    parametersProvider.fetchParameters();
                  }
              ),
              Divider(),
              SwitchSettingsTile(
                settingKey: 'key-enable-ra',
                title: AppLocalizations.of(context)!.setEnableRA,
                enabledLabel: AppLocalizations.of(context)!.rAenabledLabel,
                disabledLabel: AppLocalizations.of(context)!.rAdisabledLabel,
                onChange: (value) {
                  Settings.setValue<bool>('key-enable-ra', value);
                },
              ),
              SwitchSettingsTile(
                settingKey: 'enable-intro',
                title: AppLocalizations.of(context)!.setEnableIntro,
                enabledLabel: AppLocalizations.of(context)!.enabledLabel,
                disabledLabel: AppLocalizations.of(context)!.disabledLabel,
                onChange: (value) {
                  Settings.setValue<bool>('enable-intro', value);
                },
              ),
            ]
        ),
    );
  }

  Widget _buildDevList(context) {
    final devicesProvider = Provider.of<DevicesProvider>(context);
    final parametersProvider = Provider.of<ParametersProvider>(context);
    return devicesProvider.length != 0
        ? RefreshIndicator(
      child:
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(4),
              itemCount: devicesProvider.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.forward),
                        title: Text(AppLocalizations.of(context)!.deviceCGW),
                        subtitle: Text("IP: "+devicesProvider.devices[index]),
                        trailing: ElevatedButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          onPressed: () async {
                            await Settings.setValue<String>('key-ip-address-cgw', devicesProvider.devices[index]);
                            setState(() {});
                            parametersProvider.fetchParameters();
                            },
                          child: Text(AppLocalizations.of(context)!.useThis),
                        ),
                      )
                    ],
                  ),
                );
              }),
      onRefresh: devicesProvider.refresh,
    )
        : Center(child: Text(devicesProvider.searchState=="dosearch"?AppLocalizations.of(context)!.searchDoSearch:(devicesProvider.searchState=="nofound"?AppLocalizations.of(context)!.searchNoFound:AppLocalizations.of(context)!.searchFound)));
  }
}