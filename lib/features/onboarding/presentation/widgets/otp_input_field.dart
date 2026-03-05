import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class OtpInputField extends StatefulWidget {
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  const OtpInputField({super.key, this.onCompleted, this.onChanged});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<String> _previousValues = List.generate(6, (_) => '');

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Check if user deleted the character
    if (value.isEmpty && _previousValues[index].isNotEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    // Move forward when entering a digit
    else if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    _previousValues[index] = value;

    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);

    if (otp.length == 6) {
      widget.onCompleted?.call(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int index = 0; index < 6; index++) ...[
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyle.bodyLarge,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColor.veryLightGrey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: AppColor.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(value, index),
                onTap: () {
                  if (_controllers[index].text.isNotEmpty) {
                    _controllers[index].selection = TextSelection.fromPosition(
                      TextPosition(offset: _controllers[index].text.length),
                    );
                  }
                },
                onEditingComplete: () {
                  if (index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  }
                },
              ),
            ),
          ),
          if (index < 5) const SizedBox(width: 20),
        ],
      ],
    );
  }
}
