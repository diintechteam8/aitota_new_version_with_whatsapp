// filter_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterHeaderWidget extends StatelessWidget {
  final RxString selectedFilter;
  final RxString selectedRange;
  final VoidCallback onFilterTap;

  const FilterHeaderWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedRange,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8E8E8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Date/Time that can wrap
          Expanded(
            child: Obx(() => Text(
                  selectedRange.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                )),
          ),

          const SizedBox(width: 10),

          // Right: Filter Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedFilter.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
