import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function press;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: TextButton(
        child: Text(text, style: const TextStyle(color: Colors.white)),
        onPressed: () => press(),
      ),
    );
  }
}
