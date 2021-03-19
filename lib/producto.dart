
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Producto extends StatefulWidget {
  final data;

  const Producto({Key key, this.data}) : super(key: key);

  @override
  _Producto createState() => _Producto(this.data);
}

class _Producto extends State<Producto> {
  final data;

  _Producto(this.data);

  Map<String, bool> conf = {'CT': true, 'TG': true, 'CL': true, 'TL': true};

  List<String> color = [];
  // ignore: non_constant_identifier_names
  Map<String, bool> ColorsCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> ColorsId = {};
  // ignore: non_constant_identifier_names
  Map<String, List<String>> Combs = {};

  // ignore: non_constant_identifier_names
  List<String> tallas = [];
  Map<String, bool> tallasCheks = {};
  // ignore: non_constant_identifier_names
  Map<String, String> tallasId = {};
  int counter = 0;

  bool habilitarEdicion = true;

  List<String> categorias = [];
  Map<String, bool> categoriasCheks = {};
  Map<String, String> categoriasId = {};

  TextEditingController precioController = TextEditingController();

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

  void updateCounter(bool acc) {
    setState(() {
      if (acc)
        // ignore: unnecessary_statements
        counter < data['stock'] ? counter++ : null;
      else
        // ignore: unnecessary_statements
        counter > 0 ? counter-- : null;
    });
  }

