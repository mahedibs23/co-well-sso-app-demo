import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';

class LoginPasswordTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const LoginPasswordTextField({
    required this.textEditingController,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  @override
  State<LoginPasswordTextField> createState() => _LoginPasswordTextFieldState();
}

class _LoginPasswordTextFieldState extends BaseUiState<LoginPasswordTextField> {
  ValueNotifier<bool> passwordVisibilityState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return valueListenableBuilder(
      listenable: passwordVisibilityState,
      builder: (context, isPasswordVisible) {
        return TextField(
          controller: widget.textEditingController,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            labelText: context
                .localizations.login__login_form__password_field_label_text,
            hintText: context.localizations
                .login__login_form__password_field_placeholder_text,
            errorText: widget.errorText,
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () => passwordVisibilityState.value =
                  !passwordVisibilityState.value,
            ),
          ),
          obscureText: !isPasswordVisible,
        );
      },
    );
  }
}
