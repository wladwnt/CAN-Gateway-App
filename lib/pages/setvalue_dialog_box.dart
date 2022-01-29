import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';
import 'package:myhome_for_hoval_devices/providers/set_value.dart';
import 'package:myhome_for_hoval_devices/providers/parameters.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetValueDialogBox extends StatefulWidget {
  final String initialValue, paramName;
  final int index;
  final int devType, funcGroup, funcNum, paramID;
  final TextEditingController _controller = TextEditingController();
  int SelectedValue=0;
  SetValueDialogBox({Key? key, required this.index,
    required this.initialValue,
    required this.paramName,
    required this.devType,
    required this.funcGroup,
    required this.funcNum,
    required this.paramID}) : super(key: key);

  @override
  _SetValueDialogBoxState createState() => _SetValueDialogBoxState();
}

class _SetValueDialogBoxState extends State<SetValueDialogBox> {
  @override
  void initState() {
    super.initState();
    final setValueProvider = Provider.of<SetValueProvider>(context, listen:false);
    widget._controller.text=widget.initialValue;
    widget.SelectedValue = double.parse(widget.initialValue).toInt();
    setValueProvider.resetState();
  }

  @override
  Widget build(BuildContext context) {
    final setValueProvider = Provider.of<SetValueProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, setValueProvider),
    );
  }

  contentBox(context, setValueProvider){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20,top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.paramName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 10,),
              (ParamHasList(widget.devType, widget.funcGroup, widget.funcNum, widget.paramID, context))?
              DropdownButton<int>(
                value: widget.SelectedValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.SelectedValue = newValue!;
                    widget._controller.text=newValue.toString();
                  });
                },
                items: GetParamNonEmptyListIndexes(widget.devType, widget.funcGroup, widget.funcNum, widget.paramID, context)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(ValueToDecodedValue(value.toString(), widget.devType, widget.funcGroup, widget.funcNum, widget.paramID, context)),
                  );
                }).toList(),
              ):
              TextFormField(
                controller: widget._controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              (setValueProvider.state=="wait")?
              Text(AppLocalizations.of(context)!.waitReadingData, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,):
              (setValueProvider.state=="init")?
              Text((ParamHasList(widget.devType, widget.funcGroup, widget.funcNum, widget.paramID, context))?AppLocalizations.of(context)!.selectNewValue:AppLocalizations.of(context)!.enterNewValue, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,):
              (setValueProvider.state=="set")?
              Text(AppLocalizations.of(context)!.setRequestSuccessful, style: TextStyle(fontSize: 14, color: Colors.green),textAlign: TextAlign.center,):
              Text(AppLocalizations.of(context)!.tryAgain, style: TextStyle(fontSize: 14, color: Colors.red),textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: (setValueProvider.state=="init" || setValueProvider.state=="retry")?(){
                      setValueProvider.setValue(widget.index, widget._controller.text);
                      final parameterProvider = Provider.of<ParametersProvider>(context, listen: false);
                      parameterProvider.fetchValues();
                    }:null,
                    child: Text(AppLocalizations.of(context)!.setValue,style: TextStyle(fontSize: 16),)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.close,style: TextStyle(fontSize: 16),)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}