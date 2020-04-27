import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'size_change_notifier.dart';

class ActionItems extends Object {
  ActionItems(
      {@required this.icon,
      @required this.onPress,
      this.backgroudColor: Colors.grey}) {
    assert(icon != null);
    assert(onPress != null);
  }

  final Widget icon;
  final VoidCallback onPress;
  final Color backgroudColor;
}

class OnSlide extends StatefulWidget {
  OnSlide(
      {Key key,
      @required this.items,
      @required this.child,
      this.backgroundColor: Colors.black})
      : super(key: key) {
    assert(items.length <= 6);
  }

  final List<ActionItems> items;
  final Widget child;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return new _OnSlideState();
  }
}

class _OnSlideState extends State<OnSlide> {
  ScrollController controller = new ScrollController();
  bool isOpen = false;

  Size childSize;

  @override
  void initState() {
    super.initState();
  }

  bool _handleScrollNotification(dynamic notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels >= (widget.items.length * 70.0) / 2 &&
          notification.metrics.pixels < widget.items.length * 70.0) {
        scheduleMicrotask(() {
          controller.animateTo(widget.items.length * 60.0,
              duration: new Duration(milliseconds: 600),
              curve: Curves.decelerate);
        });
      } else if (notification.metrics.pixels > 0.0 &&
          notification.metrics.pixels < (widget.items.length * 70.0) / 2) {
        scheduleMicrotask(() {
          controller.animateTo(0.0,
              duration: new Duration(milliseconds: 600),
              curve: Curves.decelerate);
        });
      }
    }

    return true;
  }

 BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
          Radius.circular(25.0) //         <--- border radius here
          ),
    );
  }
   BoxDecoration myBoxDecoration2() {
    return BoxDecoration(

    color:Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.all(
          Radius.circular(25.0) //         <--- border radius here
          ),
    );
  }
    BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
   
    color: Colors.transparent,
      borderRadius: BorderRadius.all(
          Radius.circular(25.0) //         <--- border radius here
          ),
    );
  }

   
  @override
  Widget build(BuildContext context) {
    if (childSize == null) {
      return new NotificationListener(
        child: new LayoutSizeChangeNotifier(
          child: widget.child,
        ),
        onNotification: (LayoutSizeChangeNotification notification) {
          childSize = notification.newSize;
          print(notification.newSize);
          scheduleMicrotask(() {
            setState(() {});
          });
        },
      );
    }

    List<Widget> above = <Widget>[
      new Container(
        decoration: myBoxDecoration2(),
        width: childSize.width,
        height: childSize.height,
        
        child: widget.child,
      ),
    ];
    List<Widget> under = <Widget>[];

    for (ActionItems item in widget.items) {
      under.add(new Container(
        decoration: myBoxDecoration3(),
          alignment: Alignment.center,         
     
          width: 60.0,
          height: childSize.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[item.icon, Text('Mas', style: TextStyle(color: Theme.of(context).primaryColor),)],
            ),
          )));

      above.add(new InkWell(
          child: new Container(
            decoration: myBoxDecoration(),
            alignment: Alignment.center,
            width: 60.0,
            height: childSize.height,
          ),
          onTap: () {
            controller.jumpTo(2.0);
            item.onPress();
          }));
    }

    Widget items = new Container(
      decoration: myBoxDecoration(),
      width: childSize.width,
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0) ,
      height: childSize.height,
      /* color: Color.fromRGBO(142, 144, 146, 0.5), */
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: under,
      ),
    );

    Widget scrollview = new NotificationListener(
      child:   Card(
  elevation: 0,
  color: Theme.of(context).accentColor.withOpacity(0.5),
 shape:RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft:Radius.circular(25) ,
      bottomRight: Radius.circular(25),
      topRight: Radius.circular(25),
      topLeft: Radius.circular(25),
      ),
      
    
   ),
    child:new ListView(
          
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: above,
        ),
    ),  
      onNotification: _handleScrollNotification,
    );

    return new Stack(
      children: <Widget>[
        items,
        new Positioned(
          child: scrollview,
          left: 0.0,
          bottom: 0.0,
          right: 0.0,
          top: 0.0,
        )
      ],
    );
  }
}
