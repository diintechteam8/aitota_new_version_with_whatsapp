import '../../../core/app-export.dart';
import 'controller/associated_clients_controller.dart';
import '../../../data/model/more/get_team_clients.dart';

class AssociatedClientsScreen extends GetView<AssociatedClientsController> {
  const AssociatedClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Associated Clients",
        showBackButton: true,
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.associatedClients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64.w,
                    color: ColorConstants.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Associated Clients Found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You don\'t have any associated clients yet.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.loadAssociatedClients,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.associatedClients.length,
              itemBuilder: (context, index) {
                final client = controller.associatedClients[index];
                return _buildClientCard(client);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildClientCard(Association client) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor:
                      ColorConstants.appThemeColor.withOpacity(0.1),
                  child: Text(
                    client.clientName?.substring(0, 1).toUpperCase() ?? 'C',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.appThemeColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.clientName ?? 'Unknown Client',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ID: ${client.clientUserId ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (client.isApproved == true)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Approved',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.appThemeColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 16.w,
                  color: ColorConstants.grey,
                ),
                SizedBox(width: 8.w),
                Text(
                  client.type ?? 'Client',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: AppFonts.poppins,
                    color: ColorConstants.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.switchToClient(client),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.appThemeColor,
                  foregroundColor: ColorConstants.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'Login to Client',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
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