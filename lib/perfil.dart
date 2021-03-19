import 'package:amdbb/userConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';

class Perfil extends StatefulWidget {
  final data;
  const Perfil({Key key, this.data}) : super(key: key);
  @override
  _Perfil createState() => new _Perfil(this.data);
}

class _Perfil extends State<Perfil> {
  final userData;

  _Perfil(this.userData);
  Map aux = {};
  @override
  void initState() {
    super.initState();
    getUserById();
  }

  Map opciones = {
    'N': 'Nombre',
    'U': 'Usuario',
    'C': 'Correo',
    'T': 'Telefono',
    'P': 'Permiso',
  };

  String nombre = '';
  String cedula = '';
  String usuario = '';
  String telefono = '';
  String correo = '';
  // ignore: non_constant_identifier_names
  String Permisos = '';
  Map<String, TextEditingController> controllers = {
    'N': TextEditingController(),
    'U': TextEditingController(),
    'C': TextEditingController(),
    'T': TextEditingController(),
    'CD': TextEditingController(),
  };

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void _showModal(ctxs, type, data) {
    TextEditingController controller = TextEditingController();
    controller.text = data.toString();
    showModalBottomSheet<void>(
        context: ctxs,
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return Container(
              child: Container(
                  child: Column(children: [
                Row(children: [
                  Expanded(
                      child: Text('Editar ${opciones[type]}',
                          style: TextStyle(
                              fontFamily: 'Roboto-thin',
                              fontSize: ScQuery(ctx)['h'] * .025))),
                ]),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin:
                                EdgeInsets.only(top: ScQuery(ctx)['h'] * .03),
                            child: Container(
                                child: TextFormField(
                                    keyboardType: type == 'T'
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    maxLength: 30,
                                    controller: controller,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        labelText: '${opciones[type]}',
                                        labelStyle: TextStyle(
                                            fontSize: ScQuery(ctx)['h'] * .015),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFEBEBEB),
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFEBEBEB),
                                                width: 1)),
                                        hintText: '${opciones[type]}',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFAAAAAA),
                                            fontSize: ScQuery(ctx)['h'] * .015),
                                        // //filled: true,
                                        fillColor: Color(0xFFEBEBEB))))))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(
                      left: ScQuery(ctx)['w'] * .3,
                      right: ScQuery(ctx)['w'] * .3),
                  child: ElevatedButton(
                      onPressed: () => saveData(type, controller.text, null),
                      child: Container(
                          child: Center(
                              child: Text('Guardar',
                                  style: TextStyle(fontSize: 13))))),
                )
              ])),
              padding: EdgeInsets.all(ScQuery(ctx)['h'] * .03),
              height: ScQuery(ctx)['h'] * .3,
              decoration: BoxDecoration(
                  color: Color(0xfffafbfd),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )));
        });
  }

  Future<void> alertAddCTTG(ctx) async {
    return showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Tipo de Perfil',
                style: TextStyle(
                    fontFamily: 'Roboto-Thin',
                    fontSize: ScQuery(ctx)['h'] * .025)),
            content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(
                    left: ScQuery(ctx)['w'] * .1,
                    right: ScQuery(ctx)['w'] * .1),
                child: ElevatedButton(
                    onPressed: () =>
                        saveData('P', "6050ae3e96f425bd7bf19d3b", 'Vendedor'),
                    child: Container(
                        child: Center(
                            child: Text('Vendedor',
                                style: TextStyle(fontSize: 13))))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(
                    left: ScQuery(ctx)['w'] * .1,
                    right: ScQuery(ctx)['w'] * .1),
                child: ElevatedButton(
                    onPressed: () => saveData(
                        'P', '604f9fedaaa8ce91e788e21f', 'Administrador'),
                    child: Container(
                        child: Center(
                            child: Text('Administrador',
                                style: TextStyle(fontSize: 13))))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(
                    left: ScQuery(ctx)['w'] * .1,
                    right: ScQuery(ctx)['w'] * .1),
                child: ElevatedButton(
                    onPressed: () =>
                        saveData('P', "6050bc8b96f425bd7bf19d3c", 'Bodega'),
                    child: Container(
                        child: Center(
                            child: Text('Bodega',
                                style: TextStyle(fontSize: 13))))),
              ),
            ]))),
          );
        });
  }

  void saveData(type, info, text) async {
    String user = aux['_id'];
    setState(() {
      switch (type) {
        case 'N':
          nombre = info;
          break;
        case 'U':
          usuario = info;
          break;
        case 'T':
          telefono = info;
          break;
        case 'C':
          correo = info;
          break;
        case 'P':
          Permisos = text;
          break;
      }
    });

    httpPut('usuario', {'type': type, 'data': info, 'userId': user})
        .then((resp) {
      AlertMsg(this.context, 'S', '${opciones[type]} Actualizado')
          .then((value) => Navigator.pop(this.context));
    });
  }

  void getUserById() {
    httpPost('menuTk', {'userId': this.userData.toString()}).then((resp) {
      aux = resp['data'][0];
      print(aux);
      setState(() {
        nombre = aux['nombre'] ?? '';
        cedula = aux['cedula'].toString() ?? '';
        usuario = aux['usuario'] ?? '';
        telefono = aux['telefono'].toString() ?? '';
        correo = aux['correo'] ?? '';
        try {
          Permisos = aux['Permisos'][0]['titulo'] ?? '';
        } catch (e) {
          Permisos = '';
        }
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() async{
    Navigator.push(
        this.context, MaterialPageRoute(builder: (ctx) => UserConfig()));
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
                                  child: Text('Perfil',
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
                                  child: Text('Informacion Personal',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Thin',
                                          fontSize: ScQuery(ctx)['h'] * .04))))
                        ]),
                        Divider()
                      ])),
                  Column(children: [
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
                        padding: EdgeInsets.only(top: 5),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Row(children: [
                            Expanded(
                                child: Container(
                                    height: ScQuery(ctx)['h'] * .3,
                                    child: CircleAvatar(
                                      child: InkWell(
                                        onTap: () => print(''),
                                        child: Container(),
                                      ),
                                    )))
                          ]),
                          Divider(),
                          InkWell(
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Nombre ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(nombre,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                          InkWell(
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Cedula ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(cedula,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                          InkWell(
                            onTap: () => _showModal(ctx, 'U', usuario),
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Usuario ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(usuario,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                          InkWell(
                            onTap: () => _showModal(ctx, 'C', correo),
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Correo ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(correo,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                          InkWell(
                            onTap: () => _showModal(ctx, 'T', telefono),
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Telefono ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(telefono,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                          InkWell(
                            onTap: () => alertAddCTTG(ctx),
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: ScQuery(this.context)['h'] * .012,
                                    bottom: ScQuery(this.context)['h'] * .012),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Perfil ',
                                            style: TextStyle(
                                                fontSize:
                                                    ScQuery(this.context)['h'] *
                                                        .018,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Light')),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(Permisos,
                                          style: TextStyle(
                                              fontSize:
                                                  ScQuery(this.context)['h'] *
                                                      .015,
                                              fontFamily: 'Roboto-Light')))
                                ])),
                          ),
                          Divider(),
                        ])))
                  ])
                ])))));
  }
}
