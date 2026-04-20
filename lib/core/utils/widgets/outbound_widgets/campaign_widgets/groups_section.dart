import 'package:flutter/material.dart';
import '../../../../../core/app-export.dart';
import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';

class GroupsSection extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final bool isDark;

  const GroupsSection(
      {super.key, required this.controller, required this.isDark});

  // Function to estimate the required height for a group name
  double _calculateItemHeight(BuildContext context, String groupName) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: groupName,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: MediaQuery.of(context).size.width / 2 -
            32.w); // Approximate max width per item

    // Base height + extra height based on text lines
    const baseHeight = 80.0; // Base height for icon, contacts, and padding
    final textHeight = textPainter.height;
    return baseHeight + textHeight; // Add text height to base height
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Groups (${controller.groups.length})',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.poppins,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.blue.shade600,
                size: 26.sp,
              ),
              onPressed: () {
                controller
                    .showGroupBottomSheet(context); // Pass 'context' here!
              },
              splashRadius: 20.r,
              tooltip: 'Add Group',
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Obx(() {
          if (controller.groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_add,
                    size: 30.sp,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'To start your campaign,\n first add at least one group.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.poppins,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final int crossCount = controller.groups.length <= 2 ? 1 : 2;
            final double crossSpacing = 8.w;
            // Calculate the maximum item height based on the longest group name
            double maxItemHeight = 100.h; // Default height
            for (var group in controller.groups) {
              final itemHeight =
                  _calculateItemHeight(context, group['name'].toString());
              maxItemHeight =
                  maxItemHeight > itemHeight ? maxItemHeight : itemHeight;
            }
            final double gridHeight =
                crossCount * maxItemHeight + (crossCount - 1) * crossSpacing;
            final double availableWidth =
                MediaQuery.of(context).size.width - 32.w;
            final double mainSpacing = 8.h;
            const double numVisible = 2;
            final double totalSpacing = mainSpacing * (numVisible - 1);
            final double itemWidth =
                (availableWidth - totalSpacing) / numVisible;
            final double childAspectRatio = maxItemHeight / itemWidth;
            final int k =
                (controller.groups.length + crossCount - 1) ~/ crossCount;

            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: crossSpacing,
                  mainAxisSpacing: mainSpacing,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  int remappedIndex = index;
                  if (crossCount > 1) {
                    final int row = index % crossCount;
                    final int col = index ~/ crossCount;
                    remappedIndex = row * k + col;
                  }
                  if (remappedIndex >= controller.groups.length) {
                    return const SizedBox();
                  }
                  final group = controller.groups[remappedIndex];
                  return GestureDetector(
                    onTap: () {
                      controller.showContactsBottomSheet(
                        context,
                        group['sId'],
                        group['name'],
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12.w),
                      margin:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.15 : 0.1),
                            blurRadius: 8.r,
                            offset: const Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.shade200,
                          width: 1.w,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      color: group['color'].withOpacity(0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: group['color'].withOpacity(0.5),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.group,
                                      color: group['color'],
                                      size: 14.sp,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: Text(
                                        '${group['contacts']}',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppFonts.poppins,
                                          color: isDark
                                              ? const Color(0xFFAEAEB2)
                                              : const Color(0xFF636366),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Flexible(
                                child: Text(
                                  group['name'].toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.poppins,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomRemoveGroupDialog(
                                      groupName: group['name'],
                                      groupId: group['sId'],
                                      onRemove: () async {
                                        await controller
                                            .deleteCampaignGroup(group['sId']);
                                      },
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.delete_outline,
                                color: isDark ? Colors.white70 : Colors.black54,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ],
    );
  }
}
