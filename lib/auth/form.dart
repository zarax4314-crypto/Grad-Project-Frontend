import 'package:flutter/material.dart';

class FForm extends StatefulWidget {
  final String label;
  final bool ispass;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;

  const FForm({
    super.key,
    required this.label,
    this.ispass = false,
    required this.validator,
    required this.controller,
    this.errorText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  State<FForm> createState() => _FFormState();
}

class _FFormState extends State<FForm> {
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.ispass ? obsecure : false,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: widget.hintText ?? widget.label,
          hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey)
              : null,
          suffixIcon: widget.ispass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obsecure = !obsecure;
                    });
                  },
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      obsecure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xffE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xffE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xff2F6FED)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}