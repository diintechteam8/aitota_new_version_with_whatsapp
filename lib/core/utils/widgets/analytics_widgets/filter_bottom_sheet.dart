// filter_bottom_sheet.dart
import '../../../app-export.dart';

abstract class FilterableController {
  RxString get selectedFilter;
  RxString get selectedFilterRange;
  void selectFilter(String filter);
  void updateCustomDateRange(DateTime? from, DateTime? to);
  void showFilterBottomSheet(BuildContext context);
}

class FilterBottomSheet extends StatelessWidget {
  final FilterableController controller;

  const FilterBottomSheet({super.key, required this.controller});

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final DateTime? from = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFFF9800)),
        ),
        child: child!,
      ),
    );

    if (from == null) return;

    final DateTime? to = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: from,
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFFF9800)),
        ),
        child: child!,
      ),
    );

    if (to != null) {
      controller.updateCustomDateRange(from, to);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Select Filter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.grey,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ),
              const Divider(height: 1),

              // ONLY 4 FILTERS
              Obx(() => Column(
                    children: [
                      _buildFilterOption('Today'),
                      _buildFilterOption('Yesterday'),
                      _buildFilterOption('Last 7 Days'),
                      _buildCustomFilterOption(context),
                    ],
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    final isSelected = controller.selectedFilter.value == label;

    return InkWell(
      onTap: () => controller.selectFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: isSelected ? const Color(0xFFFFF3E0) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color:
                  isSelected ? const Color(0xFFFF9800) : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? const Color(0xFF212121) : Colors.grey.shade800,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFilterOption(BuildContext context) {
    final isSelected = controller.selectedFilter.value == 'Custom';

    return InkWell(
      onTap: () => _showCustomDatePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: isSelected ? const Color(0xFFFFF3E0) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color:
                  isSelected ? const Color(0xFFFF9800) : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom Date',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF212121)
                          : Colors.grey.shade800,
                      fontFamily: AppFonts.poppins,
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Obx(() => Text(
                            controller.selectedFilterRange.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                              fontFamily: AppFonts.poppins,
                            ),
                          )),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
