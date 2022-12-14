import 'package:expensestracker/Models/tracnsaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Widgets/addtransaction.dart';
import 'Widgets/charts.dart';
import 'Widgets/listviewtracker.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            fontFamily: 'Quicksand',
            textTheme: TextTheme(
                bodyMedium: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        home: const MyApp());
  }
}

//  if i have a widget and i dynamically assign it height and width
//  then we can assign width and height to its children by using LayoutBuilder
//  LayoutBuilder(builder:(ctx,constraints){ return itsChildren with assigning heigt and width with constraints })
//  final isLandScape=MediaQuery.of(context).orientation == Orientation.LandScape;
//  then assign it by isLandScape and !isLandScape
// FittedBox  ,  Flexible and Expanded  , aspectRatio
// Flexible( flex:1 , fit:BoxFit.cover,BoxFit.contain) ,Expanded(flex:1) ,
// where ,

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> _expenses = [];
  bool _isSelected = false;

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    var _trx = Transaction(DateTime.now().toString(), title, amount, dateTime);

    setState(() {
      _expenses.add(_trx);
    });
  }

  List<Transaction> get _recentTransaction {
    return _expenses.where((tx) {
      return tx.dateTime
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _deleteItem(String id) {
    setState(() {
      _expenses.removeWhere((transactions) => transactions.id == id);
    });
  }

  void startModelSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          //here we will pass the reference of that function
          return NewTransaction(
            _addNewTransaction,
          );
        });
  }

  List<Widget> _buildLandScapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget _txListWidget) {
    return [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Switch.adaptive(
            value: _isSelected,
            onChanged: (value) {
              setState(() {});
              _isSelected = value;
            }),
        _isSelected
            ? Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: Charts(_recentTransaction))
            : _txListWidget
      ])
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget _txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Charts(_recentTransaction)),
      _txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
//every time we are using MediaQuery so we will create it one and will use it every where
    final mediaQuery = MediaQuery.of(context);
//here we are checking that our device is in landscape mode or not
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    var appBar = AppBar(
      actions: [
        IconButton(
            onPressed: () {
              startModelSheet(context);
            },
            icon: Icon(Icons.add))
      ],
      title: const Text('Expense Tracker'),
    );

    final _txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: ListViewTracker(_expenses, _deleteItem));

    final _pageBody = SingleChildScrollView(
      child: SafeArea(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandScape)
            ..._buildLandScapeContent(mediaQuery, appBar, _txListWidget),
          //this three dot will add all the widget as an element
          if (!isLandScape)
            ..._buildPortraitContent(mediaQuery, appBar, _txListWidget),
          // if (!isLandScape)
        ],
      )),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageBody,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      startModelSheet(context);
                    },
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: _pageBody);
  }
}
