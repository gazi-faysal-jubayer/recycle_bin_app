import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? iconData;
  final bool isOutlined;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.iconData,
    this.isOutlined = false,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;
    final buttonTextColor = textColor ?? Theme.of(context).colorScheme.onPrimary;
    
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonColor),
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              ),
              child: _buildButtonContent(buttonColor),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              ),
              child: _buildButtonContent(buttonTextColor),
            ),
    );
  }

  Widget _buildButtonContent(Color contentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconData != null) ...[
          Icon(iconData, color: contentColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: contentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}