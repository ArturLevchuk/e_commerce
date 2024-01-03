import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';

class PasswordTextForm extends StatefulWidget {
  const PasswordTextForm({
    super.key,
    required this.onSaved,
    required this.validator,
    required this.onChanged,
    this.text = "Password",
  });
  final Function(String? newValue) onSaved;
  final String? Function(String? value) validator;
  final Function(String value) onChanged;
  final String text;

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  final FocusNode focusNode = FocusNode();

  bool obscureText = true;
  bool fieldIsActive = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          fieldIsActive = true;
        } else {
          fieldIsActive = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: roundInputDecoration.copyWith(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          widget.text,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
        suffixIcon: obscureIcon(),
        suffixIconColor: fieldIsActive
            ? Theme.of(context).textTheme.headline1?.color
            : kSecondaryColor,
      ),
      obscureText: obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTapOutside: (_) {
        focusNode.unfocus();
      },
    );
  }

  GestureDetector obscureIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      child: RPadding(
        padding: const EdgeInsets.fromLTRB(
          0,
          20,
          20,
          20,
        ),
        child: obscureText
            ? const Icon(Icons.lock_outline)
            : const Icon(Icons.lock_open),
      ),
    );
  }
}

class EmailTextForm extends StatefulWidget {
  const EmailTextForm({
    super.key,
    required this.onSaved,
    required this.validator,
    required this.onChanged,
  });
  final Function(String? newValue) onSaved;
  final String? Function(String? value) validator;
  final Function(String value) onChanged;

  @override
  State<EmailTextForm> createState() => _EmailTextFormState();
}

class _EmailTextFormState extends State<EmailTextForm> {
  final FocusNode focusNode = FocusNode();
  bool fieldIsActive = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          fieldIsActive = true;
        } else {
          fieldIsActive = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
      ],
      decoration: roundInputDecoration.copyWith(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          "Email",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
        suffixIcon: RPadding(
          padding: const EdgeInsets.fromLTRB(
            0,
            20,
            20,
            20,
          ),
          child: Icon(
            Icons.mail_outline,
            color: fieldIsActive
                ? Theme.of(context).textTheme.headline1?.color
                : kSecondaryColor,
          ),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTapOutside: (_) {
        focusNode.unfocus();
      },
    );
  }
}

class TextFormFieldRounded extends StatefulWidget {
  const TextFormFieldRounded({
    super.key,
    required this.text,
    required this.onSaved,
    required this.validator,
    required this.onChanged,
    required this.icon,
    this.inputFormatters,
    this.keyboardType,
  });
  final String text;
  final Function(String? newValue) onSaved;
  final String? Function(String? value) validator;
  final Function(String value) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final IconData icon;
  final TextInputType? keyboardType;
  @override
  State<TextFormFieldRounded> createState() => _TextFormFieldRoundedState();
}

class _TextFormFieldRoundedState extends State<TextFormFieldRounded> {
  final FocusNode focusNode = FocusNode();
  bool fieldIsActive = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          fieldIsActive = true;
        } else {
          fieldIsActive = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: roundInputDecoration.copyWith(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          widget.text,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
        suffixIcon: RPadding(
          padding: const EdgeInsets.fromLTRB(
            0,
            20,
            20,
            20,
          ),
          child: Icon(
            widget.icon,
            color: fieldIsActive
                ? Theme.of(context).textTheme.headline1?.color
                : kSecondaryColor,
          ),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTapOutside: (_) {
        focusNode.unfocus();
      },
    );
  }
}
