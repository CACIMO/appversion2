import 'dart:io';
import 'package:amdbb/historial.dart';
import 'package:amdbb/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'carrito.dart';
import 'catalogo.dart';
import 'configuracion.dart';
import 'historial.dart';
import 'nuevoProducto.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
Map ScQuery(BuildContext ctx) {
  Map query = {
    'w': MediaQuery.of(ctx).size.width,
    'h': MediaQuery.of(ctx).size.height,
    'o': MediaQuery.of(ctx).orientation.index,
  };

  return query;
}

List menOptions = [];
Map<String, Widget> opciones = {
  "604f9cf5aaa8ce91e788e217": Catalogo(),
  "604f9cf5aaa8ce91e788e218": Carrito(),
  "604f9cf5aaa8ce91e788e219": NuevoProd(),
  "604f9cf5aaa8ce91e788e21a": Historial(),
  "604f9cf5aaa8ce91e788e21b": Catalogo(),
  "604f9cf5aaa8ce91e788e21c": Catalogo(),
  "604f9cf5aaa8ce91e788e21d": Configuracion()
};
String dataTest = '';
Map<String, Icon> iconsAlert = {
  'E': Icon(Icons.error_outline_outlined,
      size: 80, color: Color(0xFFff472f).withOpacity(.8)),
  'S': Icon(Icons.check_circle_outline_outlined,
      size: 80, color: Color(0xFF05b071).withOpacity(.8))
};
String urlDB = '3.138.111.218:3000';
// ignore: non_constant_identifier_names
Future<void> AlertMsg(ctx, type, msg) async {
  return showDialog<void>(
      //barrierDismissible: type == 'S'?false:true,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
          Row(children: [
            Expanded(
                child: Container(
                    alignment: Alignment.center, child: iconsAlert[type]))
          ]),
          Row(children: [
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto-Light', fontSize: 20))))
          ])
        ]))));
      });
}
// ignore: non_constant_identifier_names
Future<void> AlertLoad(ctx, msg) async {
  return showDialog<void>(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return new AlertDialog(
            content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
          Row(children: [
            Expanded(
                child: Container(
                    height: ScQuery(ctx)['h'] * .2,
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: ScQuery(ctx)['h'] * .1,
                        width: ScQuery(ctx)['h'] * .1,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue.withOpacity(0.25),
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.blue),
                        ))))
          ]),
          Row(children: [
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto-Light', fontSize: 20))))
          ])
        ]))));
      });
}

Future httpPost(urlRoute, Map<String, String> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tk = prefs.getString('token');
  final response = await http.post(Uri.http(urlDB, urlRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': tk
      },
      body: jsonEncode(data));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return Future.error(jsonDecode(response.body));
  }
}

Future httpPut(urlRoute, Map<String, String> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tk = prefs.getString('token');
  final response = await http.put(Uri.http(urlDB, urlRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': tk
      },
      body: jsonEncode(data));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return Future.error(jsonDecode(response.body));
  }
}

Future httpGet(urlRoute, Map<String, String> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tk = prefs.getString('token');
  final response = await http.get(Uri.http(urlDB, urlRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': tk
      });

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return Future.error(jsonDecode(response.body));
  }
}

Future httpPostFile(urlRoute, Map<String, String> data, File imgFile) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tk = prefs.getString('token');
  var headers = {'access-token': tk};
  var stream = new http.ByteStream(imgFile.openRead());
  var length = await imgFile.length();
  var uri = Uri.http(urlDB, urlRoute);
  var request = new http.MultipartRequest("POST", uri);
  request.headers.addAll(headers);
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(imgFile.path));
  request.files.add(multipartFile);
  request.fields.addAll(data);
  var response = await request.send();
  response.stream.transform(utf8.decoder).listen((value) {
    if (response.statusCode != 200)
      return Future.error('Error en el server');
    else
      return 'Poducto Creado Correctamente';
  });
}

void logOut(ctx) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => Login()));
}

Drawer menuOptions(ctx) {
    List<Widget> options = [Divider()];
    menOptions.forEach((op) {
      options.add(Container(
          height: 50,
          child: InkWell(
              onTap: () => (op['_id'] == '604f9cf5aaa8ce91e788e21e')
                  ? logOut(ctx)
                  : Navigator.push(ctx,
                      MaterialPageRoute(builder: (ctx) => opciones[op['_id']])),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Icon(
                            new IconData(op['icon'], fontFamily: 'MaterialIcons'),
                            color: Colors.black87,
                            size: 20))),
                Expanded(
                    flex: 9,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(op['titulo'],
                            style: TextStyle(
                                fontFamily: 'Roboto-Light', fontSize: 18))))
              ]))));
      options.add(Divider());
    });
    return Drawer(
        child: Container(
            padding: EdgeInsets.only(
                top: ScQuery(ctx)['h'] * .1,
                left: ScQuery(ctx)['w'] * .05,
                right: ScQuery(ctx)['w'] * .05),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Container(
                        child: Text('Menu de Opciones',
                            style: TextStyle(
                                fontFamily: 'Roboto-Light', fontSize: 30))))
              ]),
              Container(
                  height: ScQuery(ctx)['h'] * .7,
                  child: ListView(children: options)),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: ScQuery(ctx)['h'] * .09,
                    child: Text('Version 1.2',
                        style: TextStyle(
                            fontFamily: 'Roboto-Light', fontSize: 15)),
                    alignment: Alignment.center,
                  ))
                ],
              )
            ])));
}
