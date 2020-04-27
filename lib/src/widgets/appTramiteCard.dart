import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/swipe_widget.dart';
import 'package:provider/provider.dart';

import 'appCardElementList.dart';
class TramiteCard extends StatefulWidget {
  @override
  _TramiteCardState createState() => _TramiteCardState();
  final TramiteModel objTramite;
  final int typeTramite;
  TramiteCard({this.objTramite, this.typeTramite});
}

class _TramiteCardState extends State<TramiteCard> {
  void changefunction(Bloc bloc, BuildContext context, TramiteModel objTramite){
     bloc.tramiteScreen.changeTramiteById(context, objTramite);
  }
  void _settingModalBottomSheet(context, TramiteModel objTramite, Bloc bloc) {
      bloc.utilsBloc.settingModalBottomSheet(context, objTramite,()=>{changefunction(bloc, context, objTramite)});
   }

   BoxDecoration myBoxDecoration() {     
    return BoxDecoration(
      color:Colors.white, 
       border: Border(
            right: BorderSide(width: 6.0, color:widget.typeTramite==1?Colors.red:(widget.typeTramite==2?Colors.yellow:Colors.lightGreen)  ),
         ),
     
    );  
  }
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Bloc>(context);
      return ClipRRect(
               borderRadius: BorderRadius.all(Radius.circular(35.0)),
               child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.all(1.0),
                        decoration:
                        myBoxDecoration(), //       <--- BoxDecoration here
                        child: OnSlide(items: <ActionItems>[
                           ActionItems(
                             backgroudColor: Colors.red,
                              icon:  IconButton(
                                icon:  Icon(Icons.menu ,color:Theme.of(context).primaryColor,),
                                onPressed: () {},
                                color: Theme.of(context).primaryColor,
                              ),
                              onPress: () {
                                _settingModalBottomSheet(context, widget.objTramite, bloc);
                              })
                        ], child: CardElementList(widget.objTramite, widget.typeTramite )
                        )                       
                      )
                  );              
  }
}