import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final IconData suffixIcon;
  final String? selectedValue;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xfff7f8f9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2, color: const Color(0xffcbcbcb)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color(0xfff7f8f9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            hintText,
                            style: const TextStyle(
                              color: Color(0xFF797D80),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                title: Text(item,
                                    style: const TextStyle(fontSize: 14)),
                                onTap: () {
                                  onChanged(item);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(
                selectedValue ?? hintText,
                style: const TextStyle(
                  color: Color(0xFF797D80),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Icon(
            suffixIcon,
            color: const Color(0xFF707A83),
            size: 20,
          ),
        ],
      ),
    );
  }
}