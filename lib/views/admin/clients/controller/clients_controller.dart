import 'package:aitota_business/core/app-export.dart';

class ClientItem {
  final String name;
  final String category;
  final int totalAgents;
  final String logoAsset;

  const ClientItem({
    required this.name,
    required this.category,
    required this.totalAgents,
    required this.logoAsset,
  });
}

class ClientsController extends GetxController {
  final clients = <ClientItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    clients.assignAll(const [
      ClientItem(
        name: 'AITota',
        category: 'Technology',
        totalAgents: 24,
        logoAsset: 'assets/images/aitota__logo.png',
      ),
      ClientItem(
        name: 'Gmail Suite',
        category: 'Productivity',
        totalAgents: 18,
        logoAsset: 'assets/images/gmail.png',
      ),
      ClientItem(
        name: 'Google',
        category: 'Search',
        totalAgents: 32,
        logoAsset: 'assets/images/google.png',
      ),
      ClientItem(
        name: 'Insta Shop',
        category: 'E-commerce',
        totalAgents: 12,
        logoAsset: 'assets/images/insta.png',
      ),
      ClientItem(
        name: 'YouTube Media',
        category: 'Entertainment',
        totalAgents: 27,
        logoAsset: 'assets/images/youtube.png',
      ),
    ]);
  }
}