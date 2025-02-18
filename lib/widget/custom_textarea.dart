import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomTextArea({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff7f8f9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2, color: const Color(0xffcbcbcb)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF797D80),
            fontWeight: FontWeight.normal,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}