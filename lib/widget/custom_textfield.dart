import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xfff7f8f9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2, color: const Color(0xffcbcbcb)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: const Color(0xffFF0000),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF797D80),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              style: const TextStyle(fontSize: 14),
              readOnly: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              prefixIcon,
              color: const Color(0xFF707A83),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}