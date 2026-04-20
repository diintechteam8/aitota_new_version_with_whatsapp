import 'package:aitota_business/core/app-export.dart';
import 'controller/top_talked_controller.dart';

class TopTalkedScreen extends GetView<TopTalkedController> {
  const TopTalkedScreen({super.key});

  String _getTitle() {
    return controller.type.value == 'duration'
        ? 'Top 10 Call Duration'
        : 'Top 10 Frequently Talked';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: _getTitle(),
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Tabs
            Obx(() => _buildTabBar()),

            // List
            Expanded(child: Obx(() => _buildList())),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _tab(0, Icons.phone, 'All', controller.allCalls.length)),
          SizedBox(width: 12.w),
          Expanded(child: _tab(1, Icons.phone_callback, 'Incoming', controller.incomingCalls.length, color: const Color(0xFF8BC34A))),
          SizedBox(width: 12.w),
          Expanded(child: _tab(2, Icons.phone_forwarded, 'Outgoing', controller.outgoingCalls.length, color: const Color(0xFFFFA726))),
        ],
      ),
    );
  }

  Widget _tab(int index, IconData icon, String label, int count, {Color? color}) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.black : (color ?? Colors.grey), size: 22.sp),
          SizedBox(height: 4.h),
          Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(height: 4.h),
          if (isSelected) Container(height: 2.h, width: 30.w, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildList() {
    final contacts = controller.getCurrentTabData();
    final isDuration = controller.type.value == 'duration';

    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator(color: ColorConstants.appThemeColor));
    }

    if (contacts.isEmpty) {
      return Center(
        child: Text(
          'No calls found',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: contacts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final c = contacts[i];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFFFFA726),
                child: Icon(Icons.person, color: Colors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                    Text(c.phoneNumber, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Text(
                isDuration ? c.totalDuration : '${c.callCount} Call${c.callCount > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}