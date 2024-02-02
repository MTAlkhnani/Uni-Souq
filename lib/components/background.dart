import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            height: 160,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(1000, 1000)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(0, 0, 139, 0.4),
                    Color.fromRGBO(0, 0, 139, 0.25),
                    Color.fromRGBO(0, 0, 139, 0.5),
                  ],
                )),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 100,
            width: 90,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(600)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(0, 0, 139, 0.5),
                    Color.fromRGBO(0, 0, 139, 0.4),
                    Color.fromRGBO(0, 0, 139, 0.25),
                  ],
                )),
          ),
        ),
        child
      ]),
    );
  }
}
