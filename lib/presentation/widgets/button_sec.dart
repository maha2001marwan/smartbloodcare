import 'package:flutter/material.dart';
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final double elevation;
  final Gradient? gradient;
  final IconData? icon;

  const ModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.redAccent,
    this.textColor = Colors.white,
    this.height = 56,
    this.borderRadius = 16,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation = 0,
    this.gradient,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          if (!isDisabled && elevation > 0)
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey.shade300 : backgroundColor,
          foregroundColor: isDisabled ? Colors.grey.shade500 : textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(
                      leadingIcon,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      trailingIcon,
                      size: 22,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
