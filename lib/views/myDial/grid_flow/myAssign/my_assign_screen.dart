import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/direct_groups_screen.dart';
import '../../../outbound/grid_flow/ai_leads/ai_leads_screen.dart';

class MyAssignScreen extends StatelessWidget {
  const MyAssignScreen({super.key});

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
              Tab(text: 'Direct', icon: Icon(Icons.person)),
              Tab(text: 'AiLeads', icon: Icon(Icons.auto_awesome_outlined)),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                DirectGroupScreen(),
                AiLeadsCampaignScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
