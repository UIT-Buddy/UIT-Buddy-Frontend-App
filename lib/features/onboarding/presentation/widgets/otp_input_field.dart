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
  final List<bool> _focusedStates = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      final idx = i;
      _focusNodes[idx].addListener(() {
        setState(() => _focusedStates[idx] = _focusNodes[idx].hasFocus);
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isEmpty && _previousValues[index].isNotEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 56,
              decoration: BoxDecoration(
                color: _focusedStates[index]
                    ? AppColor.primaryBlue10
                    : AppColor.veryLightGrey,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _focusedStates[index]
                      ? AppColor.primaryBlue
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: _focusedStates[index]
                    ? [
                        BoxShadow(
                          color: AppColor.primaryBlue.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _focusedStates[index]
                      ? AppColor.primaryBlue
                      : AppColor.primaryText,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onChanged(value, index),
                onEditingComplete: () {
                  if (index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  }
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (index < 5) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
