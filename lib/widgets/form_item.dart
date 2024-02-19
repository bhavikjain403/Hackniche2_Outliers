import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomnom/utils/colors.dart';

class FormItem extends StatelessWidget {
  const FormItem(
      {Key? key,
      required this.question,
      required this.controller,
      this.maxLength,
      this.icon,
      this.onTap,
      this.textInputType = TextInputType.text,
      this.validator,
      this.isPwd})
      : super(key: key);

  final String question;
  final TextEditingController controller;
  final Function()? onTap;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Icon? icon;
  final bool? isPwd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: isPwd ?? false,
        maxLength: maxLength,
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        validator: validator,
        // style: Theme.of(context).inputDecorationTheme.counterStyle,
        keyboardType: textInputType,
        inputFormatters: [
          if (textInputType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          focusColor: AppColors.orangeAccent,
          prefixIcon: icon,
          labelText: question,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          //  isDense: true,
        ),
      ),
    );
  }
}
