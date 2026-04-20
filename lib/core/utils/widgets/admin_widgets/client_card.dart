import 'dart:ui';
import 'package:aitota_business/core/app-export.dart';

class ClientCard extends StatelessWidget {
  final String name;
  final String category;
  final int totalAgents;
  final String logoAsset;
  final VoidCallback? onTap;

  const ClientCard({
    super.key,
    required this.name,
    required this.category,
    required this.totalAgents,
    required this.logoAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorConstants.white,
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Compact Logo Box
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary.withOpacity(0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        logoAsset,
                        fit: BoxFit.contain,
                        height: 28,
                        width: 28,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontFamily: AppFonts.poppins,fontWeight: FontWeight.w500,fontSize: 16.sp),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildChip(
                              icon: Icons.category_rounded,
                              label: category,
                              color: theme.colorScheme.primary,
                              theme: theme,
                            ),
                            const SizedBox(width: 6),
                            _buildChip(
                              icon: Icons.group_rounded,
                              label: "$totalAgents",
                              color: theme.colorScheme.secondary,
                              theme: theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontFamily: AppFonts.poppins,fontWeight: FontWeight.w500,fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}