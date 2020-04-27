import 'dart:async';

import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:aduanas_app/src/screens/tramite_detail_screen.dart';
import 'package:aduanas_app/src/widgets/appSkeletonList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appTitleList.dart';
import 'package:aduanas_app/src/widgets/appTramiteCard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class TramitesScreen extends StatelessWidget {
  TramitesScreen({Key key}) : super(key: key);
  static const String routeName = "/tramitesScreen";



  void showQrScreen(Bloc bloc) {
    bloc.containerScreens.changeActualScreen(5);
  }

  List<Widget> getTramiteList(int tipoTramite, Bloc bloc) {
    return (tipoTramite == 1
            ? bloc.tramiteScreen.getPorRecibirList()
            : (tipoTramite == 2
                ? bloc.tramiteScreen.getRecibidosList()
                : bloc.tramiteScreen.getEntregadosList()))
        .map((objTram) =>
            TramiteCard(objTramite:objTram, typeTramite: tipoTramite))
        .toList();
  }
 RefreshController _refreshController =   RefreshController(initialRefresh: false);
  void isCompleteLoading(Bloc bloc){   
    bloc.utilsBloc.changeSpinnerState(false);
   bloc.tramiteScreen.addIsCompleteLoading(true);
  }
 
   void openDetailTramite(BuildContext context, TramiteModel tramiteModel, Bloc bloc){
       bloc.tramiteScreen.addSinkTramiteDetail(tramiteModel);
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
        TramiteDetail()));
   }
   void initCardConfiguration(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
   }
   
  void _onRefresh(Bloc bloc,  BuildContext context) async{ 
   
    bloc.tramiteScreen.refreshTramites(context);
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
     bloc.utilsBloc.changeSpinnerState(false);
  }

  void _onLoading(Bloc bloc) async{
    
 bloc.utilsBloc.changeSpinnerState(true);
    _refreshController.loadComplete();
  }
  Widget tramiteListComplete(Bloc bloc, BuildContext context){
    return  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                          bloc.tramiteScreen.getPorRecibirList().length!=0? TitleList(
                                "Asignados",
                                  bloc.tramiteScreen.getListLength()['_porRecibirTramiteList']
                                    .length
                                    .toString()):SizedBox(),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(children: getTramiteList(1, bloc)),
           
                            bloc.tramiteScreen.getRecibidosList().length!=0? TitleList(
                                "Recibidos",
                               bloc.tramiteScreen.getListLength()['_recibidosTramiteList']
                                    .length
                                    .toString()):SizedBox(),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(children: getTramiteList(2, bloc)),
               
                            bloc.tramiteScreen.getEntregadosList().length!=0? TitleList(
                                "Entregados",
                                bloc.tramiteScreen.getListLength()['_entregadosTramiteList']
                                    .length
                                    .toString()):SizedBox(),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(children: getTramiteList(3, bloc)),
               
                          ]);
  }
  Widget tramitesListLoading(BuildContext context, AsyncSnapshot<dynamic> snapshot, Bloc bloc){
    return bloc.tramiteScreen.getIsCompleteLoadingValue()==false?SkeletonList():tramiteListComplete(bloc, context);     
  }
  
  void viewMore(Bloc bloc, int type){
    bloc.tramiteScreen.changeViewMore(type);
  }
  
  @override
  Widget build(BuildContext context) {
 
    final bloc = Provider.of<Bloc>(context);
   // isLoading(bloc);
    Timer(Duration(seconds:2, milliseconds: 5), ()=> isCompleteLoading(bloc));
    bloc.tramiteScreen.getTramitesByUser();
    return Stack(
          children: <Widget>[
                Image.asset(
          "images/backgrounTramites.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,),
            SmartRefresher(
        enablePullDown: true,
        
        enablePullUp: false,
         header:  WaterDropHeader(refresh:Container(height: 65.0, color: Theme.of(context).primaryColor,),  waterDropColor: Theme.of(context).primaryColor,) ,
        footer: CustomFooter(          
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Container(
                   height: 55.0,
                  color: Colors.transparent,
                  child: Text("pull up load"),
              ); 
            }
            else if(mode==LoadStatus.loading){
              body =
              Container(
                   height: 55.0,
                  color: Colors.transparent,
                  child: CupertinoActivityIndicator(),
              );
                
            }
            else if(mode == LoadStatus.failed){
              body =
               Container(
                    height: 55.0,
           color: Colors.transparent,
                  child: Text("Load Failed!Click retry!"),
              );
               
            }
            else if(mode == LoadStatus.canLoading){
                body =   Container(
                     height: 55.0,
                       color: Colors.transparent,
                  child:  Text("release to load more"),
              );
                
            }
            else{
              body =Container(
                   height: 55.0,
                    color: Colors.transparent,
                  child:  Text("No more Data"),
              );
               
            }
            return Container(
              height: 55.0,
             color: Colors.transparent,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh:()=> _onRefresh(bloc, context),
        onLoading:()=> _onLoading(bloc),
        child: 
                Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: 
            StreamBuilder(
              stream: bloc.tramiteScreen.getTransformerIsCompleteLoading,
              builder: (context, snapshot){
                return         Stack(
                  
              children: <Widget>[
                CurvedShape(transparent: true,),
                StreamBuilder(
                    stream: bloc.tramiteScreen.changesTramiteList,
                    builder: (context, snapshot) {
                     return tramitesListLoading(context,snapshot, bloc);
            })
              ],
            );
     
              },
            )
            
            /*   */
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showQrScreen(bloc),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    ) 
       

   
   )]); 
    
   }
}
