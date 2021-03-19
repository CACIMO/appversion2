import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class NuevoProd extends StatefulWidget {
  @override
  _NuevoProd createState() => new _NuevoProd();
}

UnfocusDisposition disposition = UnfocusDisposition.scope;
bool habilitarEdicion = false;

/*
setState(() {
primaryFocus.unfocus(disposition: disposition);
});*/
class _NuevoProd extends State<NuevoProd> {
  // ignore: non_constant_identifier_names
  bool valaux = false;
  PickedFile img;
  File fileImg;
  // ignore: non_constant_identifier_names
  int PesoFile;
  Map<String, bool> conf = {'CT': false, 'TG': false, 'CL': false, 'TL': false};

  // ignore: non_constant_identifier_names
  List<String> categorias = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> categoriasCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> categoriasId = {};

  List<String> tags = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> tagCheks = {};
  Map<String, String> tagId = {};

  // ignore: non_constant_identifier_names
  List<String> tallas = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> tallasCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> tallasId = {};

  List<String> color = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> ColorsCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> ColorsId = {};
  // ignore: non_constant_identifier_names
  Map<String, List<String>> Combs = {};

  Map<String, TextEditingController> controllers = {
    'titulo': TextEditingController(),
    'valor': TextEditingController(),
    'nombre': TextEditingController(),
    'descripcion': TextEditingController(),
    'rfInt': TextEditingController(),
    'rfVend': TextEditingController(),
    'cant': TextEditingController(),
  };

