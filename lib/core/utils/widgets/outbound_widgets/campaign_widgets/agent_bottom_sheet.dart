import '../../../../../views/ai_agent/controller/ai_agent_controller.dart';
import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';
import '../../../../app-export.dart';

class AgentBottomSheet extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final BuildContext context;

  const AgentBottomSheet({super.key, required this.controller, required this.context});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aiAgentController = Get.find<AiAgentController>(tag: 'AiAgentController');

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Obx(() {
          final activeAgents = aiAgentController.agents
              .where((agent) => agent['status'] == 'Active')
              .toList();

          final isLoading = controller.isLoading.value || aiAgentController.isLoading.value;

          return Container(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Agent',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close,
                                color: isDark ? Colors.white70 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Loading State
                    if (isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    else if (activeAgents.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text('No active agents available'),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: activeAgents.length,
                          itemBuilder: (context, index) {
                            final agent = activeAgents[index];
                            final agentId = agent['_id'] ?? agent['id'];
                            final agentTitle = agent['title']?.toString() ?? 'Unknown';
                            final isAlreadyAdded = controller.agents
                                .any((a) => a['agentId'] == agentId);

                            return RadioListTile<String>(
                              value: agentId,
                              groupValue: controller.selectedAgents.isNotEmpty
                                  ? controller.selectedAgents.first['agentId']
                                  : null,
                              activeColor: Colors.green,
                              title: Text(agentTitle),
                              subtitle: Text(agent['callingType']?.toString() ?? 'Unknown'),
                              onChanged: isAlreadyAdded
                                  ? null
                                  : (val) {
                                      controller.selectedAgents.assignAll([
                                        {
                                          'name': agentTitle,
                                          'agentId': agentId,
                                          'status': agent['callingType'] ?? 'Unknown',
                                          'color': agent['iconColor'] ?? Colors.grey,
                                        }
                                      ]);
                                    },
                            );
                          },
                        ),
                      ),

                    // Confirm Button
                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.selectedAgents.isEmpty
                                ? null
                                : () {
                                    final selected = controller.selectedAgents.first;
                                    if (!controller.agents.any(
                                        (a) => a['agentId'] == selected['agentId'])) {
                                      controller.agents.add(selected);
                                    }
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Confirm Agent',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}