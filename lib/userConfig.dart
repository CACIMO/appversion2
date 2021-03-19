import 'package:amdbb/perfil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catalogo.dart';
import 'global.dart';

class UserConfig extends StatefulWidget {
  @override
  _UserConfig createState() => new _UserConfig();
}

class _UserConfig extends State<UserConfig> {
  @override
  void initState() {
    super.initState();
    print('ejecuto1');
    getData();
  }


  List<Widget> usersW =[];
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AlertLoad(this.context, "Cargando Usuarios");
    List<Widget> cont = [];
    httpGet('usuario', null).then((resp) {
      List aux = resp['data'];
      aux.forEach((user) {

        String permiso = '';
        try{
          permiso='${user['Permisos'][0]['titulo']??''}';
        }catch(error){
          permiso ='';
        }
        cont.add(InkWell(
          onTap: () => Navigator.push(
              this.context, MaterialPageRoute(builder: (ctx) => Perfil(data:user['_id']))),
          child: Row(
            children: [
              Expanded(flex: 2, child: CircleAvatar()),
              Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text('NOMBRE: ',
                                      style: TextStyle(
                                          fontSize:
                                              ScQuery(this.context)['h'] * .017,
                                          color: Colors.black54,
                                          fontFamily: 'Roboto-Regular')),
                                )),
                            Expanded(
                                flex: 7,
                                child: Text(
                                    '${user['nombre']} ${user['apellido']}',
                                    style: TextStyle(
                                        fontSize:
                                            ScQuery(this.context)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')))
                          ])),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text('USUARIO: ',
                                      style: TextStyle(
                                          fontSize:
                                              ScQuery(this.context)['h'] * .017,
                                          color: Colors.black54,
                                          fontFamily: 'Roboto-Regular')),
                                )),
                            Expanded(
                                flex: 7,
                                child: Text('${user['usuario']}',
                                    style: TextStyle(
                                        fontSize:
                                            ScQuery(this.context)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')))
                          ])),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text('PERMISOS: ',
                                      style: TextStyle(
                                          fontSize:
                                              ScQuery(this.context)['h'] * .017,
                                          color: Colors.black54,
                                          fontFamily: 'Roboto-Regular')),
                                )),
                            Expanded(
                                flex: 7,
                                child: Text('$permiso',
                                    style: TextStyle(
                                        fontSize:
                                            ScQuery(this.context)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')))
                          ])),
                    ],
                  ))
            ],
          ),
        ));
        cont.add(Divider());
      });

      setState(() {
        usersW= cont;
      });
      Navigator.pop(this.context);
      /*AlertMsg(this.context, 'S', '${opciones[type]} Actualizado')
          .then((value) => Navigator.pop(this.context));*/
    }).catchError((onError) {
      print(onError);
      Navigator.pop(this.context);
    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() async{
    Navigator.push(
        this.context, MaterialPageRoute(builder: (ctx) => Catalogo()));
  }

  @override
  Widget build(BuildContext ctx) {
    return
      WillPopScope(
        onWillPop: _onBackPressed,
        child:
        Scaffold(
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
                                  child: Text('Usuarios',
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
                              child: Text('USUARIOS DISPONIBLES',
                                  style: TextStyle(
                                      fontFamily: 'Roboto-light',
                                      fontSize: ScQuery(ctx)['h'] * .015))))
                    ]),
                    Divider(),
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
                        padding: EdgeInsets.only(top: 2),
                        child:
                            SingleChildScrollView(child: Column(children: usersW)))
                  ])
                ])))));
  }
}
