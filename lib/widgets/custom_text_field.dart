import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon),
                    onPressed: widget.onSuffixIconPressed,
                  )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
    );
  }
}