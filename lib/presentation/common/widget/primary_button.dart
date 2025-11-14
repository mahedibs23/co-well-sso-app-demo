import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double? minWidth;
  final IconData? leadingIcon;
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    this.leadingIcon,
    required this.label,
    required this.onPressed,
    this.padding,
    this.minWidth,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: minWidth,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? Dimens.dimen_100),
        ),
      ),
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Dimens.dimen_48,
            vertical: Dimens.dimen_16,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null)
            Icon(
              leadingIcon,
              size: Dimens.dimen_18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          if (leadingIcon != null) SizedBox(width: Dimens.dimen_8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
