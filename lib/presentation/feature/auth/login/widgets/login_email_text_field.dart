import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';

class LoginEmailTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const LoginEmailTextField({
    required this.textEditingController,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        border: const OutlineInputBorder(),
        labelText:
            context.localizations.login__login_form__email_field_label_text,
        hintText: context
            .localizations.login__login_form__email_field_placeholder_text,
        errorText: errorText,
      ),
    );
  }
}
