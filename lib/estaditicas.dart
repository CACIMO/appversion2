import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'global.dart';
import 'package:flutter/cupertino.dart';

class Estadisticas extends StatefulWidget {
  @override
  _Estadisticas createState() => new _Estadisticas();
}

class _Estadisticas extends State<Estadisticas> {
  List categorias = [
    {'name': 'Girl', 'icon': 'images/girl.png', 'active': 'false'},
    {'name': 'Boy', 'icon': 'images/boy.png', 'active': 'false'},
    {'name': 'Baby', 'icon': 'images/baby.png', 'active': 'false'}
  ];

  @override
  void initState() {
    super.initState();
  }

  List<charts.Series> seriesList;
  bool animate;

  List<charts.Series<LinearSales, int>> _createSampleData() {


    var myFakeMobileData = [
      new LinearSales(0, 15),
      new LinearSales(1, 75),
      new LinearSales(2, 300),
      new LinearSales(3, 225),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.Color(r: 5, g: 176, b: 113),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeMobileData,
      ),
    ];
  }

  Widget build(BuildContext ctx) {
    return Container(
        padding: EdgeInsets.only(/*top: ScQuery(ctx)['h'] *.05,*/left: ScQuery(ctx)['w']*.05,right: ScQuery(ctx)['w']*.05),
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: ScQuery(ctx)['h'] *.05),
          height: ScQuery(ctx)['h']*.18,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                        child: Text('Estadisticas',
                            style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 35)),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: ScQuery(ctx)['w'] * .01,
                            bottom: ScQuery(ctx)['w'] * .03),
                        child: Text('Control de venta',
                            style: TextStyle(fontFamily: 'Roboto-Thin', fontSize: 25)),
                      ))
                ],
              ),
              Divider()]
          )
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: ScQuery(ctx)['w'] * .03),
              child: Text('Monto Vendido Este Mes',
                  style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 22)),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(
                  top: ScQuery(ctx)['w'] * .02,
                  bottom: ScQuery(ctx)['w'] * .02),
              child: Text('\$10.000.000',
                  style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 25)),
            )),
          ],
        ),
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Center(
                  child: Icon(
                Icons.remove_outlined,
                color: Color(0xFFff472f).withOpacity(.7),
                size: 15,
              )),
              decoration: new BoxDecoration(
                color: Color(0xFFff472f).withOpacity(.25),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 3),
              height: 20,
              child: Center(
                  child: Text('\$300.000',
                      style: TextStyle(
                          color: Color(0xFFff472f).withOpacity(.7),
                          fontSize: 15))),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(bottom: ScQuery(ctx)['w'] * .02),
                    width: ScQuery(ctx)['w'] * .9,
                    height: ScQuery(ctx)['w'] * .7,
                    child: new charts.LineChart(_createSampleData(),
                        defaultRenderer: new charts.LineRendererConfig(
                          includeArea: true,
                          stacked: true,
                          strokeWidthPx: 2,
                        ),
                        animate: true)))
          ],
        ),
        Divider(),
        Container(
            margin: EdgeInsets.only(
                top: ScQuery(ctx)['w'] * .02, bottom: ScQuery(ctx)['w'] * .02),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                        child: Text(
                      'Monto Vendido Hoy',
                      style:
                          TextStyle(fontFamily: 'Roboto-Light', fontSize: 15),
                    ))),
                Expanded(
                    flex: 5,
                    child: Container(
                        child: Text('Ventas Registradas Hoy',
                            style: TextStyle(
                                fontFamily: 'Roboto-Light', fontSize: 15))))
              ],
            )),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                    child: Text(
                  '\$900.000',
                  style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 25),
                ))),
            Expanded(
                flex: 5,
                child: Container(
                    child: Text('88',
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular', fontSize: 25))))
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: Center(
                              child: Icon(
                            Icons.arrow_upward_outlined,
                            color: Color(0xFF05b071).withOpacity(.7),
                            size: 15,
                          )),
                          decoration: new BoxDecoration(
                            color: Color(0xFF05b071).withOpacity(.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          height: 20,
                          child: Center(
                              child: Text('20%',
                                  style: TextStyle(
                                      color: Color(0xFF05b071).withOpacity(.7),
                                      fontSize: 15))),
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: Center(
                              child: Icon(
                            Icons.arrow_upward_outlined,
                            color: Color(0xFF05b071).withOpacity(.7),
                            size: 15,
                          )),
                          decoration: new BoxDecoration(
                            color: Color(0xFF05b071).withOpacity(.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          height: 20,
                          child: Center(
                              child: Text('20%',
                                  style: TextStyle(
                                      color: Color(0xFF05b071).withOpacity(.7),
                                      fontSize: 15))),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
        Container(
            margin: EdgeInsets.only(
                top: ScQuery(ctx)['w'] * .02, bottom: ScQuery(ctx)['w'] * .02),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                        child: Text(
                      'Monto Promedio',
                      style:
                          TextStyle(fontFamily: 'Roboto-Light', fontSize: 15),
                    ))),
                Expanded(
                    flex: 5,
                    child: Container(
                        child: Text('Promedio de Ventas',
                            style: TextStyle(
                                fontFamily: 'Roboto-Light', fontSize: 15))))
              ],
            )),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                    child: Text(
                  '\$900.000',
                  style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 25),
                ))),
            Expanded(
                flex: 5,
                child: Container(
                    child: Text('88',
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular', fontSize: 25))))
          ],
        )
      ]
    ));
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
/*
*
* */
