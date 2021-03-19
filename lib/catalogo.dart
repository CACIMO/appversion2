import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'global.dart';
import 'producto.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Catalogo extends StatefulWidget {
  @override
  _Catalogo createState() => new _Catalogo();
}

class _Catalogo extends State<Catalogo> {
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  final TextEditingController controllerBusq = TextEditingController();

  Map<String, bool> conf = {'CT': true, 'TG': true, 'CL': true, 'TL': true};

  List<String> color = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> ColorsCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> ColorsId = {};
  // ignore: non_constant_identifier_names
  Map<String, List<String>> Combs = {};
  // ignore: non_constant_identifier_names
  List ColorsIdSelect = [];

  // ignore: non_constant_identifier_names
  List<String> tallas = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> tallasCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> tallasId = {};
  List tallasIdSelect = [];

  bool habilitarEdicion = true;

  List<String> categorias = [];
  Map<String, bool> categoriasCheks = {};
  Map<String, String> categoriasId = {};
  List categoriasIdSelect = [];

  List<String> tags = [];
  Map<String, bool> tagCheks = {};
  Map<String, String> tagId = {};
  List tagIdSelect = [];

  List<dynamic> productos = [];

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void getProduct(ctx, prod) {
    Map<String, String> params = {
      'cat': jsonEncode(categoriasIdSelect),
      'col': jsonEncode(ColorsIdSelect),
      'tag': jsonEncode(tagIdSelect),
      'tal': jsonEncode(tallasIdSelect),
    };

    httpPut('producto/${(prod == null || prod == '') ? 'null' : prod}', params)
        .then((resp) {
      setState(() {
        productos = resp['data'];
      });
    }).catchError((onError) {
      print(onError);
      Toast.show("Error al cargar los productos", ctx,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  void _showModal(ctxs, data) {
    showModalBottomSheet<void>(
        context: ctxs,
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return Producto(data: data);
        });
  }

  void getInitialData() async{
    getCategory();
    getColor();
    getTag();
    getTalla();
    getProduct(context, null);
  }

  void actionTg() {
    setState(() {
      conf['TG'] = !conf['TG'];
    });
  }

  void actionCt() {
    setState(() {
      conf['CT'] = !conf['CT'];
    });
  }

  void actionCl() {
    setState(() {
      conf['CL'] = !conf['CL'];
    });
  }

  void actionTl() {
    setState(() {
      conf['TL'] = !conf['TL'];
    });
  }

  void getCategory() {
    categorias = [];
    categoriasCheks = {};
    categoriasId = {};
    httpGet('categoria', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          categorias.add(item['titulo']);
          categoriasCheks[item['titulo']] = false;
          categoriasId[item['titulo']] = item['_id'];
        });
      });
    });
  }

  void getTalla() {
    tallas = [];
    tallasCheks = {};
    tallasId = {};
    httpGet('talla', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          tallas.add(item['titulo']);
          tallasCheks[item['titulo']] = false;
          tallasId[item['titulo']] = item['_id'];
        });
      });
    });
  }

  void getTag() {
    tags = [];
    tagCheks = {};
    tagId = {};
    httpGet('tag', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          tags.add(item['titulo']);
          tagCheks[item['titulo']] = false;
          tagId[item['titulo']] = item['_id'];
        });
      });
    }).catchError((error) {
      print('Esto Fallo $error');
    });
  }

  void getColor() {
    color = [];
    ColorsCheks = {};
    Combs = {};
    ColorsId = {};
    httpGet('color', null).then((resp) {
      setState(() {
        List data = resp['data'];
        data.forEach((item) {
          color.add(item['titulo']);
          ColorsCheks[item['titulo']] = false;
          Combs[item['titulo']] = [item['primario'], item['segundario']];
          ColorsId[item['titulo']] = item['_id'];
        });
      });
    });
  }

  void changeCheck(ctx, type, titulo, bool value, Function callback) {
    callback();
    ColorsIdSelect = [];
    categoriasIdSelect = [];
    tagIdSelect = [];
    tallasIdSelect = [];

    ColorsCheks.forEach((key, value) {
      if (value) ColorsIdSelect.add(ColorsId[key]);
    });
    categoriasCheks.forEach((key, value) {
      if (value) categoriasIdSelect.add(categoriasId[key]);
    });

    tallasCheks.forEach((key, value) {
      if (value) tallasIdSelect.add(tallasId[key]);
    });

    tagCheks.forEach((key, value) {
      if (value) tagIdSelect.add(tagId[key]);
    });

    getProduct(ctx, null);

    Toast.show("${value ? 'Activado' : 'Desactivado'} Correctamente", ctx,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext ctx) {
    //if (!scafoldKey.currentState.isEndDrawerOpen) print(true);
    return Scaffold(
        key: scafoldKey,
        drawer:
            Container(width: ScQuery(ctx)['w'] * .70, child:menuOptions(ctx)),
        endDrawer: Container(
            width: ScQuery(ctx)['w'] * .70,
            child: Drawer(
                child: Container(
                    padding: EdgeInsets.only(
                        top: ScQuery(ctx)['h'] * .1,
                        left: ScQuery(ctx)['w'] * .05,
                        right: ScQuery(ctx)['w'] * .05),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: Container(
                                child: Text('Filtros de Busqueda',
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Light',
                                        fontSize: 30))))
                      ]),
                      Container(
                          height: ScQuery(ctx)['h'] * .8,
                          child: ListView(children: [
                            Row(children: [
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: Text('Colores',
                                          style: TextStyle(
                                              fontFamily: 'Roboto-Light',
                                              fontSize: 20)))),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: IconButton(
                                          icon: Icon((conf['CL'])
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up),
                                          onPressed: () => actionCl()))),
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Visibility(
                                      visible: !conf['CL'],
                                      child: Container(
                                          child: Column(
                                              children: color.map((item) {
                                        return Row(children: [
                                          Expanded(
                                              flex: 2,
                                              child: Checkbox(
                                                  onChanged: (val) {
                                                    changeCheck(ctx, 'CL', item,
                                                        !ColorsCheks[item], () {
                                                      setState(() {
                                                        ColorsCheks[item] =
                                                            !ColorsCheks[item];
                                                      });
                                                    });
                                                  },
                                                  value: ColorsCheks[item])),
                                          Expanded(
                                              flex: 6,
                                              child: Text(item,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Roboto-Light',
                                                      fontSize: 18))),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            child: Card(
                                                child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            '0xFF${Combs[item][0]}')),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(int.parse(
                                                                '0xFF${(Combs[item][1] == '') ? Combs[item][0] : Combs[item][1]}')),
                                                            borderRadius:
                                                                BorderRadius.circular(20)))),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                          )
                                        ]);
                                      }).toList()))))
                            ]),
                            Row(children: [
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: Text('Talla',
                                          style: TextStyle(
                                              fontFamily: 'Roboto-Light',
                                              fontSize: 20)))),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: IconButton(
                                          icon: Icon((conf['TL'])
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up),
                                          onPressed: () => actionTl()))),
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Visibility(
                                      visible: !conf['TL'],
                                      child: Container(
                                          child: Column(
                                              children: tallas.map((item) {
                                        return Row(children: [
                                          Expanded(
                                              flex: 2,
                                              child: Checkbox(
                                                  onChanged: (val) {
                                                    changeCheck(ctx, 'TL', item,
                                                        !tallasCheks[item], () {
                                                      setState(() {
                                                        tallasCheks[item] =
                                                            !tallasCheks[item];
                                                      });
                                                    });
                                                  },
                                                  value: tallasCheks[item])),
                                          Expanded(
                                              flex: 8,
                                              child: Text(item,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Roboto-Light',
                                                      fontSize: 18)))
                                        ]);
                                      }).toList()))))
                            ]),
                            Row(children: [
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: Text('Categorias',
                                          style: TextStyle(
                                              fontFamily: 'Roboto-Light',
                                              fontSize: 20)))),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: IconButton(
                                          icon: Icon((conf['CT'])
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up),
                                          onPressed: () => actionCt()))),
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Visibility(
                                      visible: !conf['CT'],
                                      child: Container(
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
                                                  value:
                                                      categoriasCheks[item])),
                                          Expanded(
                                              flex: 8,
                                              child: Text(item,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Roboto-Light',
                                                      fontSize: 18)))
                                        ]);
                                      }).toList()))))
                            ]),
                            Row(children: [
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: Text('Tags',
                                          style: TextStyle(
                                              fontFamily: 'Roboto-Light',
                                              fontSize: 20)))),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScQuery(ctx)['w'] * .01,
                                          bottom: ScQuery(ctx)['w'] * .03),
                                      child: IconButton(
                                          icon: Icon((conf['TG'])
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up),
                                          onPressed: () => actionTg()))),
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Visibility(
                                      visible: !conf['TG'],
                                      child: Container(
                                          child: Column(
                                              children: tags.map((item) {
                                        return Row(children: [
                                          Expanded(
                                              flex: 2,
                                              child: Checkbox(
                                                  onChanged: (val) {
                                                    changeCheck(ctx, 'TG', item,
                                                        !tagCheks[item], () {
                                                      setState(() {
                                                        tagCheks[item] =
                                                            !tagCheks[item];
                                                      });
                                                    });
                                                  },
                                                  value: tagCheks[item])),
                                          Expanded(
                                              flex: 8,
                                              child: Text(item,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Roboto-Light',
                                                      fontSize: 18)))
                                        ]);
                                      }).toList()))))
                            ])
                          ]))
                    ])))),
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
                                  child: Text('Catalogo',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .06)))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: IconButton(
                                      onPressed: () => scafoldKey.currentState
                                          .openEndDrawer(),
                                      icon: Icon(
                                        Icons.tune_outlined,
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
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 3,
                          child: Center(
                            child: Container(
                                child: Row(children: [
                              Container(
                                //padding: EdgeInsets.only(left: 1),
                                width: ScQuery(ctx)['w'] * .8,
                                child: TextFormField(
                                    autofocus: false,
                                    maxLength: 100,
                                    controller: controllerBusq,
                                    onChanged: (val) {
                                      getProduct(ctx, controllerBusq.text);
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search_outlined,
                                            color: Color(0xFFAAAAAA), size: 20),
                                        counterText: '',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1)),
                                        hintText: 'Busqueda',
                                        hintStyle:
                                            TextStyle(color: Color(0xFFAAAAAA)),
                                        //filled: true,
                                        fillColor: Color(0xFFEBEBEB))),
                              )
                            ])),
                          ))),
                  Divider(),
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
                        height: ScQuery(ctx)['h'] * .64,
                        child: ListView(
                            padding: EdgeInsets.only(top: 2),
                            shrinkWrap: true,
                            primary: false,
                            children: productos.map((producto) {
                              List<Widget> colores = [];
                              List<Widget> tallas = [];

                              producto['colorData'].forEach((color) {
                                colores.add(Container(
                                  height: 16,
                                  width: 16,
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    height: 16,
                                    width: 16,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            '0xFF${color['segundario'] == '' ? color['segundario'] : color['primario']}')),
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(int.parse(
                                          '0xFF${color['primario']}')),
                                      borderRadius: BorderRadius.circular(8)),
                                ));
                              });

                              producto['tallaData'].forEach((talla) {
                                tallas.add(Container(
                                    padding: EdgeInsets.only(left: 2, right: 2),
                                    margin: EdgeInsets.only(left: 2),
                                    child: Text(talla['titulo'],
                                        style: TextStyle(
                                            fontFamily: 'Roboto-Regular',
                                            fontSize:
                                                ScQuery(ctx)['h'] * .013)),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black54),
                                        borderRadius:
                                            BorderRadius.circular(5))));
                              });

                              return InkWell(
                                  onTap: () {
                                    _showModal(ctx, producto);
                                  },
                                  child: Container(
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
                                                              ScQuery(ctx)['h'] *
                                                                  .15,
                                                          width:
                                                              ScQuery(ctx)['h'] *
                                                                  .15,
                                                          child: CachedNetworkImage(
                                                              width:
                                                                  ScQuery(ctx)['w'] *
                                                                      .7,
                                                              height:
                                                                  ScQuery(ctx)[
                                                                          'w'] *
                                                                      .7,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(30),
                                                                      child: CircularProgressIndicator()),
                                                              imageUrl: 'http://3.138.111.218:3000/getimg/${producto['_id']}'))),
                                                  Expanded(
                                                      flex: 7,
                                                      child: Container(
                                                          height: ScQuery(
                                                                  ctx)['h'] *
                                                              .15,
                                                          child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                            // alignment: Alignment.centerRight,
                                                                            padding: EdgeInsets.only(top: 2, left: 10, bottom: 2),
                                                                            child: Text(producto['titulo'], style: TextStyle(fontSize: ScQuery(ctx)['h'] * .02, fontFamily: 'Roboto-Light'))))
                                                                  ],
                                                                ),
                                                                Row(children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          'Color:',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              color: Colors.black54,
                                                                              fontFamily: 'Roboto-Light'))),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            5),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                            children:
                                                                                colores)
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]),
                                                                Row(children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          'Cantidad:',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              color: Colors.black54,
                                                                              fontFamily: 'Roboto-Light'))),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          producto['stock'].toString() ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              fontFamily: 'Roboto-Light')))
                                                                ]),
                                                                Row(children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          'Tallas:',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              color: Colors.black54,
                                                                              fontFamily: 'Roboto-Light'))),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            5),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                            children:
                                                                                tallas)
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]),
                                                                Row(children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          'Valor:',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              color: Colors.black54,
                                                                              fontFamily: 'Roboto-Light'))),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          producto['valor'].toString() ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontSize: ScQuery(ctx)['h'] * .017,
                                                                              fontFamily: 'Roboto-Light')))
                                                                ])
                                                              ])))
                                                ])
                                              ])))
                                    ]),
                                    Divider()
                                  ])));
                            }).toList()))
                  ])
                ]))));
  }
}
