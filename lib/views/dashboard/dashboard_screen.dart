import 'package:aitota_business/views/outbound/grid_flow/setting/controller/outbound_settings_controller.dart';
import '../../core/app-export.dart';
import '../../core/utils/widgets/app_widgets/custom_tab_bar.dart';
import '../../routes/app_routes.dart';
import '../inbound/grid_flow/conversations/controller/inbound_converstations_controller.dart';
import '../inbound/grid_flow/conversations/inbound_conversations_screen.dart';
import '../inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import '../inbound/grid_flow/leads/inbound_leads_screen.dart';
import '../inbound/grid_flow/reports/controller/inbound_reports_controller.dart';
import '../inbound/grid_flow/reports/inbound_reports_screen.dart';
import '../inbound/grid_flow/setting/inbound_settings_screen.dart';
import '../outbound/grid_flow/campaign/controller/outbound_campaign_controller.dart';
import '../outbound/grid_flow/campaign/outbound_campaign_screen.dart';
import '../outbound/grid_flow/contact/outbound_contact_screen.dart';
import '../outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import '../outbound/grid_flow/conversations/controller/outbound_conversations_controller.dart';
import '../outbound/grid_flow/conversations/outbound_conversations_screen.dart';
import '../outbound/grid_flow/leads/controller/outbound_leads_controller.dart';
import '../outbound/grid_flow/leads/outbound_leads_screen.dart';
import '../outbound/grid_flow/reports/controller/outbound_reports_controller.dart';
import '../outbound/grid_flow/reports/outbound_reports_screen.dart';
import '../outbound/grid_flow/setting/outbound_settings_screen.dart';
import 'controller/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  static LinearGradient whatsappGradient = LinearGradient(
    colors: [
      ColorConstants.whatsappGradientDark,
      ColorConstants.whatsappGradientLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstants.homeBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: whatsappGradient,
            ),
          ),
          title: Text(
            'Aitota Business',
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppFonts.playfair,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(70),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.person_sharp,
                  color: ColorConstants.whatsappGradientDark,
                  size: 28,
                ),
                onPressed: () => Get.toNamed(AppRoutes.moreScreen),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: Column(
          children: [
            /// Main Inbound/Outbound Tabs
            Container(
              decoration: BoxDecoration(
                gradient: whatsappGradient,
                boxShadow: const [
                  BoxShadow(
                    color: ColorConstants.whatsappGradientDark,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xCCFFFFFF),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'Inbound', icon: Icon(Icons.call_received)),
                  Tab(text: 'Outbound', icon: Icon(Icons.call_made)),
                ],
              ),
            ),

            /// Nested TabBarView
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  /// INBOUND (4 Tabs)
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        CustomTabBar(
                          backgroundColor: null,
                          decoration: BoxDecoration(
                            gradient: whatsappGradient,
                          ),
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.5),
                          tabs: const [
                            Tab(text: 'Leads', icon: Icon(Icons.person_add)),
                            Tab(text: 'Reports', icon: Icon(Icons.analytics)),
                            Tab(
                                text: 'Conversations',
                                icon: Icon(Icons.chat_bubble_outline_sharp)),
                            Tab(text: 'Settings', icon: Icon(Icons.settings)),
                          ],
                          onTap: (index) {
                            switch (index) {
                              case 0:
                                Get.find<InboundLeadsController>()
                                    .refreshLeads();
                                break;
                              case 1:
                                Get.find<InboundReportsController>()
                                    .refreshReports();
                                break;
                              case 2:
                                Get.find<InboundConversationsController>()
                                    .refreshConversations();
                                break;
                              case 3:
                                break;
                            }
                          },
                        ),
                        Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: const TabBarView(
                              children: [
                                InboundLeadsScreen(),
                                InboundReportsScreen(),
                                InboundConversationsScreen(),
                                InboundSettingsScreen(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// OUTBOUND (5 Tabs - AI Leads Removed)
                  DefaultTabController(
                    length: 6, // Updated: was 6
                    child: Column(
                      children: [
                        CustomTabBar(
                          isScrollable: true,
                          backgroundColor: null,
                          decoration: BoxDecoration(
                            gradient: whatsappGradient,
                          ),
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.5),
                          tabs: const [
                            Tab(text: 'Leads', icon: Icon(Icons.person_add)),
                            Tab(
                                text: 'Campaign',
                                icon: Icon(Icons.campaign_outlined)),
                            Tab(
                                text: 'Users',
                                icon: Icon(Icons.supervised_user_circle_sharp)),
                            Tab(text: 'Reports', icon: Icon(Icons.analytics)),
                            Tab(
                                text: 'Conversations',
                                icon: Icon(Icons.chat_bubble)),
                            Tab(text: 'Settings', icon: Icon(Icons.settings)),
                          ],
                          onTap: (index) {
                            switch (index) {
                              case 0:
                                Get.find<OutboundLeadsController>()
                                    .refreshLeads();
                                break;
                              case 1:
                                Get.find<OutboundCampaignController>()
                                    .fetchAllOutboundCampaigns();
                                break;
                              case 2:
                                // Initialize and fetch contacts for Users tab
                                try {
                                  var contactController =
                                      Get.find<AddContactController>();
                                  contactController.fetchWhatsAiContacts();
                                } catch (e) {
                                  var contactController =
                                      Get.put(AddContactController());
                                  contactController.fetchWhatsAiContacts();
                                }
                                break;
                              case 3:
                                Get.find<OutboundReportsController>()
                                    .refreshReports();
                                break;
                              case 4:
                                Get.find<OutboundConversationsController>()
                                    .refreshConversations();
                              case 5:
                                Get.find<OutboundSettingsController>();
                                break;
                              // No case 5 (Settings) → no refresh needed
                            }
                          },
                        ),
                        Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: const TabBarView(
                              children: [
                                OutboundLeadsScreen(),
                                OutboundCampaignScreen(),
                                OutboundContactScreen(),
                                OutboundReportsScreen(), // index 3
                                OutboundConversationsScreen(), // index 4
                                OutboundSettingsScreen(), // index 5 → now correct
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
