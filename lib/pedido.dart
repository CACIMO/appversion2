import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';
import 'catalogo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Pedido extends StatefulWidget {
  final Map dataClient;

  const Pedido({Key key, this.dataClient}) : super(key: key);
  @override
  _Pedido createState() => new _Pedido(this.dataClient);
}

class _Pedido extends State<Pedido> {
  final Map dataClient;
  _Pedido(this.dataClient);

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  List prePed = [];
  Map carrito = {};
  int total = 0;

  Map<String, Map<String, String>> opciones = {
    'I': {'value': 'I', 'titulo': 'Seleccione una opcion'},
    'E': {'value': 'E', 'titulo': 'Efectivo'},
    'CE': {'value': 'CE', 'titulo': 'Contra Entrega'},
    'C': {'value': 'C', 'titulo': 'Consignacion'}
  };

  Future<String> getCsc() async {
    var data = await httpGet('csc', null);
    return data['data'][0]['csc'];
  }

  void getCarrito(ctx) {
    httpGet('carrito', null).then((resp) {
      if (resp['data'].length > 0) {
        setState(() {
          carrito = resp['data'][0];
          prePed = carrito['producto'];
        });
        int aux = 0;
        prePed.forEach((prod) {
          aux += (prod['cantidad'] * prod['valor']);
        });

        setState(() {
          total = aux;
        });
      } else
        Toast.show("Carrito vacio", ctx,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((onError) {
      Toast.show("Error al cargar los productos", ctx,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  void guardarFormato() async {
    Map<String, String> dataSend = this.dataClient;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usuario = prefs.getString('user') ?? 'Prueba';
    bool flag = true;
    String consec = await getCsc();
    dataSend['formato'] = 'FT$consec';
    dataSend['vendedor'] = usuario;

    if (consec == null) {
      flag = false;
      AlertMsg(this.context, 'E', 'Error al generar Consecutivo');
    }

    if (flag) {
      httpPost('formato', dataSend).then((resp) {
        AlertMsg(this.context, 'S',
                'Pedido Creado Correctamente\nFormato:${resp['data']['msg']}')
            .then((value) => Navigator.push(
                this.context, MaterialPageRoute(builder: (ctx) => Catalogo())));
      }).catchError((onError) {
        print(onError);
        AlertMsg(this.context, 'E', 'Error al Crear Pedido');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCarrito(this.context);
    print(this.dataClient);

    setState(() {
      total = 0;
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
                      height: ScQuery(ctx)['h'] * .15,
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              flex: 9,
                              child: Container(
                                  child: Text('Pedido',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .06)))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: IconButton(
                                      onPressed: () => guardarFormato(),
                                      icon: Icon(
                                        Icons.save_outlined,
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
                                  child: Text('Resumen de Venta',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Thin',
                                          fontSize: ScQuery(ctx)['h'] * .036))))
                        ]),
                        Divider()
                      ])),
                  Container(
                      height: ScQuery(ctx)['h'] * .26,
                      child: Column(children: [
                        Row(children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: ScQuery(ctx)['h'] * .005),
                            child: Text('NOMBRE DEL CLIENTE',
                                style: TextStyle(
                                    fontSize: ScQuery(ctx)['h'] * .016,
                                    color: Colors.black54,
                                    fontFamily: 'Roboto-Regular')),
                          )
                        ]),
                        Row(children: [
                          Container(
                            child: Text(
                                '${this.dataClient['nombre'].toString().toUpperCase()}',
                                style: TextStyle(
                                    fontSize: ScQuery(ctx)['h'] * .017,
                                    fontFamily: 'Roboto-Regular')),
                          )
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('DIRECCIÓN',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('TELEFONO',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                child: Text(
                                    '${this.dataClient['direccion'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                child: Text(
                                    '${this.dataClient['telefono'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('BARRIO',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('CIUDAD',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                child: Text(
                                    '${this.dataClient['barrio'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                child: Text(
                                    '${this.dataClient['ciudad'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('METODO DE PAGO',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScQuery(ctx)['h'] * .015,
                                    bottom: ScQuery(ctx)['h'] * .005),
                                child: Text('TOTAL',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .016,
                                        color: Colors.black54,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                child: Text(
                                    '${opciones[this.dataClient['pago']]['titulo'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                child: Text('${NumberFormat.simpleCurrency().format(total)}',
                                    style: TextStyle(
                                        fontSize: ScQuery(ctx)['h'] * .017,
                                        fontFamily: 'Roboto-Regular')),
                              ))
                        ]),
                        Divider()
                      ])),
                  Container(
                      height: ScQuery(ctx)['h'] * .53,
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 2),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: prePed.length,
                          itemBuilder: (context, i) {
                            var item = prePed[i];
                            //Obtener Titulo
                            // ignore: non_constant_identifier_names
                            Map Prod = carrito['Productos']
                                .where((e) => e['_id'] == item['id'])
                                .toList()[0];
                            // ignore: non_constant_identifier_names
                            Map Colores = carrito['Colores']
                                .where((e) => e['_id'] == item['color'])
                                .toList()[0];
                            // ignore: non_constant_identifier_names
                            Map Talla = carrito['Tallas']
                                .where((e) => e['_id'] == item['talla'])
                                .toList()[0];

                            return Container(
                                child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        height: ScQuery(ctx)['h'] * .15,
                                        //color: Colors.red,
                                        child: Column(children: [
                                          Row(children: [
                                            Expanded(
                                                flex: 3,
                                                child: Container(
                                                    height:
                                                        ScQuery(ctx)['h'] * .15,
                                                    width:
                                                        ScQuery(ctx)['h'] * .15,
                                                    child: CachedNetworkImage(
                                                        width:
                                                            ScQuery(ctx)['w'] *
                                                                .7,
                                                        height:
                                                            ScQuery(ctx)['w'] *
                                                                .7,
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        30),
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        imageUrl:
                                                            'http://3.138.111.218:3000/getimg/${Prod['_id']}'))),
                                            Expanded(
                                                flex: 7,
                                                child: Container(
                                                    height:
                                                        ScQuery(ctx)['h'] * .15,
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  // alignment: Alignment.centerRight,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              2,
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              2),
                                                                  child: Text(
                                                                      Prod[
                                                                          'titulo'],
                                                                      style: TextStyle(
                                                                          fontSize: ScQuery(ctx)['h'] *
                                                                              .02,
                                                                          fontFamily:
                                                                              'Roboto-Light'))))
                                                        ],
                                                      ),
                                                      Row(children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                'Color:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontFamily:
                                                                        'Roboto-Light'))),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  bottom: 5),
                                                          child: Column(
                                                            children: [
                                                              Row(children: [
                                                                Container(
                                                                  height: 16,
                                                                  width: 16,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4),
                                                                  child:
                                                                      Container(
                                                                    height: 16,
                                                                    width: 16,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(int.parse(
                                                                            '0xFF${Colores['segundario'] == '' ? Colores['segundario'] : Colores['primario']}')),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          int.parse(
                                                                              '0xFF${Colores['primario']}')),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                )
                                                              ])
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                      Row(children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                'Cantidad:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontFamily:
                                                                        'Roboto-Light'))),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                item['cantidad']
                                                                        .toString() ??
                                                                    '',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    fontFamily:
                                                                        'Roboto-Light')))
                                                      ]),
                                                      Row(children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                'Tallas:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontFamily:
                                                                        'Roboto-Light'))),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  bottom: 5),
                                                          child: Column(
                                                            children: [
                                                              Row(children: [
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        left: 2,
                                                                        right:
                                                                            2),
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            2),
                                                                    child: Text(
                                                                        Talla[
                                                                            'titulo'],
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto-Regular',
                                                                            fontSize: ScQuery(ctx)['h'] *
                                                                                .013)),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .black54),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)))
                                                              ])
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                      Row(children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                'Valor:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontFamily:
                                                                        'Roboto-Light'))),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: Text(
                                                                item['valor']
                                                                        .toString() ??
                                                                    '',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ScQuery(ctx)['h'] *
                                                                            .017,
                                                                    fontFamily:
                                                                        'Roboto-Light')))
                                                      ])
                                                    ])))
                                          ])
                                        ])))
                              ]),
                              Divider()
                            ]));
                          })),
                ]))));
  }
}
