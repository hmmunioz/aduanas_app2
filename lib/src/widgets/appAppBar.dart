import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/animations/appMyPainter.dart';
import 'package:aduanas_app/src/widgets/appSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppappBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _AppappBarState createState() => _AppappBarState();
}

class _AppappBarState extends State<AppappBar> with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  AnimationController _controller;
  Animation _animation;
  bool isInSearchMode = false;
  
  @override
  initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
       isInSearchMode = true; 
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancelSearch(Bloc bloc) {
    setState(() {
      isInSearchMode = false;
    });

    onSearchQueryChange('', bloc);
    _controller.reverse();
  }

  onSearchQueryChange(String query, Bloc bloc) {
    
      bloc.tramiteScreen.addSearchController(query);    
    bloc.tramiteScreen.addSinkTramiteList(true);   
    print('search $query');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bloc = Provider.of<Bloc>(context);
    return
    PreferredSize(
          preferredSize: Size.fromHeight(40.0), // here the desired height
          child:    Stack(
      children: [
        AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Buscar Tramites", style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            GestureDetector(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              onTapUp: onSearchTapUp,
            )
           
          ],
        ),

        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: MyPainter(
                containerHeight: widget.preferredSize.height,
                center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                radius: _animation.value * screenWidth,
                context: context,
              ),
            );
          },
        ),

        isInSearchMode ? (
          SearchBar(
            onCancelSearch:()=>{cancelSearch(bloc)} ,
            onSearchQueryChanged:(value)=>{ onSearchQueryChange(value, bloc)},
          )
        ) : (
          Container()
        )
      ]
    )
  );
  }
}