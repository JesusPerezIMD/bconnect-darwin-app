import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({
    super.key,
    this.value,
    this.list,
    required this.onChanged,
    this.label,
  });

  final String? value;
  final List<String>? list;
  final Function(String?) onChanged;
  final String? label;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          DropdownButton<String>(
            isDense: true,
            isExpanded: true,
            value: widget.value ?? 'Todos',
            itemHeight: 48,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: Colors.grey[900],
            ),
            elevation: 18,
            style: TextStyle(color: Colors.grey[900]),
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
            onChanged: (String? value) {
              widget.onChanged(value);
            },
            items: widget.list!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.capitalize()), // Utiliza el método capitalize aquí
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
