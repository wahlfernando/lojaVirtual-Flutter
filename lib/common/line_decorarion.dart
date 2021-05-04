import 'package:flutter/material.dart';

class LineDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.black12,
                    Colors.black,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              "",
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient:  LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black12,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end:  FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