  void crearProducto(ctx) async {
    bool flag = false;
    print(categoriasId);
    List<String> aux1 = color
        .map((item) {
          if (ColorsCheks[item]) return ColorsId[item];
        })
        .where((item) => item != null)
        .toList();
    List aux2 = tags
        .map((item) {
          if (tagCheks[item]) return tagId[item];
        })
        .where((item) => item != null)
        .toList();
    List aux3 = categorias
        .map((item) {
          if (categoriasCheks[item]) return categoriasId[item];
        })
        .where((item) => item != null)
        .toList();
    List aux4 = tallas
        .map((item) {
          if (tallasCheks[item]) return tallasId[item];
        })
        .where((item) => item != null)
        .toList();

    var sizeData;
    await fileImg.length().then((value) => sizeData = value);
    print(controllers.keys);
    Map<String, String> jsonAux = {
      'titulo': controllers['titulo'].text,
      'nombre': controllers['nombre'].text,
      'valor': controllers['valor'].text,
      'descripcion': controllers['descripcion'].text,
      'refVendedora': controllers['rfVend'].text,
      'refInterna': controllers['rfInt'].text,
      'stock': controllers['cant'].text,
      'pesoImg': sizeData.toString(),
      'color': jsonEncode(aux1),
      'categoria': jsonEncode(aux3),
      'tag': jsonEncode(aux2),
      'talla': jsonEncode(aux4),
    };
    //print(jsonAux);
    for (final key in jsonAux.keys) {
      if (jsonAux[key] == '') {
        flag = true;
        AlertMsg(ctx, 'E',
            'El Campo ${key[0].toUpperCase()}${key.substring(1)}\nEsta vacio.');
        break;
      }
    }
    if (!flag) {
      AlertLoad(ctx, 'Cargando.. Por favor Espere');
      httpPostFile('producto/null', jsonAux, fileImg).then((resp) {
        Navigator.pop(ctx);
        AlertMsg(ctx, 'S', 'Producto Creado Correctamente').then((value) {
          getInitialData();
          controllers.forEach((key, value) {
            setState(() {
              value.text = '';
            });
          });
        });
      }).catchError((jsonError) {
        print(jsonError);
        Navigator.pop(ctx);
        AlertMsg(ctx, 'E', 'Error al crear producto');
      });
    }
  }
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  void getInitialData() {
    getCategory();
    getColor();
    getTag();
    getTalla();
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
    Toast.show("${value ? 'Activado' : 'Desactivado'} Correctamente", ctx,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    getInitialData();
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
                              flex: 9,
                              child: Container(
                                  child: Text('Producto',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Light',
                                          fontSize: ScQuery(ctx)['h'] * .06)))),

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
                                  child: Text('Detalles',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Thin',
                                          fontSize: ScQuery(ctx)['h'] * .04))))
                        ]),
                        Divider()
                      ])),
                  Column(children: [
                    Container(
                        height: ScQuery(ctx)['h'] * .75,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child:SingleChildScrollView(
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScQuery(ctx)['h'] * .012,
                                            top: ScQuery(ctx)['h'] * .005),
                                        child: TextFormField(
                                            autofocus: false,
                                            controller: controllers['titulo'],
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Titulo del Producto',
                                                labelText: 'Titulo del Producto',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScQuery(ctx)['h'] * .012,
                                            top: ScQuery(ctx)['h'] * .005),
                                        child: TextFormField(
                                            controller: controllers['rfInt'],
                                            autofocus: false,
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Refencia interna',
                                                labelText: 'Refencia interna',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScQuery(ctx)['h'] * .012,
                                            top: ScQuery(ctx)['h'] * .005),
                                        child: TextFormField(
                                            autofocus: false,
                                            controller: controllers['rfVend'],
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Refencia Vendedor@',
                                                labelText: 'Refencia Vendedor@',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(bottom: ScQuery(ctx)['h'] * .012),
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            controller: controllers['cant'],
                                            maxLength: 7,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Unidades Disponibles',
                                                labelText: 'Unidades Disponibles',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(bottom: ScQuery(ctx)['h'] * .012),
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            controller: controllers['valor'],
                                            maxLength: 7,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Valor de Venta',
                                                labelText: 'Valor de Venta',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    flex: 7,
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(bottom: ScQuery(ctx)['h'] * .012),
                                        child: TextFormField(
                                            autofocus: false,
                                            readOnly: true,
                                            controller: controllers['nombre'],
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Nombre imagen',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB))))),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScQuery(ctx)['h'] * .012,
                                            left: ScQuery(ctx)['w'] * .012),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              img = await ImagePicker()
                                                  .getImage(source: ImageSource.gallery);
                                              fileImg = (img == null) ? null : File(img.path);
                                              var auxExt = img.path.split('.').last;
                                              print(auxExt);
                                              if (auxExt == 'jpg' ||
                                                  auxExt == 'png' ||
                                                  auxExt == 'jpeg')
                                                setState(() {
                                                  controllers['nombre'].text = (img == null)
                                                      ? ''
                                                      : img.path.split('/').last ?? '';
                                                });
                                              else
                                                setState(() {
                                                  img = null;
                                                  controllers['nombre'].text = '';
                                                });
                                            },
                                            child: Container(
                                                height: 52,
                                                child: Center(
                                                    child: Text('Buscar\nImagen',
                                                        style: TextStyle(
                                                            fontFamily: 'Roboto-Light',
                                                            fontSize: 14)))))))
                              ]),
                              Row(children: [
                                Expanded(
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(bottom: ScQuery(ctx)['h'] * .012),
                                        child: TextFormField(
                                            autofocus: false,
                                            maxLines: 5,
                                            controller: controllers['descripcion'],
                                            maxLength: 100,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(0xFFEBEBEB), width: 1)),
                                                hintText: 'Descripción',
                                                hintStyle:
                                                TextStyle(color: Color(0xFFAAAAAA)),
                                                //filled: true,
                                                fillColor: Color(0xFFEBEBEB)))))
                              ]),
                              Row(children: [
                                Expanded(
                                    flex: 9,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScQuery(ctx)['w'] * .01,
                                            bottom: ScQuery(ctx)['w'] * .03),
                                        child: Text('Colores',
                                            style: TextStyle(
                                                fontFamily: 'Roboto-Light', fontSize: 20)))),
                                Expanded(
                                    flex: 1,
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
                                                              changeCheck(
                                                                  ctx, 'CL', item, !ColorsCheks[item],
                                                                      () {
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
                                                                fontFamily: 'Roboto-Light',
                                                                fontSize: 18))),
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: Card(
                                                          child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              padding: EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                  color: Color(int.parse(
                                                                      '0xFF${Combs[item][0]}')),
                                                                  borderRadius:
                                                                  BorderRadius.circular(25)),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Color(int.parse(
                                                                          '0xFF${(Combs[item][1] == '') ? Combs[item][0] : Combs[item][1]}')),
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          25)))),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(25))),
                                                    )
                                                  ]);
                                                }).toList()))))
                              ]),
                              Row(children: [
                                Expanded(
                                    flex: 9,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScQuery(ctx)['w'] * .01,
                                            bottom: ScQuery(ctx)['w'] * .03),
                                        child: Text('Talla',
                                            style: TextStyle(
                                                fontFamily: 'Roboto-Light', fontSize: 20)))),
                                Expanded(
                                    flex: 1,
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
                                                              changeCheck(
                                                                  ctx, 'TL', item, !tallasCheks[item],
                                                                      () {
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
                                                                fontFamily: 'Roboto-Light',
                                                                fontSize: 18)))
                                                  ]);
                                                }).toList()))))
                              ]),
                              Row(children: [
                                Expanded(
                                    flex: 9,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScQuery(ctx)['w'] * .01,
                                            bottom: ScQuery(ctx)['w'] * .03),
                                        child: Text('Categorias',
                                            style: TextStyle(
                                                fontFamily: 'Roboto-Light', fontSize: 20)))),
                                Expanded(
                                    flex: 1,
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
                                                                  !categoriasCheks[item], () {
                                                                    setState(() {
                                                                      categoriasCheks[item] =
                                                                      !categoriasCheks[item];
                                                                    });
                                                                  });
                                                            },
                                                            value: categoriasCheks[item])),
                                                    Expanded(
                                                        flex: 8,
                                                        child: Text(item,
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto-Light',
                                                                fontSize: 18)))
                                                  ]);
                                                }).toList()))))
                              ]),
                              Row(children: [
                                Expanded(
                                    flex: 9,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScQuery(ctx)['w'] * .01,
                                            bottom: ScQuery(ctx)['w'] * .03),
                                        child: Text('Tags',
                                            style: TextStyle(
                                                fontFamily: 'Roboto-Light', fontSize: 20)))),
                                Expanded(
                                    flex: 1,
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
                                                              changeCheck(
                                                                  ctx, 'TG', item, !tagCheks[item],
                                                                      () {
                                                                    setState(() {
                                                                      tagCheks[item] = !tagCheks[item];
                                                                    });
                                                                  });
                                                            },
                                                            value: tagCheks[item])),
                                                    Expanded(
                                                        flex: 8,
                                                        child: Text(item,
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto-Light',
                                                                fontSize: 18)))
                                                  ]);
                                                }).toList()))))
                              ]),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            onPressed: () => crearProducto(ctx),
                                            child: Container(
                                                height: 52,
                                                child: Center(
                                                    child: Text('Agregar Nuevo Producto',
                                                        style: TextStyle(fontSize: 15))))))
                                  ]))
                            ])))
                  ])
                ]))));
  }
}


