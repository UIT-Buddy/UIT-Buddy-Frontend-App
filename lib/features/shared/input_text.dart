import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class InputText extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onHideToggle;
  final IconData? leftIcon;

  const InputText({
    super.key,
    this.hintText,
    required this.controller,
    this.isPassword = false,
    this.readOnly = false,
    this.onHideToggle,
    this.leftIcon,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      style: const TextStyle(color: AppColor.primaryText),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColor.secondaryText),
        filled: true,
        fillColor: AppColor.veryLightGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: widget.leftIcon != null
            ? Icon(widget.leftIcon, color: AppColor.secondaryText)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.secondaryText,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
    );
  }
}
