import '../../../app-export.dart';

class LeadActionBar extends StatelessWidget {
  final List<Map<String, dynamic>> actionIcons;

  const LeadActionBar({super.key, this.actionIcons = const []});

  @override
  Widget build(BuildContext context) {
    if (actionIcons.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actionIcons.asMap().entries.map((entry) {
        final iconData = entry.value;
        return Row(
          children: [
            ActionIcon(
              imagePath: iconData['imagePath'],
              tooltip: iconData['tooltip'],
              badgeCount: iconData['badgeCount'],
            ),
            if (entry.key < actionIcons.length - 1) SizedBox(width: 8.w),
          ],
        );
      }).toList(),
    );
  }
}

class ActionIcon extends StatelessWidget {
  final String imagePath;
  final String tooltip;
  final int? badgeCount;
  final VoidCallback? onTap;

  const ActionIcon({
    required this.imagePath,
    required this.tooltip,
    this.badgeCount,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                imagePath,
                width: 20.w,
              ),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: ColorConstants.whatsappGradientDark, // Replaced Colors.red
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12.w,
                    minHeight: 12.w,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount! > 99 ? "99+" : badgeCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}