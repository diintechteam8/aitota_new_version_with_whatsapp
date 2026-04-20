import 'package:aitota_business/core/app-export.dart';
import 'controller/my_dial_controller.dart';
import 'grid_flow/call_logs/call_logs_screen.dart';
import 'grid_flow/leads/my_dail_leads_screen.dart';
import 'grid_flow/myAssign/my_assign_screen.dart';
import 'grid_flow/reports/my_dial_reports_screen.dart';
import 'grid_flow/saleDone/my_dial_sale_screen.dart';

class MyDialScreen extends GetView<MyDialController> {
  const MyDialScreen({super.key});

  static const LinearGradient whatsappGradient = LinearGradient(
    colors: [
      ColorConstants.whatsappGradientDark,
      ColorConstants.whatsappGradientLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    // Removed role-based visibility → MyAssign always shown
    const bool showMyAssign = true;

    // Fixed tabs (MyAssign always at index 1)
    final tabs = [
      const Tab(text: 'Call Logs', icon: Icon(Icons.call)),
      const Tab(text: 'MyAssign', icon: Icon(Icons.assignment_ind)),
      const Tab(text: 'MyLeads', icon: Icon(Icons.person_add)),
      const Tab(text: 'MyReports', icon: Icon(Icons.analytics)),
      const Tab(text: 'MySales', icon: Icon(Icons.currency_rupee)),
    ];

    // Fixed views
    final tabViews = [
      const CallLogsScreen(),
      const MyAssignScreen(),
      const MyDialLeadsScreen(),
      const MyDialReportsScreen(),
      const MyDialSaleScreen(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: ColorConstants.homeBackgroundColor,
        appBar: const CustomAppBar(
          title: "MyDials",
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CustomTabBar(
                backgroundColor: null,
                decoration: const BoxDecoration(gradient: whatsappGradient),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: tabs,
                onTap: (index) {
                  // Fixed index mapping (no conditional logic)
                  switch (index) {
                    case 0:
                      controller.onCallLogsTap();
                      break;
                    case 1:
                      controller.onAssignTap();
                      break;
                    case 2:
                      controller.onLeadsTap();
                      break;
                    case 3:
                      controller.onReportsTap();
                      break;
                    case 4:
                      controller.onSalesTap();
                      break;
                  }
                },
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: tabViews,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}