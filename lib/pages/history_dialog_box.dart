import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myhome_for_hoval_devices/providers/history.dart';
import 'package:myhome_for_hoval_devices/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDialogBox extends StatefulWidget {
  final int devType, funcGroup, funcNum, paramID;
  const HistoryDialogBox({Key? key,
  required this.devType,
  required this.funcGroup,
  required this.funcNum,
  required this.paramID}) : super(key: key);

  @override
  _HistoryDialogBoxState createState() => _HistoryDialogBoxState();
}

class _HistoryDialogBoxState extends State<HistoryDialogBox> {
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, historyProvider, DateTime.now().millisecondsSinceEpoch),
    );
  }
  List<FlSpot> getData(List<String> x, List<String> y){
    List<FlSpot> spotList = [];
    for (int i = 0; i < x.length; i++) {
      spotList.add(FlSpot(double.parse(x[i]), double.parse(y[i])));
    }
    return spotList;
  }
  contentBox(context, historyProvider, int currentDatetime){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10,top: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,5),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(historyProvider.history.paramName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 10,),
              (historyProvider.state=="wait")?
              Text(AppLocalizations.of(context)!.waitReadingData, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,):
              SizedBox(height: 200,
                  child: LineChart(
                LineChartData(
                    lineBarsData: [LineChartBarData(
                        spots: getData(historyProvider.history.xValues,historyProvider.history.yValues),
                    ),],
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      rotateAngle: -90,
                      reservedSize: 73,
                      interval: (double.parse(historyProvider.history.xValues.last)-double.parse(historyProvider.history.xValues[0]))/9,
                      getTitles: (value) {
                        int _offset = currentDatetime-double.parse(historyProvider.history.xValues.last).toInt()*1000;
                        return DateFormat('dd.MM.yy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(value.toInt()*1000+_offset));
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      reservedSize: (ParamHasList(widget.devType, widget.funcGroup, widget.funcNum, widget.paramID, context)?60:30),
                      getTitles: (value) {
                        return ValueToDecodedValue(value.toString(),
                            historyProvider.history.devType,
                            historyProvider.history.funcGroup,
                            historyProvider.history.funcNum,
                            historyProvider.history.id,
                            context);
                      },
                    ),
                  ),
                ),
              )
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