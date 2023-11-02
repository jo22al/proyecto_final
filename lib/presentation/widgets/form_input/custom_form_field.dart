import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placeHolder;
  final Widget labelText;
  final String? Function(String?)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    Key? key,
    required this.icon,
    required this.placeHolder,
    this.onChanged,
    this.onTap,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.initialValue,
    this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]),
      child: TextFormField(
          autocorrect: false,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          initialValue: widget.initialValue,
          controller: widget.controller,
          decoration: InputDecoration(
              label: widget.labelText,
              prefixIcon: Icon(widget.icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: widget.placeHolder,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null),
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator),
    );
  }
}
