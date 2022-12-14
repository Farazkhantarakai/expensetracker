import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({Key? key, required this.txt, required this.funct})
      : super(key: key);

  final String txt;
  final Function funct;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(child: Text(txt), onPressed: () => funct)
        : ElevatedButton(onPressed: () => funct, child: Text(txt));
  }
}




// widget tree         element tree          render tree
//  widget tree are widget that are controlled by our code 
//  these are set of configuration
//  element tree is an empty boxes that reference to the widget tree and render tree
// if  widget donot have element tree it create element tree for that widget 
// there is a stateful and statless widget   but in statefull state is created that directly 
//directly linked to the widget and state is also linked to the the widget 
//then render the object 