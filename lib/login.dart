import 'dart:async';
import 'package:amdbb/historial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cuenta.dart';
import 'catalogo.dart';
import 'global.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  final Map<String, TextEditingController> controllers = {
    'usuario': TextEditingController(),
    'password': TextEditingController(),
  };

  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }
  // ignore: non_constant_identifier_names
  String Permiso = '';

  iniciarSesion(ctx) async {
    bool flag = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> jsonAux = {
      'usuario': controllers['usuario'].text,
      'password':
          sha512.convert(utf8.encode(controllers['password'].text)).toString()
    };


    for (final key in jsonAux.keys) {
      if (jsonAux[key] == '') {
        flag = true;
        AlertMsg(ctx, 'E',
            'El Campo ${key[0].toUpperCase()}${key.substring(1)}\nEsta vacio.');

        break;
      }
    }
    //MenuData
    if (!flag) {
      httpPost('login', jsonAux).then((resp) {

        List aux = resp['data']['usuario'];
        if(aux.length == 0)throw '';
        AlertMsg(ctx, 'S', 'Usuario Validado').then((value) {
          prefs.setString('token', resp['data']['token']);
          prefs.setString('user',  resp['data']['usuario'][0]['_id']);
          prefs.setString('menu', jsonEncode(resp['data']['usuario'][0]['MenuData']));
          prefs.setString('Permiso', resp['data']['usuario'][0]['Permiso']);

          setState(() {
            menOptions =resp['data']['usuario'][0]['MenuData'];
            Permiso  =resp['data']['usuario'][0]['Permiso'];
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => (Permiso != '6050bc8b96f425bd7bf19d3c')?Catalogo():Historial()),
          );
        });
      }).catchError((jsonError) {
        String msgx = ('Datos incorrectos o Usuario inhabilitado.');
        AlertMsg(ctx, 'E', msgx);
      });
    }
  }
//
  @override
  Widget build(BuildContext context) {
    double widthApp = MediaQuery.of(context).size.width;
    double heightApp = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: SingleChildScrollView(
            padding:
                EdgeInsets.only(left: widthApp * .12, right: widthApp * .12),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: heightApp * .2),
                    child: Image.asset('images/logo.png')),
                Container(
                  child: TextFormField(
                    maxLength: 30,
                    controller: controllers['usuario'],
                    decoration: InputDecoration(
                      counterText:'' ,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Usuario',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: Color(0xFFEBEBEB),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightApp * .015),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 100,
                    controller: controllers['password'],
                    decoration: InputDecoration(
                      counterText:'' ,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEBEBEB), width: 1)),
                      hintText: 'Contraseña',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
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
                            iniciarSesion(context);
                          },
                          child: Container(
                            height: 52,
                            child: Center(
                                child: Text(
                              'Iniciar sesión',
                              style: TextStyle(fontSize: 15),
                            )),
                          ),
                        ))
                      ],
                    )),
                Divider(),
                Container(
                    margin: EdgeInsets.only(
                        top: heightApp * .015, bottom: heightApp * .05),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Cuenta()),
                            );
                          },
                          child: Container(
                            height: 52,
                            child: Center(
                                child: Text(
                              'Crear cuenta',
                              style: TextStyle(fontSize: 15),
                            )),
                          ),
                        ))
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
