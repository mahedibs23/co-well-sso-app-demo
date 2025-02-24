import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/common/widget/asset_image_view.dart';
import 'package:hello_flutter/presentation/common/widget/custom_spinner_loader.dart';
import 'package:hello_flutter/presentation/values/app_assets.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class AppLoadingIndicator extends StatelessWidget {
  /// Determines both height and width of the [AppLoadingIndicator]
  static double defaultSize = Dimens.dimen_56;

  /// Determines both height and width of the [AppLoadingIndicator.small]
  static double defaultSmallSize = Dimens.dimen_44;

  /// Determines the color of the loading indicator.
  ///
  /// By default, It will follow the primary color of the current theme.
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
  });

  /// Determines both height and width of the loader.
  final double? size;

  /// The width of the material loader stroke.
  final double? strokeWidth;

  factory AppLoadingIndicator.small({
    Color? color,
  }) {
    return AppLoadingIndicator(
      size: defaultSmallSize,
      strokeWidth: Dimens.dimen_2,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localizations;

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size ?? defaultSize,
            width: size ?? defaultSize,
            child: const CustomSpinnerLoader(
              child: AssetImageView(filePath: AppAssets.loader),
            ),
          ),
        ],
      ),
    );
  }
}
