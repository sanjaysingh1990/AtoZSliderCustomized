import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';

import 'camera_utils.dart';

void main() => runApp(MaterialApp(home: CameraUtilsDemo()));

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  double _offsetContainer;
  var _text;
  var _oldtext;
  var _heightscroller;
  var _itemsizeheight = 65.0; //NOTE: size items
  var _marginRight=50.0;
  var _sizeheightcontainer;
  var posSelected = 0;
  var diff = 0.0;
  var height = 0.0;
  var txtSliderPos = 0.0;
  ScrollController _controller;
  String message = "";

  List exampleList = [
    'Axvfgfdg',
    'Axvfgfdg2',
    'Axvfgfdg3',
    'Bsdadasd',
    'Bsdadasd2',
    'Bsdadasd3',
    'Cat',
    'Cat2',
    'Cat3',
    'Dog',
    'Dog2',
    'Dog3',
    'Elephant',
    'Elephant2',
    'Elephant3',
    'Fans',
    'Girls',
    'Hiiii',
    'Ilu',
    'Jeans',
    'Kite',
    'Lion',
    'Men',
    'Nephow',
    'Owl',
    'Please',
    'Quat',
    'Rose',
    'Salt',
    'Trolly',
    'Up',
    'View',
    'Window',
    'Xbox',
    'Yellow',
    'Yummy',
    'Zubin',
    'Zara',
    'Fans2',
    'Girls2',
    'Hiiii2',
    'Ilu2',
    'Jeans2',
    'Kite2',
    'Lion2',
    'Men2',
    'Nephow2',
    'Owl2',
    'Please2',
    'Quat2',
    'Rose2',
    'Salt2',
    'Trolly2',
    'Up2',
    'View2',
    'Window2',
    'Xbox2',
    'Yellow2',
    'Yummy2',
    'Zubin2',
    'Zara2'
  ];

  List _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  void initState() {
// TODO: implement initState
    _offsetContainer = 0.0;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    //sort the item list
    exampleList.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });
    super.initState();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / _heightscroller) % _alphabet.length).round();
        _text = _alphabet[posSelected];
        if (_text != _oldtext) {
          for (var i = 0; i < exampleList.length; i++) {
            if (_text
                    .toString()
                    .compareTo(exampleList[i].toString().toUpperCase()[0]) ==
                0) {
              _controller.jumpTo(i * _itemsizeheight);
              break;
            }
          }
          _oldtext = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
//    var heightAfterToolbar = height - diff;
//    print("height1 $heightAfterToolbar");
//    var remavingHeight = heightAfterToolbar - (20.0 * 26);
//    print("height2 $remavingHeight");
//
//    var reducedheight = remavingHeight / 2;
//    print("height3 $reducedheight");
    _offsetContainer = details.globalPosition.dy - diff;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("A to Z Slider"),
        centerTitle: true,
      ),
      body: new LayoutBuilder(
        builder: (context, contrainsts) {
          diff = height - contrainsts.biggest.height;
          _heightscroller = (contrainsts.biggest.height) / _alphabet.length;
          _sizeheightcontainer = (contrainsts.biggest.height); //NO
          return new Stack(children: [
            ListView.builder(
              itemCount: exampleList.length,
              controller: _controller,
              itemExtent: _itemsizeheight,
              itemBuilder: (context, position) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      exampleList[position],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              right: _marginRight,
              top: _offsetContainer,
              child: _getSpeechBubble(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragStart: _onVerticalDragStart,
                child: Container(
                  //height: 20.0 * 26,
                  color: Colors.transparent,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: []..addAll(
                        new List.generate(_alphabet.length,
                            (index) => _getAlphabetItem(index)),
                      ),
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  _getSpeechBubble() {
    return new SpeechBubble(
      nipLocation: NipLocation.RIGHT,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 30,
            child: Center(
              child: Text(
                "${_text ?? "${_alphabet.first}"}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ValueGetter callback(int value) {}

  _getAlphabetItem(int index) {
    return new Expanded(
      child: new Container(
        width: 40,
        height: 20,
        alignment: Alignment.center,
        child: new Text(
          _alphabet[index],
          style: (index == posSelected)
              ? new TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              : new TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  //scroll detector for reached top or bottom
  _scrollListener() {
    if ((_controller.offset) >= (_controller.position.maxScrollExtent)) {
      print("reached bottom");
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reached top");
    }
  }
}
