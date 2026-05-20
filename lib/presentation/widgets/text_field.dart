import 'package:flutter/material.dart';

class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? prefixText;
  final String? Function(String?)? validator;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final ValueChanged<String>? onDropdownChanged;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.validator,
    this.isDropdown = false,
    this.dropdownItems,
    this.onDropdownChanged,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: _isFocused ? Colors.redAccent : Colors.grey.shade300,
        width: _isFocused ? 2.0 : 1.5,
      ),
    );

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: widget.isDropdown
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused ? Colors.redAccent : Colors.grey.shade300,
                  width: _isFocused ? 2.0 : 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.controller.text.isNotEmpty 
                        ? widget.controller.text 
                        : null,
                    hint: Row(
                      children: [
                        if (widget.prefixIcon != null)
                          Icon(
                            widget.prefixIcon,
                            color: Colors.grey.shade500,
                            size: 22,
                          ),
                        const SizedBox(width: 12),
                        Text(
                          widget.labelText,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade500,
                      size: 28,
                    ),
                    isExpanded: true,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    items: widget.dropdownItems?.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      widget.controller.text = newValue ?? '';
                      widget.onDropdownChanged?.call(newValue ?? '');
                      setState(() {});
                    },
                  ),
                ),
              ),
            )
          : TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  color: _isFocused ? Colors.redAccent : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused ? Colors.redAccent : Colors.grey.shade500,
                        size: 22,
                      )
                    : null,
                prefixText: widget.prefixText,
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(
                          widget.suffixIcon,
                          color: Colors.grey.shade500,
                          size: 22,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: _isFocused 
                    ? Colors.red.shade50 
                    : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
    );
  }
}
