import 'dart:ui';

import 'package:flutter/material.dart';

Widget frostedGlassView({required Widget child}) {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        decoration:
            BoxDecoration(color: Colors.grey.shade200.withValues(alpha: 50)),
        child: child,
      ),
    ),
  );
}
