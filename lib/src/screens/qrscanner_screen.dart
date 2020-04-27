import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';/* 
import 'package:animated_qr_code_scanner/animated_qr_code_scanner.dart';
import 'package:animated_qr_code_scanner/AnimatedQRViewController.dart'; */
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
class ScanScreen extends StatefulWidget {
  static const String routeName = "/qrScannerCode";
  ScanScreen();
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  int cont=0;

  GlobalKey qrKey = GlobalKey();
  var qrText = "";
   QRViewController controller;

  @override
  Widget build(BuildContext context) {
      int banderadialog=0;
    final bloc = Provider.of<Bloc>(context);
    return 
    /* Center(
      child:  */  Column(
               children: <Widget>[
          Expanded(
            flex:10,
            child:QRView(
              key: qrKey,
              onQRViewCreated :(value)=> _onQRViewCreate(context, value, bloc, banderadialog),
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Theme.of(context).primaryColor,
                borderLength: 30.0,
                borderWidth: 10.0,
                cutOutSize: 300,
              ), 
            ),
      
          )],/* <Widget>[       
                Text("Escanea el código QR", style: TextStyle(fontSize: 27.0, color: Theme.of(context).accentColor)),
                 Container(
            height: MediaQuery.of(context).size.height-120,
            child: QRView(
              key: qrKey,
              onQRViewCreated :(value)=> _onQRViewCreate(context, value, bloc, banderadialog),
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Theme.of(context).primaryColor,
                borderLength: 30.0,
                borderWidth: 10.0,
                cutOutSize: 300,
              ), 
            ),
          )
            ] */); 
   /*  ); */
  
  }

  @override
  void dispose() {
    super.dispose();
  }  


  void _onQRViewCreate(BuildContext context, QRViewController  controller, Bloc bloc, int banderadialog) {
        this.controller = controller;
        
     controller.scannedDataStream.listen((scanData) { 
       print(scanData);     
     if(banderadialog==0){
       // controller.pauseCamera();
        bloc.tramiteScreen.searchTramiteByNum(context, scanData, (){/* controller.pause(); controller.controller.resumeCamera(); controller.resume(); */}, bloc);
      banderadialog++;     
      }     
    });

  }
}

