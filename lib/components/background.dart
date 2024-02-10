import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context).scaffoldBackgroundColor;
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
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.elliptical(1000, 1000)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.5),
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    Theme.of(context).primaryColor.withOpacity(0.25),
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
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(600)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.5),
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    Theme.of(context).primaryColor.withOpacity(0.25),
                  ],
                )),
          ),
        ),
        child
      ]),
    );
  }
}
