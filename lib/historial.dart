import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'resumen.dart';

class Historial extends StatefulWidget {
  @override
  _Historial createState() => new _Historial();
}

class _Historial extends State<Historial> {
  @override
  void initState() {
    super.initState();
    GetData();
  }

  bool viewVentas = false;
  List<Step> stepersD = [];
  int _currentStep = 0;

  final TextEditingController controllerBusq = TextEditingController();

  List<dynamic> formatos = [];

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void GetData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String permiso = prefs.getString('Permiso');
    permiso == '6050bc8b96f425bd7bf19d3c'?getFormatosAll():getFormatos();
  }

  void getFormatos() async {
    //print(DateTime.parse('2021-03-13T13:13:58.978Z'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');

    AlertLoad(this.context, "Cargando Historial");

    httpPost('getForm/null', {'vendedor': user}).then((resp) {

      Map<String, List> listFormt = {};
      resp['data'].forEach((data) {
        DateTime aux = DateTime.parse(data['fecha']);
        String time1 = '${aux.day}/${aux.month}/${aux.year}';
        bool flag = true;

        for (var key in listFormt.keys) {
          if (key == time1) {
            flag = false;
            listFormt[key].add(data);
            break;
          }
        }
        if (flag) listFormt[time1] = [data];
      });

      setState(() {
        stepersD = _stepsData(listFormt);
      });
      Navigator.pop(this.context);
    }).catchError((onError) {
      Navigator.pop(this.context);
      AlertMsg(this.context, 'E', 'Error al Cargar');
    });
  }

  void getFormatosAll() async {
    //print(DateTime.parse('2021-03-13T13:13:58.978Z'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');

    AlertLoad(this.context, "Cargando Historial");

    httpGet('formato',null).then((resp) {

      Map<String, List> listFormt = {};
      resp['data'].forEach((data) {
        DateTime aux = DateTime.parse(data['fecha']);
        String time1 = '${aux.day}/${aux.month}/${aux.year}';
        bool flag = true;

        for (var key in listFormt.keys) {
          if (key == time1) {
            flag = false;
            listFormt[key].add(data);
            break;
          }
        }
        if (flag) listFormt[time1] = [data];
      });

      setState(() {
        stepersD = _stepsData(listFormt);
      });
      Navigator.pop(this.context);
    }).catchError((onError) {
      Navigator.pop(this.context);
      AlertMsg(this.context, 'E', 'Error al Cargar');
    });
  }

  List<Step> _stepsData(Map<String, List> data) {
    List<Step> stepers = [];
    List<Widget> elements = [];
    data.forEach((String key, List forms) {
      elements = [];
      forms.forEach((info) {
        elements.add(Row(children: [
          Expanded(
              child: InkWell(
                  onTap: () => Navigator.push(
                      this.context,
                      MaterialPageRoute(
                          builder: (ctx) => Resumen(format: info['_id']))),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            child: Text('FORMATO: ',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    color: Colors.black54,
                                    fontFamily: 'Roboto-Regular')),
                          )),
                      Expanded(
                          flex: 7,
                          child: Text('${info['formato']}',
                              style: TextStyle(
                                  fontSize: ScQuery(this.context)['h'] * .017,
                                  fontFamily: 'Roboto-Regular')))
                    ]),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text('ETAPA: ',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    color: Colors.black54,
                                    fontFamily: 'Roboto-Regular'))),
                        Expanded(
                            flex: 7,
                            child: Text(
                                '${info['Etapa'][0]['titulo'].toString().toUpperCase()}',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    fontFamily: 'Roboto-Regular')))
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text('TOTAL: ',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    color: Colors.black54,
                                    fontFamily: 'Roboto-Regular'))),
                        Expanded(
                            flex: 7,
                            child: Text(
                                '${NumberFormat.simpleCurrency().format(info['total'])}',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    fontFamily: 'Roboto-Regular')))
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text('F. PAGO: ',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    color: Colors.black54,
                                    fontFamily: 'Roboto-Regular'))),
                        Expanded(
                            flex: 7,
                            child: Text(
                                '${info['FPago'][0]['titulo'].toString().toUpperCase()}',
                                style: TextStyle(
                                    fontSize: ScQuery(this.context)['h'] * .017,
                                    fontFamily: 'Roboto-Regular')))
                      ]),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(children: [
                          Expanded(
                              flex: 3,
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text('CLIENTE: ',
                                      style: TextStyle(
                                          fontSize:
                                              ScQuery(this.context)['h'] * .017,
                                          color: Colors.black54,
                                          fontFamily: 'Roboto-Regular')))),
                          Expanded(
                              flex: 7,
                              child: Text(
                                  '${info['nombre'].toString().toUpperCase()}',
                                  style: TextStyle(
                                      fontSize:
                                          ScQuery(this.context)['h'] * .017,
                                      fontFamily: 'Roboto-Regular')))
                        ])),
                    Divider()
                  ])))
        ]));
      });

      stepers.add(Step(
          title: Text(key,
              style: TextStyle(
                  fontSize:
                  ScQuery(this.context)['h'] * .028,
                  fontFamily: 'Roboto-Regular')),
          content: Container(
              child: Column(children: [
            Divider(),
            Row(children: [
              Expanded(
                  child: Container(
                      child: Column(children: [
                Container(child: Container(child: Column(children: elements)))
              ])))
            ])
          ]))));
    });
    setState(() {
      if(data.keys.length > 0)viewVentas = true;
    });
    return stepers;
  }

  void _tapped(step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        key: scafoldKey,
        drawer:
            Container(width: ScQuery(ctx)['w'] * .70, child:menuOptions(ctx)),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    top: ScQuery(ctx)['h'] * .05,
                    left: ScQuery(ctx)['w'] * .05,
                    right: ScQuery(ctx)['w'] * .05),
                child: Column(children: [
                  Container(
                      height: ScQuery(ctx)['h'] * .15,
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              flex: 9,
                              child: Container(
                                  child: Text('Ventas',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .06)))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: IconButton(
                                      onPressed: () {
                                        scafoldKey.currentState.openDrawer();
                                      },
                                      icon: Icon(
                                        Icons.menu,
                                        size: 18,
                                      ))))
                        ]),
                        Row(children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: ScQuery(ctx)['w'] * .01),
                                  child: Text('Historial de Ventas',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Thin',
                                          fontSize: ScQuery(ctx)['h'] * .04))))
                        ])
                      ])),
                  Divider(),
                  Column(children: [
                    Row(children: [
                      Expanded(
                          child: Container(
                              height: ScQuery(ctx)['h'] * .77,
                              child: !viewVentas
                                  ? Container()
                                  : Stepper(
                                      onStepTapped: (step) => _tapped(step),
                                      currentStep: _currentStep,
                                      controlsBuilder: (BuildContext context,
                                          {VoidCallback onStepContinue,
                                          VoidCallback onStepCancel}) {
                                        return Container();
                                      },
                                      steps: stepersD)))
                    ])
                  ])
                ]))));
  }
}
