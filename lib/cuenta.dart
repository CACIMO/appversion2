import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'global.dart';
import 'login.dart';
import 'package:crypto/crypto.dart';

class Cuenta extends StatefulWidget {
  @override
  _Cuenta createState() => new _Cuenta();
}

class _Cuenta extends State<Cuenta> {
  @override
  void initState() {
    super.initState();
  }

  final Map<String, TextEditingController> controllers = {
    'usuario': TextEditingController(),
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'documento': TextEditingController(),
    'telefono': TextEditingController(),
    'correo': TextEditingController(),
    'password': TextEditingController(),
  };

  // ignore: missing_return
  Future<bool> onBackPressed(ctx) {
    Navigator.of(ctx).pop();
  }

  crearUsuarioNuevo(ctx) {
    bool flag = false;
    Map<String, String> jsonAux = {
      'usuario': controllers['usuario'].text,
      'nombre': controllers['nombre'].text,
      'apellido': controllers['apellido'].text,
      'cedula': controllers['documento'].text,
      'telefono': controllers['telefono'].text,
      'correo': controllers['correo'].text,
      'password': controllers['password'].text
    };
    for (final key in jsonAux.keys) {
      if (jsonAux[key] == '') {
        flag = true;
        AlertMsg(ctx, 'E',
            'El Campo ${key[0].toUpperCase()}${key.substring(1)}\nEsta vacio.');

        break;
      }

      if (key == 'password')
        jsonAux[key] = sha512.convert(utf8.encode(jsonAux[key])).toString();
    }

    if (!flag) {
      httpPost('usuario', jsonAux).then((resp) {
        AlertMsg(ctx, 'S', 'Usuario creado correctamente.').then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => Login()),
          );
        });
      }).catchError((jsonError) {
        if (jsonError['err']['code'] == 11000)
          AlertMsg(ctx, 'E',
              'Sus datos han sido registrados.\nPor favor verfica los campos Usuario, Cedula y Correo');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthApp = MediaQuery.of(context).size.width;
    double heightApp = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
          body: SingleChildScrollView(
            padding:
                EdgeInsets.only(left: widthApp * .12, right: widthApp * .12),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: heightApp * .03),
                    child: Image.asset('images/logo.png')),
                Container(
                    //margin:EdgeInsets.only(top:heightApp*.015),
                    child: TextFormField(
                        maxLength: 30,
                        controller: controllers['usuario'],
                        autofocus: false,
                        decoration: InputDecoration(
                            counterText: "",
                            labelText: 'Usuario',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFEBEBEB), width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFEBEBEB), width: 1)),
                            hintText: 'Usuario',
                            hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                            // //filled: true,
                            fillColor: Color(0xFFEBEBEB)))),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    maxLength: 40,
                    controller: controllers['nombre'],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Nombres',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    maxLength: 40,
                    controller: controllers['apellido'],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Apellidos',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controllers['documento'],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Documento',
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Documento',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      //filled: true,
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: controllers['telefono'],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Telefono',
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Telefono',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      //filled: true,
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    maxLength: 100,
                    controller: controllers['correo'],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Correo',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      //filled: true,
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 100,
                    autofocus: false,
                    controller: controllers['password'],
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      //labelStyle: TextStyle(Color(0xFFEBEBEB)),
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Contraseña',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      //filled: true,
                      fillColor:
                          Color(0xFFEBEBEB), //,Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: heightApp * .015, bottom: heightApp * .05),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            crearUsuarioNuevo(context);
                          },
                          child: Container(
                            height: 52,
                            child: Center(
                                child: Text('Crear cuenta',
                                    style: TextStyle(fontSize: 15))),
                          ),
                        ))
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
