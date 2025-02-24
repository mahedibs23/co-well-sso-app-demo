import 'package:flutter/widgets.dart';
import 'package:hello_flutter/presentation/theme/color/app_colors.dart';

enum ToastType {
  success,
  error,
  warning,
  info;

  Color getColor(BuildContext context) {
    switch (this) {
      case ToastType.success:
        return AppColors.of(context).customSuccess;
      case ToastType.error:
        return AppColors.of(context).customError;
      case ToastType.warning:
        return AppColors.of(context).customWarning;
      case ToastType.info:
        return AppColors.of(context).secondary;
    }
  }
}
