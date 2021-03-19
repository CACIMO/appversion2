import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'global.dart';

class TallaConfig extends StatefulWidget {
  @override
  _TallaConfig createState() => new _TallaConfig();
}

class _TallaConfig extends State<TallaConfig> {
  Map<String, bool> conf = {'CT': true, 'TG': true, 'CL': true, 'TL': true};
  List<String> talla = [];
  Map<String, bool> tallaCheks = {};
  TextEditingController controllersTL = TextEditingController();
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  void getInitialData() {
    getTalla();
  }

  void actionTl() {
    setState(() {
      conf['TL'] = !conf['TL'];
    });
  }

  void getTalla() {
    talla = [];
    tallaCheks = {};
    httpGet('talla', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          talla.add(item['titulo']);
          tallaCheks[item['titulo']] = item['active'];
        });
      });
    }).catchError((error) {
      print('Esto Fallo $error');
    });
  }

  void changeCheck(ctx, type, titulo, bool value, Function callback) {
    Map<String, String> rt = {
      'CT': 'categoria',
      'TG': 'tag',
      'CL': 'color',
      'TL': 'talla'
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

  void addData(type, ctx) {
    bool flag = false;

    if ((type == 'CT'
            ? controllersTL.text
            : (type == 'TG' ? controllersTL.text : controllersTL.text)) ==
        '') {
      flag = true;
      AlertMsg(ctx, 'E',
          'El Campo ${type == 'CT' ? 'Categoria' : (type == 'TL' ? 'Talla' : 'Tag')} esta vacio.');
    }

    if (!flag) {
      httpPost(type == 'CT' ? 'categoria' : (type == 'TL' ? 'talla' : 'tag'), {
        'titulo': (type == 'CT'
            ? controllersTL.text
            : (type == 'TL' ? controllersTL.text : controllersTL.text)),
        'active': 'true'
      }).then((resp) {
        AlertMsg(
                ctx,
                'S',
                type == 'CT'
                    ? 'Categoria Agregada'
                    : (type == 'TL' ? 'Talla Agregada' : 'Tag Agregado'))
            .then((value) {
          setState(() {
            controllersTL.text = '';
          });
          getTalla();
          Navigator.pop(ctx);
        });
      }).catchError((jsonError) {
        //print(jsonError);
        AlertMsg(ctx, 'E',
            'Error al crear ${type == 'CT' ? 'Categoria' : (type == 'TL' ? 'Talla' : 'Tag')}');
      });
    }
  }

  Future<void> alertAddCTTG(ctx, type, Function callback) async {
    return showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(
                type == 'CT'
                    ? 'Nueva Categoria'
                    : type == 'TL'
                        ? 'Nueva Talla'
                        : 'Nuevo Tag',
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 18)),
            content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .015),
                child: TextFormField(
                  maxLength: 20,
                  controller: type == 'CT'
                      ? controllersTL
                      : type == 'TL'
                          ? controllersTL
                          : controllersTL,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: type == 'CT'
                        ? 'Categoria'
                        : type == 'TL'
                            ? 'Talla'
                            : 'Tag',
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    hintText: type == 'CT'
                        ? 'Categoria'
                        : type == 'TL'
                            ? 'Talla'
                            : 'Tag',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                    fillColor: Color(0xFFEBEBEB),
                  ),
                ),
              ),
            ]))),
            actions: [
              ElevatedButton(
                onPressed: () => callback(type, ctx),
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
                                      onPressed: () => alertAddCTTG(ctx, 'TL', addData),
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
                                  child: Text('Tallas',
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
                              child: Text('TALLAS DISPONIBLES',
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
                                        children: talla.map((item) {
                              return Row(children: [
                                Expanded(
                                    flex: 2,
                                    child: Checkbox(
                                        onChanged: (val) {
                                          changeCheck(ctx, 'CT', item,
                                              !tallaCheks[item], () {
                                            setState(() {
                                              tallaCheks[item] =
                                                  !tallaCheks[item];
                                            });
                                          });
                                        },
                                        value: tallaCheks[item])),
                                Expanded(
                                    flex: 8,
                                    child: Text(item,
                                        style: TextStyle(
                                            fontFamily: 'Roboto-Light',
                                            fontSize: 18)))
                              ]);
                            }).toList())))
                          ])
                        ])))
                  ])
                ]))));
  }
}

/*
*
*
* */
