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
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColor.primaryBlue.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscureText,
        readOnly: widget.readOnly,
        style: const TextStyle(color: AppColor.primaryText),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColor.secondaryText),
          filled: true,
          fillColor: _isFocused
              ? AppColor.primaryBlue10
              : AppColor.veryLightGrey,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
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
            borderSide: const BorderSide(
              color: AppColor.primaryBlue,
              width: 1.5,
            ),
          ),
          prefixIcon: widget.leftIcon != null
              ? Icon(
                  widget.leftIcon,
                  color: _isFocused
                      ? AppColor.primaryBlue
                      : AppColor.secondaryText,
                )
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
      ),
    );
  }
}
