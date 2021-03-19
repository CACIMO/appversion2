import 'dart:async';
import 'dart:ui';
import 'global.dart';
import 'login.dart';
import 'Catalogo.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xfffafbfd),
      statusBarIconBrightness: Brightness.dark));
  runApp(new MaterialApp(
    theme: ThemeData(fontFamily: 'Roboto-Regular'),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

//State is information of the application that can change over time or when some actions are taken.
class _State extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    obtenerToken();
  }

  bool visibility = true;

  obtenerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String tk = prefs.getString('token');
    print(tk);

    httpGet('menutk', null).then((resp) {
      setState(() {
        menOptions = resp['data'][0]['MenuData'];
      });
      bool flag = tk == null ? true : false;

      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          visibility = !visibility;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (flag == true) ? Login() : Catalogo()),
        );
      });
    }).catchError((onError) {
      AlertMsg(this.context, 'E', 'Error al Generar el Menu').whenComplete(() =>
          Navigator.push(
              this.context, MaterialPageRoute(builder: (ctx) => Login())));
    });


  }

  @override
  Widget build(BuildContext context) {
    double widthApp = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xfffafbfd),
      //key: _scaffoldKey,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(widthApp * 0.1),
          child: AnimatedOpacity(
            opacity: visibility ? 1 : 0,
            duration: Duration(milliseconds: 500),
            child: Image.asset('images/logo.png'),
          ),
        ),
      ),
    );
  }
}
//Image.asset('images/logo.png')
