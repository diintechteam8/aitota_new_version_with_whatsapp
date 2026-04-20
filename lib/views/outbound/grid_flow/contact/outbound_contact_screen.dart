import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/controller/outbound_contact_controller.dart';
import '../../../../core/app-export.dart';
import 'add_contact/add_contact_screen.dart';
import 'group/contact_group_screen.dart';

class OutboundContactScreen extends GetView<OutboundContactController> {
  const OutboundContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddContactController());
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstants.white,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              TabBar(
                indicatorColor: ColorConstants.appThemeColor,
                labelColor: ColorConstants.appThemeColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'Groups'),
                  Tab(text: 'Contacts'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(), // 👈 disables swipe
                  children: [
                    ContactGroupScreen(),
                    AddContactScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
