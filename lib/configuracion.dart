import 'package:amdbb/catConfig.dart';
import 'package:amdbb/tagConfig.dart';
import 'package:amdbb/tallaConfig.dart';
import 'package:amdbb/userConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colorConfig.dart';
import 'global.dart';

class Configuracion extends StatefulWidget {
  @override
  _Configuracion createState() => new _Configuracion();
}

class _Configuracion extends State<Configuracion> {

  @override
  void initState() {
    super.initState();
  }
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();



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
                              flex: 9,
                              child: Container(
                                  child: Text('Configuracion',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .05)))),

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
                                  child: Text('Parametrizacion',
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
                              child: Text('MENU DE OPCIONES',
                                  style: TextStyle(
                                      fontFamily: 'Roboto-light',
                                      fontSize: ScQuery(ctx)['h'] * .015))))
                    ]),
                    Divider(),
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
                        padding: EdgeInsets.only(top:2),
                        child:SingleChildScrollView(
                            child: Column(children: [
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => ConfigColor())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.color_lens_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Colores',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => CatConfig())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.category_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Categorias',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => TagConfig())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.tag,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Tags',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => TallaConfig())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.present_to_all_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Tallas',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => UserConfig())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.supervised_user_circle_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Usuarios',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              /*
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => ConfigColor())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.settings_applications_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Colores',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => ConfigColor())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.settings_applications_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Colores',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              Container(
                                  height: 50,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (ctx) => ConfigColor())),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Icon(
                                                    Icons.settings_applications_outlined,
                                                    color: Colors.black87,
                                                    size: 20))),
                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('Colores',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto-Light',
                                                        fontSize: 18))))
                                      ]))),
                              Divider(),
                              */
                            ])))
                  ])
                ]))));
  }

}

/*
*
*
* */
