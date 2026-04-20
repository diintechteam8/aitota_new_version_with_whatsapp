import 'package:aitota_business/views/myDial/grid_flow/call_logs/analytics/call_analytics_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/calls_scree.dart';
import '../../../../core/app-export.dart';
import 'controller/call_logs_controller.dart';

class CallLogsScreen extends GetView<CallLogsController> {
  const CallLogsScreen({super.key});

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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          CustomTabBar(
            backgroundColor: null,
            decoration: const BoxDecoration(
              gradient: whatsappGradient,
            ),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            tabs: const [
              Tab(text: 'Calls', icon: Icon(Icons.call)),
              Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                CallsScreen(),
                CallAnalyticsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
