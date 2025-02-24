import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';

Widget basicLoadingDialog({bool shouldCancelOnBackPress = false}) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (_, __) => Future.value(
      shouldCancelOnBackPress,
    ),
    child: const Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(),
            SizedBox(
              height: 15,
            ),
            Text('Loading...')
          ],
        ),
      ),
    ),
  );
}
