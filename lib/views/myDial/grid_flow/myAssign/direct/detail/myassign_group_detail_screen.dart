// my_assign_group_detail_screen.dart
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'controller/myassign_group_detail_controller.dart';

class MyAssignGroupDetailScreen extends GetView<MyAssignGroupDetailController> {
  const MyAssignGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (controller.isSearchActive.value) {
          controller.toggleSearch();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: ColorConstants.white,
            appBar: CustomAppBar(
              title: "Assign Contacts",
              showBackButton: true,
              titleStyle: TextStyle(
                fontSize: 16.sp,
                color: ColorConstants.white,
                fontWeight: FontWeight.w500,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: ColorConstants.white),
                  onPressed: () => controller.fetchGroupContacts(reset: true),
                ),

              ],
            ),
            body: Column(
              children: [
                // Tabs
                Obx(() => TabBar(
                      onTap: (index) => controller.selectedTabIndex.value = index,
                      labelColor: ColorConstants.appThemeColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: ColorConstants.appThemeColor,
                      tabs: [
                        Tab(text: "Untouched (${controller.allUntouchedContacts.length})"),
                        Tab(text: "Touched (${controller.allTouchedContacts.length})"),
                      ],
                    )),

                // Main List + Summary Card
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.currentList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.currentList.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.fetchGroupContacts(reset: true),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemCount: controller.currentList.length +
                            (controller.hasMore.value ? 1 : 0) +
                            (controller.selectedTabIndex.value == 1 ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Summary Card - Only on Touched Tab
                          if (controller.selectedTabIndex.value == 1 && index == 0) {
                            return _buildInterestedSummaryCard();
                          }

                          final adjustedIndex = controller.selectedTabIndex.value == 1 ? index - 1 : index;

                          // Load More
                          if (adjustedIndex == controller.currentList.length) {
                            controller.fetchGroupContacts();
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final contact = controller.currentList[adjustedIndex];
                          final Map<String, dynamic> fullContactMap = contact.toJson();

                          final Map<String, dynamic> cardData = {
                            'id': contact.id ?? '',
                            'name': contact.name?.trim().isNotEmpty == true ? contact.name! : 'Unnamed',
                            'phone': contact.phone ?? 'N/A',
                            'email': contact.email ?? 'N/A',
                            'color': contact.dispositionStatus == 'disposed' ? Colors.green : Colors.orange,
                            'dispositionStatus': contact.dispositionStatus,
                            'lastLeadStatus': contact.lastLeadStatus,
                            'lastDispositionCategory': contact.lastDispositionCategory,
                            'lastDispositionSubCategory': contact.lastDispositionSubCategory,
                            'dispositionCount': contact.dispositionCount,
                            'lastDispositionAt': contact.lastDispositionAt,
                            'contact': contact,
                          };

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.contactDetailScreen,
                                  arguments: {
                                    'id': contact.id,
                                    'name': contact.name ?? 'Unnamed',
                                    'phone': contact.phone ?? 'N/A',
                                    'email': contact.email ?? 'N/A',
                                    'dispositionStatus': contact.dispositionStatus,
                                    'lastLeadStatus': contact.lastLeadStatus,
                                    'lastDispositionCategory': contact.lastDispositionCategory,
                                    'lastDispositionSubCategory': contact.lastDispositionSubCategory,
                                    'color': contact.dispositionStatus == 'disposed' ? Colors.green : Colors.orange,
                                    'rawContact': contact,
                                    'contactMap': fullContactMap,
                                  },
                                );
                              },
                              child: CustomAssignContactCard(
                                contact: cardData,
                                theme: theme,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildInterestedSummaryCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.shade300,  // Light grey border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up_rounded, color: ColorConstants.appThemeColor, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                "Interested Leads",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: ColorConstants.appThemeColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(Icons.whatshot, "Hot Leads", controller.touchedBreakdown['hotLeads'] ?? 0, Colors.red.shade600),
              _buildStatItem(Icons.local_fire_department, "Warm Leads", controller.touchedBreakdown['warmLeads'] ?? 0, Colors.orange.shade700),
              _buildStatItem(Icons.schedule, "Follow Up", controller.touchedBreakdown['followUp'] ?? 0, Colors.blue.shade600),
              _buildStatItem(Icons.check_circle, "Converted", controller.touchedBreakdown['convertedWon'] ?? 0, Colors.green.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, int count, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16.sp),
        SizedBox(height: 4.h),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: color,
             fontFamily: AppFonts.poppins
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.poppins
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchGroupContacts(reset: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: Get.height * 0.6,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 80.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Obx(() => Text(
                      controller.selectedTabIndex.value == 0
                          ? "No untouched contacts"
                          : "No touched contacts yet",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchGroupContacts(reset: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.appThemeColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}