import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/leads_detail/controller/my_dial_leads_detail_controller.dart';
import '../../../../../routes/app_routes.dart';

class MyDialLeadsDetailScreen extends GetView<MyDialLeadsDetailController> {
  const MyDialLeadsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: CustomAppBar(
            title: controller.status,
            titleStyle: TextStyle(
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w500,
              color: ColorConstants.white,
              fontSize: 16.sp,
            ),
            showBackButton: true,
          ),
          body: controller.leads.isEmpty
              ? Center(
                  child: Text(
                    'No leads available',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.leads.length,
                  itemBuilder: (context, index) {
                    final lead = controller.leads[index];
                    return LeadCard(
                      mobile: lead.phoneNumber ?? 'Unknown',
                      contactName: lead.contactName,
                      time: lead.createdAt, // Pass raw createdAt stm ring
                      duration: 0, // Set to 0 since duration is not in LeadData
                      leadStatus: lead.leadStatus ?? controller.status,
                     // ... inside LeadCard onTap
onTap: () {
  Get.toNamed(
    AppRoutes.myDialLeadsStatusDetailScreen,
    arguments: {
      'lead': lead,                 // <-- the whole LeadData object
      'status': controller.status, // optional – the group title
    },
  );
},
                    );
                  },
                ),
        ));
  }
}
