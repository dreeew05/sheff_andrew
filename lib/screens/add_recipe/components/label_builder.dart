/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Label Builder for Recipe Form
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelBuilder extends StatelessWidget {
  final String title;
  final List<String> labels;
  final VoidCallback onAddPressed;
  final Function(int) onRemovePressed;

  const LabelBuilder({
    super.key,
    required this.title,
    required this.labels,
    required this.onAddPressed,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              const Spacer(),
              IconButton(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          if (labels.isNotEmpty) const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: labels.asMap().entries.map((entry) {
              int index = entry.key;
              String label = entry.value;
              return Container(
                padding: const EdgeInsets.only(
                    top: 2, bottom: 2, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  // Change to this if you prefer this design
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                      maxLines: 5,
                      label,
                      style: GoogleFonts.poppins(),
                      overflow: TextOverflow.ellipsis,
                    )),
                    IconButton(
                      onPressed: () => onRemovePressed(index),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
