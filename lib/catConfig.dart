import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'global.dart';

class CatConfig extends StatefulWidget {
  @override
  _CatConfig createState() => new _CatConfig();
}

class _CatConfig extends State<CatConfig> {
  Map<String, bool> conf = {'CT': true};

  List<String> categorias = [];
  Map<String, bool> categoriasCheks = {};

  TextEditingController controllersCT = TextEditingController();

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  void getInitialData() {
    getCategory();
  }

  void actionCt() {
    setState(() {
      conf['CT'] = !conf['CT'];
    });
  }

  void getCategory() {
    categorias = [];
    categoriasCheks = {};
    httpGet('categoria', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          categorias.add(item['titulo']);
          categoriasCheks[item['titulo']] = item['active'];
        });
      });
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

    if (controllersCT.text == '') {
      flag = true;
      AlertMsg(ctx, 'E', 'El Campo Categoria esta vacio.');
    }

    if (!flag) {
      httpPost('categoria', {'titulo': controllersCT.text, 'active': 'true'})
          .then((resp) {
        AlertMsg(ctx, 'S', 'Categoria Agregada').then((value) {
          setState(() {
            controllersCT.text = '';
          });
          getCategory();
          Navigator.pop(ctx);
        });
      }).catchError((jsonError) {
        //print(jsonError);
        AlertMsg(ctx, 'E', 'Error al crear  Categoria');
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
                  controller: controllersCT,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                    hintText: 'Categoria',
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
            Container(width: ScQuery(ctx)['w'] * .70, child:menuOptions(ctx)),
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
                                      onPressed: () =>
                                          alertAddCTTG(ctx, 'CT', addData),
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
                                  child: Text('Categorias',
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
                              child: Text('CATEGORIAS DISPONIBLES',
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
                                child:Container(
                                    child: Column(
                                        children: categorias.map((item) {
                                          return Row(children: [
                                            Expanded(
                                                flex: 2,
                                                child: Checkbox(
                                                    onChanged: (val) {
                                                      changeCheck(ctx, 'CT', item,
                                                          !categoriasCheks[item],
                                                              () {
                                                            setState(() {
                                                              categoriasCheks[item] =
                                                              !categoriasCheks[
                                                              item];
                                                            });
                                                          });
                                                    },
                                                    value: categoriasCheks[item])),
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
