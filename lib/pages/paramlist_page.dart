import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';
import 'package:myhome_for_hoval_devices/providers/parameters.dart';
import 'package:myhome_for_hoval_devices/providers/history.dart';
import 'package:myhome_for_hoval_devices/pages/history_dialog_box.dart';
import 'package:myhome_for_hoval_devices/pages/setvalue_dialog_box.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParamListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _buildList(context),
      );
  }

  Widget IconSelector(String paramName) {
    if(paramName.toLowerCase().contains("temperatur") || paramName.toLowerCase().contains("[°C]"))
      return Image(image: AssetImage('assets/image/temperature_symbol.png'));
    if(paramName.toLowerCase().contains("feucht") || paramName.toLowerCase().contains("humidity"))
      return Image(image: AssetImage('assets/image/humid_symbol.png'));
    if((paramName.toLowerCase().contains("ventil") || paramName.toLowerCase().contains("luftung") || paramName.toLowerCase().contains("lueftung") || paramName.toLowerCase().contains("fan")) &&
        paramName.toLowerCase().contains("[%]"))
      return Image(image: AssetImage('assets/image/vent_symbol.png'));
    if(paramName.toLowerCase().contains("status") || paramName.toLowerCase().contains("state"))
      return Image(image: AssetImage('assets/image/state_symbol.png'));
    if(paramName.toLowerCase().contains("wahl") || paramName.toLowerCase().contains("select")|| paramName.toLowerCase().contains("choice"))
      return Image(image: AssetImage('assets/image/select_symbol.png'));
    if(paramName.contains("VOC") && paramName.toLowerCase().contains("[%]"))
      return Image(image: AssetImage('assets/image/voc_symbol.png'));
    if(paramName.toLowerCase().contains("error") || paramName.toLowerCase().contains("fehler"))
      return Image(image: AssetImage('assets/image/err_symbol.png'));
    if(paramName.toLowerCase().contains("[V]"))
      return Image(image: AssetImage('assets/image/volt_symbol.png'));
    if(paramName.toLowerCase().contains("[A]"))
      return Image(image: AssetImage('assets/image/current_symbol.png'));
    if(paramName.toLowerCase().contains("[m3]"))
      return Image(image: AssetImage('assets/image/volume_symbol.png'));
    if(paramName.toLowerCase().contains("[kW]") || paramName.toLowerCase().contains("[W]") || paramName.toLowerCase().contains("[MW]"))
      return Image(image: AssetImage('assets/image/power_symbol.png'));
    if(paramName.toLowerCase().contains("[kWh]") || paramName.toLowerCase().contains("[MWh]"))
      return Image(image: AssetImage('assets/image/energy_symbol.png'));
    if(paramName.toLowerCase().contains("[l/m]") || paramName.toLowerCase().contains("[l/h]"))
      return Image(image: AssetImage('assets/image/flow_symbol.png'));
    if(paramName.toLowerCase().contains("[h]") || paramName.toLowerCase().contains("[m]") || paramName.toLowerCase().contains("[sek.]") || paramName.toLowerCase().contains("[wochen]") || paramName.toLowerCase().contains("[weeks]"))
      return Image(image: AssetImage('assets/image/time_symbol.png'));
    if(paramName.toLowerCase().contains("passwor") || paramName.toLowerCase().contains("kennwort"))
      return Image(image: AssetImage('assets/image/pwd_symbol.png'));
    if((paramName.toLowerCase().contains("fill level") || paramName.toLowerCase().contains("llstand")) && paramName.toLowerCase().contains("[%]"))
      return Image(image: AssetImage('assets/image/level_symbol.png'));
    if(paramName.toLowerCase().contains("[kPa]") || paramName.toLowerCase().contains("[Pa]") || paramName.toLowerCase().contains("[bar]"))
      return Image(image: AssetImage('assets/image/pressure_symbol.png'));

    if(paramName.toLowerCase().contains("[%]"))
      return Image(image: AssetImage('assets/image/percent_symbol.png'));
    return Image(image: AssetImage('assets/image/undef_symbol.png'));
  }

  String DevTypeToString(int devType, BuildContext context){
    switch(devType) {
      case 0: return "TTE-WEZ ("+AppLocalizations.of(context)!.tteTypeWEZ+")";
      case 1: return "TTE-SOL ("+AppLocalizations.of(context)!.tteTypeSOL+")";
      case 2: return "TTE-PS ("+AppLocalizations.of(context)!.tteTypePS+")";
      case 3: return "TTE-FW ("+AppLocalizations.of(context)!.tteTypeFW+")";
      case 4: return "TTE-HK/WW ("+AppLocalizations.of(context)!.tteTypeHKW+")";
      case 6: return "TTE-MWA ("+AppLocalizations.of(context)!.tteTypeMWA+")";
      case 7: return "TTE-GLT ("+AppLocalizations.of(context)!.tteTypeGLT+")";
      case 8: return "TTE-HV ("+AppLocalizations.of(context)!.tteTypeHV+")";
      case 16: return "TTE-BM ("+AppLocalizations.of(context)!.tteTypeBM+")";
      case 18: return "TTE-GW ("+AppLocalizations.of(context)!.tteTypeGW+")";
    }
    return AppLocalizations.of(context)!.devTypeUnknown;
  }

  Widget _buildList(context) {
    final parameterProvider = Provider.of<ParametersProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    return parameterProvider.length != 0
        ? RefreshIndicator(
      child:
      ListView.builder(
          padding: EdgeInsets.all(2),
          itemCount: parameterProvider.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: <Widget>[
                      ListTile(
                        leading: IconSelector(parameterProvider.parameters[index].name),
                        title: Text(parameterProvider.parameters[index].name),
                        subtitle: Text(DevTypeToString(parameterProvider.parameters[index].devType, context)),
                        trailing:
                          PopupMenuButton(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 30, maxWidth: 60, maxHeight: 40),
                              child:Text(ValueToDecodedValue(parameterProvider.parameters[index].value,
                                  parameterProvider.parameters[index].devType,
                                  parameterProvider.parameters[index].funcGroup,
                                  parameterProvider.parameters[index].funcNum,
                                  parameterProvider.parameters[index].id,
                                  context),
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(AppLocalizations.of(context)!.menuItemSetValue,
                                    style: TextStyle(color: Colors.black.withOpacity(parameterProvider.parameters[index].rw==2?1:0.2))),
                              ),
                              PopupMenuItem(
                                value: 'show_history',
                                child: Text(AppLocalizations.of(context)!.menuItemShowHist,style: TextStyle(color: Colors.black.withOpacity(double.tryParse(parameterProvider.parameters[index].value)!=null?1:0.2))),
                              )
                            ];
                          },
                          onSelected: (String value){
                            if(value=="edit" && parameterProvider.parameters[index].rw==2) {
                              showDialog(context: context,
                                  builder: (BuildContext context){
                                    return SetValueDialogBox(index:index,
                                        initialValue:parameterProvider.parameters[index].value,
                                        paramName:parameterProvider.parameters[index].name,
                                        devType:parameterProvider.parameters[index].devType,
                                        funcGroup:parameterProvider.parameters[index].funcGroup,
                                        funcNum:parameterProvider.parameters[index].funcNum,
                                        paramID:parameterProvider.parameters[index].id);
                                  }
                              );
                            }
                            if(value=="show_history") {
                              historyProvider.fetchHistory(index,
                                  parameterProvider.parameters[index].name,
                                  parameterProvider.parameters[index].devType,
                                  parameterProvider.parameters[index].funcGroup,
                                  parameterProvider.parameters[index].funcNum,
                                  parameterProvider.parameters[index].id);
                              if(double.tryParse(parameterProvider.parameters[index].value)!=null)
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return HistoryDialogBox(
                                          devType:parameterProvider.parameters[index].devType,
                                          funcGroup:parameterProvider.parameters[index].funcGroup,
                                          funcNum:parameterProvider.parameters[index].funcNum,
                                          paramID:parameterProvider.parameters[index].id
                                      );
                                    }
                                );
                            }
                          },
                        ),
                      )
                    ]
                  ),
              );
          }),
      onRefresh: parameterProvider.refreshValues,
    )
        : (parameterProvider.state=="search"?Center(child: CircularProgressIndicator()):
    parameterProvider.allUnused?
    Column(children: [
      SizedBox(height: 10,),
      Text(AppLocalizations.of(context)!.noParametersConfigured,textAlign: TextAlign.center,),
    ])
    :Column(
    children: [
      SizedBox(height: 10,),
      Text(
        AppLocalizations.of(context)!.cannotConnect,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),textAlign: TextAlign.center,
      ),
      SizedBox(height: 10,),
      Text(
        Settings.getValue<bool>('key-enable-ra',false)?
          AppLocalizations.of(context)!.youUseRemote:
          AppLocalizations.of(context)!.didInstalled,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10,),
      Text(
        Settings.getValue<bool>('key-enable-ra',false)?
          AppLocalizations.of(context)!.isRemoteAccessConfigured:
          AppLocalizations.of(context)!.didSetIPAddress +Settings.getValue<String>('key-ip-address-cgw','192.168.0.0') + ")?",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10,),
      Text(AppLocalizations.of(context)!.ifYes,textAlign: TextAlign.center,),
      ElevatedButton(onPressed: (){parameterProvider.fetchParameters(true);}, child: Text(AppLocalizations.of(context)!.tryToConnectAgain)),
    ]
    )
    );
  }

}