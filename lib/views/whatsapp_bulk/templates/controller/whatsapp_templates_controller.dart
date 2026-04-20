import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import '../../../../core/services/whatsapp_service.dart';
import '../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';

class WhatsAppTemplatesController extends GetxController {
  final WhatsAppService _whatsappService = WhatsAppService();
  
  RxBool isLoading = false.obs;
  RxList<GetTemplateModelTemplates> allTemplates = <GetTemplateModelTemplates>[].obs;
  RxList<GetTemplateModelTemplates> filteredTemplates = <GetTemplateModelTemplates>[].obs;
  
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchTemplates();
    
    // Listen to search query changes
    debounce(searchQuery, (_) => filterTemplates(), time: const Duration(milliseconds: 300));
  }

  Future<void> fetchTemplates() async {
    isLoading.value = true;
    try {
      // Static Mock Data for demonstration
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockTemplates = [
        GetTemplateModelTemplates(
          sId: "1",
          name: "order_confirmation",
          category: "UTILITY",
          status: "approved",
          language: "en_US",
          components: [
            GetTemplateModelComponents(
              type: "BODY",
              text: "Hello {{1}}, your order #{{2}} has been confirmed and will be shipped soon. Thank you for shopping with us!"
            )
          ]
        ),
        GetTemplateModelTemplates(
          sId: "2",
          name: "festival_offer",
          category: "MARKETING",
          status: "approved",
          language: "hi",
          components: [
            GetTemplateModelComponents(
              type: "BODY",
              text: "नमस्ते {{1}}, इस दिवाली पाइए शानदार छूट! हमारे नए कलेक्शन पर 50% तक का डिस्काउंट। अभी शॉपिंग करें।"
            )
          ]
        ),
        GetTemplateModelTemplates(
          sId: "3",
          name: "otp_verification",
          category: "AUTHENTICATION",
          status: "approved",
          language: "en",
          components: [
            GetTemplateModelComponents(
              type: "BODY",
              text: "Your verification code is {{1}}. This code will expire in 5 minutes. Do not share it with anyone."
            )
          ]
        ),
        GetTemplateModelTemplates(
          sId: "4",
          name: "abandoned_cart",
          category: "MARKETING",
          status: "pending",
          language: "en_GB",
          components: [
            GetTemplateModelComponents(
              type: "BODY",
              text: "Hi {{1}}, you left some items in your cart. Come back and complete your purchase to get free shipping!"
            )
          ]
        ),
      ];

      allTemplates.assignAll(mockTemplates);
      filteredTemplates.assignAll(mockTemplates);
    } catch (e) {
      print("Error loading static templates: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterTemplates() {
    if (searchQuery.isEmpty) {
      filteredTemplates.assignAll(allTemplates);
    } else {
      filteredTemplates.assignAll(
        allTemplates.where((template) =>
          (template.name ?? "").toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (template.category ?? "").toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList()
      );
    }
  }
}
