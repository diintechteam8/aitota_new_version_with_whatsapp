import '../../../app-export.dart';

class DrawerTabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const DrawerTabButton({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected
                ? ColorConstants.appThemeColor.withOpacity(0.08)
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? ColorConstants.appThemeColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected
                      ? ColorConstants.appThemeColor
                      : Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 13,
                  color: selected
                      ? ColorConstants.appThemeColor
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leading;
  final IconData trailing;
  final VoidCallback onTap;
  final bool inactive;
  final bool showStatusBadge;
  final bool? isStatusActive;

  const DrawerListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.trailing,
    required this.onTap,
    this.inactive = false,
    this.showStatusBadge = false,
    this.isStatusActive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: inactive
                          ? null
                          : LinearGradient(
                              colors: [
                                ColorConstants.appThemeColor,
                                ColorConstants.appThemeColor1,
                              ],
                            ),
                      color: inactive ? Colors.grey.shade400 : null,
                    ),
                    child: Icon(leading, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: inactive
                                ? Colors.grey.shade500
                                : ColorConstants.appThemeColor,
                          ),
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty)
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 13,
                              color: inactive
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(trailing,
                      color: inactive
                          ? Colors.grey.shade400
                          : ColorConstants.appThemeColor),
                ],
              ),
            ),
            if (showStatusBadge)
              Positioned(
                right: 16,
                top: 12,
                child: Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: (isStatusActive == true)
                        ? LinearGradient(
                            colors: [
                              ColorConstants.appThemeColor,
                              ColorConstants.appThemeColor1,
                            ],
                          )
                        : null,
                    color:
                        (isStatusActive == true) ? null : Colors.red.shade400,
                    boxShadow: [
                      BoxShadow(
                        color: (isStatusActive == true)
                            ? ColorConstants.appThemeColor.withOpacity(0.3)
                            : Colors.red.shade400.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
