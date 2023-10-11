import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDividerComponent extends StatelessWidget {
  String? text;

  CustomDividerComponent({super.key, this.text});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.grey,
              height: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text ?? '',
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.grey,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
