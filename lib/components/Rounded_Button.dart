import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback press; // Changed the type to VoidCallback
  final double width;
  final double height;
  final TextStyle textStyle;
  final double borderRadius;

  const RoundedButton({
    Key? key,
    required this.text,
    this.width = double.infinity, // Default width is full width
    this.height = 50, // Default height is 50
    required this.color,
    required this.press,
    this.textStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Default text style
    this.borderRadius = 29, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2), // Add some vertical spacing
      child: Container(
        width: width != double.infinity ? width : size.width * 0.8, // Use the width passed in or 80% of screen width
        height: height, // Use the height passed in
        constraints: BoxConstraints(maxWidth: 300), // Set a maximum width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Padding inside the button
          ),
          onPressed: press,
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
