import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'global.dart';

class ConfigColor extends StatefulWidget {
  @override
  _ConfigColor createState() => new _ConfigColor();
}

class _ConfigColor extends State<ConfigColor> {
  Map<String, bool> conf = {'CL': true};

  List<String> color = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> ColorsCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, List<String>> Combs = {};

  TextEditingController controllersCL = TextEditingController();
  TextEditingController controllersPR = TextEditingController();
  TextEditingController controllersSG = TextEditingController();
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  void getInitialData() {
    getColor();
  }

  void actionCl() {
    setState(() {
      conf['CL'] = !conf['CL'];
    });
  }

  void getColor() {
    color = [];
    ColorsCheks = {};
    Combs = {};
    httpGet('color', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          color.add(item['titulo']);
          ColorsCheks[item['titulo']] = item['active'];
          Combs[item['titulo']] = [item['primario'], item['segundario']];
          // categoriasCheks.add(new );
        });
      });
    });
  }

  void changeCheck(ctx, type, titulo, bool value, Function callback) {
    Map<String, String> rt = {
      'CL': 'color',
    };
    httpPut(rt[type], {'titulo': titulo, 'active': value.toString()})
        .then((resp) {
      callback();
      Toast.show("${value ? 'Activado' : 'Desactivado'} Correctamente", ctx,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }).catchError((jsonError) {
      Toast.show("Error en el servidor", ctx,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  void addColor(ctx) {
    bool flag = false;

    if (controllersPR.text == '' || controllersCL.text == '') {
      flag = true;
      AlertMsg(ctx, 'E', 'El Campo Color Primario o Titulo estan vacio.');
    }
    if (!flag) {
      httpPost('color', {
        'titulo': controllersCL.text,
        'primario': controllersPR.text,
        'segundario': controllersSG.text ?? '',
        'active': 'true'
      }).then((resp) {
        AlertMsg(ctx, 'S', 'Color Agregado').then((value) {
          setState(() {
            controllersPR.text = '';
            controllersSG.text = '';
            controllersCL.text = '';
          });
          getColor();
          Navigator.pop(ctx);
        });
      }).catchError((jsonError) {
        print(jsonError);
        AlertMsg(ctx, 'E', 'Error al crear Color');
      });
    }
  }

  Future<void> alertAddColor(ctx, Function callback) async {
    return showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Nuevo Color',
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 18)),
            content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .015),
                child: TextFormField(
                  maxLength: 20,
                  controller: controllersCL,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Titulo',
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    hintText: 'Titulo',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                    fillColor: Color(0xFFEBEBEB),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .015),
                child: TextFormField(
                  maxLength: 20,
                  controller: controllersPR,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Color Primario',
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    hintText: 'Hexa Color',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                    fillColor: Color(0xFFEBEBEB),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .015),
                child: TextFormField(
                  maxLength: 20,
                  controller: controllersSG,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Color Segundario',
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    hintText: 'Hexa Color',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                    fillColor: Color(0xFFEBEBEB),
                  ),
                ),
              ),
            ]))),
            actions: [
              ElevatedButton(
                onPressed: () => callback(ctx),
                child: Container(
                  child: Center(
                      child: Text('Guardar', style: TextStyle(fontSize: 13))),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        key: scafoldKey,
        drawer:
            Container(width: ScQuery(ctx)['w'] * .70, child: menuOptions(ctx)),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    top: ScQuery(ctx)['h'] * .05,
                    left: ScQuery(ctx)['w'] * .05,
                    right: ScQuery(ctx)['w'] * .05),
                child: Column(children: [
                  Container(
                      //padding: EdgeInsets.only(top: ScQuery(ctx)['h'] * .05),
                      height: ScQuery(ctx)['h'] * .15,
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              flex: 7,
                              child: Container(
                                  child: Text('Configuracion',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .05)))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: IconButton(
                                      onPressed: () =>alertAddColor(ctx, addColor),
                                      icon: Icon(
                                        Icons.add_outlined,
                                        size: 18,
                                      )))),
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
                                  child: Text('Colores',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Thin',
                                          fontSize: ScQuery(ctx)['h'] * .04))))
                        ]),
                        Divider()
                      ])),
                  Column(children: [
                    Row(children: [
                      Expanded(
                          child: Container(
                              child: Text('COLORES DISPONIBLES',
                                  style: TextStyle(
                                      fontFamily: 'Roboto-light',
                                      fontSize: ScQuery(ctx)['h'] * .015))))
                    ]),
                    Divider(),
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Row(children: [
                            Expanded(
                                child: Container(
                                    child: Column(
                                        children: color.map((item) {
                                          return Row(children: [
                                            Expanded(
                                                flex: 2,
                                                child: Checkbox(
                                                    onChanged: (val) {
                                                      changeCheck(ctx, 'CL', item,
                                                          !ColorsCheks[item], () {
                                                            setState(() {
                                                              ColorsCheks[item] =
                                                              !ColorsCheks[item];
                                                            });
                                                          });
                                                    },
                                                    value: ColorsCheks[item])),
                                            Expanded(
                                                flex: 6,
                                                child: Text(item,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))),
                                            Container(
                                              width: 40,
                                              height: 40,
                                              child: Card(
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Color(int.parse(
                                                              '0xFF${Combs[item][0]}')),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(int.parse(
                                                                  '0xFF${(Combs[item][1] == '') ? Combs[item][0] : Combs[item][1]}')),
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  25)))),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                            )
                                          ]);
                                        }).toList())))
                          ]),
                        ])))
                  ])
                ]))));
  }
}

/*
*
*
* */
