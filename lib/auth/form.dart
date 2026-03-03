import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FForm extends StatefulWidget {
  FForm({
    super.key,
    required this.label,
    this.ispass = false,
    required this.validator,
    required this.controller,
    this.errorText, // لازم تبقى property
  });

  String label;
  bool ispass;
  String? Function(String?)? validator;
  TextEditingController controller;
  String? errorText; // عشان نمرر الرسالة من برة

  @override
  State<FForm> createState() => _FFormState();
}

class _FFormState extends State<FForm> {
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.ispass ? obsecure : false,
        style: TextStyle(color: Colors.blue),
        decoration: InputDecoration(
          errorText: widget.errorText, // ✨ هنا المشكلة كانت
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
              ),
            ),
          )
              : null,
          label: Text(
            widget.label,
            style: TextStyle(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: CupertinoColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: CupertinoColors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: CupertinoColors.systemRed),
          ),
        ),
      ),
    );
  }
}
