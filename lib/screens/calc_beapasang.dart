import 'dart:async';

import 'package:flutter/material.dart';
import 'package:market_place_flutter/utils/constants.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Calculation {
  var _jarak = 0;
  var _hargaModem = 0;
  var _beaTukang = 0;
  var _kalkulasi = 0;
  var _hargaFOPerMeter = 0;
  var _hargaConverter = 0;
  //double _total = 0;
  get Jarak => _jarak * _kalkulasi / 100 + _jarak;
  get HargaModem => _hargaModem;
  get BeaTukang => _beaTukang;
  get Kalkulasi => _kalkulasi;
  get HargaFOPerMeter => _hargaFOPerMeter;
  get HargaConverter => _hargaConverter;
  get getTotal =>
      _hargaFOPerMeter * Jarak + HargaModem + BeaTukang + HargaConverter;

  set Jarak(jarak) => this._jarak = jarak;
  set HargaModem(hargaModem) => this._hargaModem = hargaModem;
  set BeaTukang(beaTukang) => this._beaTukang = beaTukang;
  set Kalkulasi(kalkulasi) => this._kalkulasi = kalkulasi;
  set HargaFOPerMeter(hargaFO) => this._hargaFOPerMeter = hargaFO;
  set HargaConverter(hargaConverter) => this._hargaConverter = hargaConverter;
}

class CalcBeaPasang extends StatefulWidget {
  CalcBeaPasang({Key? key}) : super(key: key);

  @override
  _CalcBeaPasangState createState() => _CalcBeaPasangState();
}

class _CalcBeaPasangState extends State<CalcBeaPasang> {
  final _formKey = GlobalKey<FormState>();
  late Calculation calculation;

  //late var timer;
  @override
  void initState() {
    super.initState();
    calculation = Calculation()
      ..HargaConverter = 230000
      ..HargaFOPerMeter = 1250
      ..BeaTukang = 200000
      ..HargaModem = 200000
      ..Kalkulasi = 30;
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Kalkulator Bea Pasang Wifi",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? "Masukkan jarak" : null,
                      onChanged: (val) => calculation.Jarak =
                          val.isNotEmpty ? int.parse(val) : 0,
                      decoration: styleFloatingInputDecoration(
                          "Jarak real (meter)",
                          Icons.ac_unit,
                          IconButton(
                              onPressed: () {
                                _openMap();
                              },
                              icon: Icon(Icons.map))))),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: calculation.HargaModem.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Masukkan Harga Modem" : null,
                    onChanged: (val) => calculation.HargaModem =
                        val.isNotEmpty ? int.parse(val) : 0,
                    decoration: styleFloatingInputDecoration(
                        "Harga modem (Rp)", Icons.wifi, null),
                  )),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: calculation.HargaConverter.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Masukkan Harga Converter" : null,
                    onChanged: (val) => calculation.HargaConverter =
                        val.isNotEmpty ? int.parse(val) : 0,
                    decoration: styleFloatingInputDecoration(
                        "Harga converter (Rp)", Icons.tv, null),
                  )),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: calculation.HargaFOPerMeter.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Masukkan Harga FO/Meter" : null,
                    onChanged: (val) => calculation.HargaFOPerMeter =
                        val.isNotEmpty ? int.parse(val) : 0,
                    decoration: styleFloatingInputDecoration(
                        "Harga FO/Meter (Rp)", Icons.cable, null),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: calculation.BeaTukang.toString(),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val!.isEmpty ? "Masukkan bea tukang" : null,
                    onChanged: (val) => calculation.BeaTukang =
                        val.isNotEmpty ? int.parse(val) : 0,
                    decoration: styleFloatingInputDecoration(
                        "Bea Tukang (Rp)", Icons.money, null),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 300,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: calculation.Kalkulasi.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Estimasi dalam persen" : null,
                    onChanged: (val) => calculation.Kalkulasi =
                        val.isNotEmpty ? int.parse(val) : 0,
                    decoration: styleFloatingInputDecoration(
                        "Kalkulasi (%)", Icons.calculate, null),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                    child: Text("Hitung"),
                    onPressed: () {
                      if (mounted) {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                    title:
                                        "Biaya Pemasangan dengan Jarak ${calculation.Jarak} meter adalah sebesar:",
                                    body: "Rp. ${calculation.getTotal}");
                              });
                        }
                      }
                    }),
              )
            ],
          )),
    );
  }

  void _openMap() async {
    String lat = "-7.6251757";
    String lng = "111.9122169";
    final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";
    final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }
}

class MyDialog extends StatefulWidget {
  final String title;
  final String body;

  MyDialog({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  int _n = 0; //counter variable

  bool _isProgressing = true;
  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isProgressing = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _isProgressing
                ? [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Sedang dihitung....",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ]
                : [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(widget.body, style: TextStyle(fontSize: 30)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              _copyToClipboard(
                                  widget.title + " " + widget.body);
                            },
                            icon: Icon(Icons.copy)),
                        IconButton(
                            onPressed: () {
                              Share.share(widget.title + " " + widget.body);
                            },
                            icon: Icon(Icons.share)),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            icon: Icon(Icons.refresh)),
                      ],
                    )
                  ]),
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Copied to clipboard")));
  }
}
