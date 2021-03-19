import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';
import 'datosCliente.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Carrito extends StatefulWidget {
  @override
  _Carrito createState() => new _Carrito();
}

class _Carrito extends State<Carrito> {
  @override
  void initState() {
    super.initState();
    getCarrito(this.context);
  }

  List prePed = [];

  final TextEditingController controllerBusq = TextEditingController();

  bool habilitarEdicion = true;

  Map carrito = {};

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void getCarrito(ctx) {
    httpGet('carrito', null).then((resp) {
      if (resp['data'].length > 0) {
        setState(() {
          carrito = resp['data'][0];
          prePed = carrito['producto'];
        });
      } else
        Toast.show("Carrito vacio", ctx,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((onError) {
      Toast.show("Error al cargar los productos", ctx,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
                                  child: Text('Carrito',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .06)))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: IconButton(
                                      onPressed: () => Navigator.push(
                                          ctx,
                                          MaterialPageRoute(builder: (ctx) => DatosCliente())),
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
                                  child: Text('Pre-Pedido',
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
                              child: Text('Productos',
                                  style: TextStyle(
                                      fontSize: ScQuery(ctx)['h'] * .03,
                                      fontFamily: 'Roboto-Light'))))
                    ]),
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
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
                                                      height: ScQuery(ctx)['h'] *
                                                          .15,
                                                      width: ScQuery(ctx)['h'] *
                                                          .15,
                                                      child: CachedNetworkImage(
                                                          width: ScQuery(ctx)['w'] *
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
                                                          ScQuery(ctx)['h'] *
                                                              .15,
                                                      child: Column(children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                                        // alignment: Alignment.centerRight,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                2,
                                                                            left:
                                                                                10,
                                                                            bottom:
                                                                                2),
                                                                        child: Text(
                                                                            Prod[
                                                                                'titulo'],
                                                                            style:
                                                                                TextStyle(fontSize: ScQuery(ctx)['h'] * .02, fontFamily: 'Roboto-Light'))))
                                                          ],
                                                        ),
                                                        Row(children: [
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                                                                            .all(4),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          16,
                                                                      width: 16,
                                                                      decoration: BoxDecoration(
                                                                          color: Color(int.parse(
                                                                              '0xFF${Colores['segundario'] == '' ? Colores['segundario'] : Colores['primario']}')),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(int.parse(
                                                                            '0xFF${Colores['primario']}')),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                  )
                                                                ])
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                        Row(children: [
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                                                                          left:
                                                                              2,
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
                                                                          border:
                                                                              Border.all(color: Colors.black54),
                                                                          borderRadius: BorderRadius.circular(5)))
                                                                ])
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                        Row(children: [
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom:
                                                                          5),
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
                            }))
                  ])
                ]))));
  }
}
