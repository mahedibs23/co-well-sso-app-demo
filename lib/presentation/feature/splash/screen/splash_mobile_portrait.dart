import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/common/widget/asset_image_view.dart';
import 'package:hello_flutter/presentation/feature/splash/splash_view_model.dart';
import 'package:hello_flutter/presentation/values/app_assets.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class SplashMobilePortrait extends StatefulWidget {
  final SplashViewModel viewModel;

  const SplashMobilePortrait({required this.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => SplashMobilePortraitState();
}

class SplashMobilePortraitState extends BaseUiState<SplashMobilePortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: valueListenableBuilder(
        listenable: widget.viewModel.appInfo,
        builder: (context, value) {
          return Stack(
            children: [
              Center(
                child: AssetImageView(
                  filePath: AppAssets.appLogo,
                  width: Dimens.dimen_100,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.dimen_16),
                  child: Text(
                    "${context.localizations.app_info__app_version}: ${value?.version}, ${context.localizations.app_info__build_number} ${value?.buildNumber}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
