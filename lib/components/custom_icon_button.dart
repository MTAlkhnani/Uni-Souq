import 'package:flutter/material.dart';
import 'package:unisouq/utils/size_utils.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration getFillWhiteA(BuildContext context) => BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30.h),
      );

  static BoxDecoration getFillWhiteATL20(BuildContext context) => BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(20.h),
      );

  static BoxDecoration getOutlineWhiteA(BuildContext context) => BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(15.h),
        border: Border.all(
          color: Theme.of(context).hintColor,
          width: 2.h,
        ),
      );

  static BoxDecoration getOutlineGray(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.circular(15.h),
        border: Border.all(
          color: Theme.of(context).hintColor,
          width: 1.h,
        ),
      );
}
