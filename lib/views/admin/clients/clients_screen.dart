import '../../../core/app-export.dart';
import 'controller/clients_controller.dart';

class ClientsScreen extends GetView<ClientsController> {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Clients",
        showBackButton: true,
        titleStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.poppins),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: controller.clients.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final c = controller.clients[index];
            return ClientCard(
              name: c.name,
              category: c.category,
              totalAgents: c.totalAgents,
              logoAsset: c.logoAsset,
              onTap: () {
                // Navigate or show details if needed
              },
            );
          },
        ),
      ),
    );
  }
}