  bool visi = true;
  var focusNode = FocusNode();
  void changeCheck(ctx, type, titulo, bool value, Function callback) {
    callback();
    Toast.show("${value ? 'Activado' : 'Desactivado'} Correctamente", ctx,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    precioController.text = data['valor'].toString();
    data['tallaData'].forEach((item) {
      tallas.add(item['titulo']);
      tallasCheks[item['titulo']] = false;
      tallasId[item['titulo']] = item['_id'];
    });
    data['colorData'].forEach((item) {
      color.add(item['titulo']);
      ColorsCheks[item['titulo']] = false;
      Combs[item['titulo']] = [item['primario'], item['segundario']];
      ColorsId[item['titulo']] = item['_id'];
    });
  }

  void enviarACarrito(ctx) async {
    String tallasIdSelect = '';
    // ignore: non_constant_identifier_names
    String ColorsIdSelect = '';
    bool flag = true;

    ColorsCheks.forEach((key, value) {
      if (value) ColorsIdSelect = (ColorsId[key]);
    });
    tallasCheks.forEach((key, value) {
      if (value) tallasIdSelect = (tallasId[key]);
    });

    Map<String, String> dataSend = {
      "producto": data['_id'],
      "precio": precioController.text,
      "talla": tallasIdSelect,
      "color": ColorsIdSelect,
      'cantidad': counter.toString()
    };
    for (final key in dataSend.keys) {
      if (dataSend[key] == '' ||
          dataSend[key] == null ||
          dataSend[key] == '0') {
        flag = false;
        AlertMsg(ctx, 'E',
            'Verifique el campo ${key[0].toUpperCase()}${key.substring(1)}');
        break;
      }
    }
    if (flag) {
      httpPost('carrito', dataSend).then((resp) {
        AlertMsg(ctx, 'S', 'Agregado Correctamente')
            .then((value) => Navigator.pop(ctx));
      }).catchError((onError) {
        AlertMsg(ctx, 'E', 'Error al agregar');
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      setState(() {
        visi = false;
      });
    } else {
      setState(() {
        visi = true;
      });
    }
    return Container(
        height: ScQuery(ctx)['h'],
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: Container(
                    height: ScQuery(ctx)['h'] * .57,
                    width: ScQuery(ctx)['w'],
                    padding: EdgeInsets.only(
                        top: ScQuery(ctx)['h'] * .11, left: 30, right: 30),
                    margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .4),
                    child: Container(
                        height: ScQuery(ctx)['h'] * .1,
                        child: Column(children: [
                          Row(children: [
                            Text('${data['titulo']}',
                                style: TextStyle(
                                    fontSize: ScQuery(ctx)['h'] * .035,
                                    fontFamily: 'Roboto-Light'))
                          ]),
                          Divider(),
                          Container(
                              height: ScQuery(ctx)['h'] * .38,
                              child: ListView(children: [
                                Row(children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                          child: Text('Cantidad: ',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: IconButton(
                                        onPressed: () => updateCounter(false),
                                        icon: Icon(Icons.remove_outlined,
                                            color: Color(0xFFff472f)
                                                .withOpacity(.7)),
                                      ))),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('$counter',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: IconButton(
                                        onPressed: () => updateCounter(true),
                                        icon: Icon(Icons.add_outlined,
                                            color: Color(0xFF05b071)
                                                .withOpacity(.7)),
                                      ))),
                                ]),
                                Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: Text('Precio: ',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: Text('\$',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                          //margin:EdgeInsets.only(top:heightApp*.015),
                                          child: TextFormField(
                                              onFieldSubmitted: (val) => {
                                                    focusNode.unfocus()
                                                  },
                                              maxLength: 30,
                                              focusNode: focusNode,
                                              controller: precioController,
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                  counterText: "",
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFEBEBEB),
                                                              width: 1)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFEBEBEB),
                                                              width: 1)),
                                                  hintText: 'Precio',
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFFAAAAAA)),
                                                  // //filled: true,
                                                  fillColor:
                                                      Color(0xFFEBEBEB))))),
                                ]),
                                Row(children: [
                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                          child: Text('Colores',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: IconButton(
                                              icon: Icon((conf['CL'])
                                                  ? Icons.arrow_drop_down
                                                  : Icons.arrow_drop_up),
                                              iconSize: ScQuery(ctx)['h'] * .03,
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
                                                            ctx,
                                                            'CL',
                                                            item,
                                                            !ColorsCheks[item],
                                                            () {
                                                          ColorsCheks.keys
                                                              .forEach((key) {
                                                            setState(() {
                                                              ColorsCheks[key] =
                                                                  false;
                                                            });
                                                          });
                                                          setState(() {
                                                            ColorsCheks[item] =
                                                                !ColorsCheks[
                                                                    item];
                                                          });
                                                        });
                                                      },
                                                      value:
                                                          ColorsCheks[item])),
                                              Expanded(
                                                  flex: 6,
                                                  child: Text(item,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto-Light',
                                                          fontSize: ScQuery(
                                                                  ctx)['h'] *
                                                              .022))),
                                              Container(
                                                width: 36,
                                                height: 36,
                                                child: Card(
                                                    child: Container(
                                                        width: 36,
                                                        height: 36,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: Color(int.parse(
                                                                '0xFF${Combs[item][0]}')),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    int.parse('0xFF${(Combs[item][1] == '') ? Combs[item][0] : Combs[item][1]}')),
                                                                borderRadius: BorderRadius.circular(18)))),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                                              )
                                            ]);
                                          }).toList()))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                          child: Text('Talla',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Light',
                                                  fontSize: ScQuery(ctx)['h'] *
                                                      .022)))),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: IconButton(
                                              icon: Icon((conf['TL'])
                                                  ? Icons.arrow_drop_down
                                                  : Icons.arrow_drop_up),
                                              iconSize: ScQuery(ctx)['h'] * .03,
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
                                                            ctx,
                                                            'TL',
                                                            item,
                                                            !tallasCheks[item],
                                                            () {
                                                          tallasCheks.keys
                                                              .forEach(
                                                                  (element) {
                                                            setState(() {
                                                              tallasCheks[
                                                                      element] =
                                                                  false;
                                                            });
                                                          });
                                                          setState(() {
                                                            tallasCheks[item] =
                                                                !tallasCheks[
                                                                    item];
                                                          });
                                                        });
                                                      },
                                                      value:
                                                          tallasCheks[item])),
                                              Expanded(
                                                  flex: 8,
                                                  child: Text(item,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto-Light',
                                                          fontSize: ScQuery(
                                                                  ctx)['h'] *
                                                              .022)))
                                            ]);
                                          }).toList()))))
                                ]),
                                Container(
                                    child: Row(children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            enviarACarrito(ctx);
                                            //crearUsuarioNuevo(context);
                                          },
                                          child: Container(
                                              height: 52,
                                              child: Center(
                                                  child: Text(
                                                      'Agregar al Carrito',
                                                      style: TextStyle(
                                                          fontSize: 15))))))
                                ]))
                              ]))
                        ])),
                    decoration: BoxDecoration(
                        color: Color(0xfffafbfd),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )))),
            Visibility(
                visible: visi,
                child: Container(
                  height: ScQuery(ctx)['h'] * .6,
                  margin: EdgeInsets.only(top: ScQuery(ctx)['h'] * .15),
                  alignment: Alignment.topCenter,
                  child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(15),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              child: CachedNetworkImage(
                                  width: ScQuery(ctx)['w'] * .7,
                                  height: ScQuery(ctx)['w'] * .7,
                                  placeholder: (context, url) => Container(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator()),
                                  imageUrl:
                                      'http://3.138.111.218:3000/getimg/${data['_id']}')))),
                ))
          ],
        ));
  }
}
/**/
