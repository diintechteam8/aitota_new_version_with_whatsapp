import 'package:aitota_business/core/app-export.dart';

import '../../../../core/services/whatsapp_service.dart';
import '../../../../data/model/outbound/icons/whatsapp/get_message_model.dart';
import '../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';

class InboundWhatsappChatController extends GetxController {

  late final String phoneE164;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  // Templates state
  final templates = <GetTemplateModelTemplates>[].obs;
  final isTemplatesLoading = false.obs;
  final selectedTemplateNames = <String>[].obs;
  DateTime? _templatesFetchedAt;

  final _wa = WhatsAppService();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is String && arg.isNotEmpty) {
      phoneE164 = arg;
    } else if (arg is Map) {
      if (arg['mobile'] is String && (arg['mobile'] as String).isNotEmpty) {
        phoneE164 = arg['mobile'] as String;
      } else if (arg['lead'] != null && arg['lead'].mobile is String && (arg['lead'].mobile as String).isNotEmpty) {
        phoneE164 = arg['lead'].mobile as String;
      } else {
        phoneE164 = '+000';
      }
    } else {
      phoneE164 = '+000';
    }
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      isLoading.value = true;
      List<GetWhatsappMessageModel> remote = [];
      for (final candidate in _phoneCandidates(phoneE164)) {
        try {
          remote = await _wa.getMessages(phoneE164: candidate);
          if (remote.isNotEmpty) break;
        } catch (_) {}
      }
      messages.assignAll(remote.map((m) {
        final direction = (m.direction ?? '');
        final text = (m.text ?? '');
        final ts = (m.timestamp ?? '');
        return {
          'text': text,
          'time': _formatTime(ts),
          'isSentByUser': direction == 'sent',
        };
      }));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMessages() async {
    await _loadMessages();
  }

  // Bottom sheet to choose templates


  // Bottom sheet to choose templates
  Future<void> openTemplatesSheet() async {
    // Open immediately
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(() {
          if (isTemplatesLoading.value && templates.isEmpty) {
            return const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (templates.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text('No templates found')),
            );
          }
          return SizedBox(
            height: 380,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: const [
                      Icon(Icons.view_list, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Templates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: templates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final t = templates[i];
                      final name = t.name ?? '';
                      final category = t.category ?? '';
                      final isSelected = selectedTemplateNames.contains(name);
                      return InkWell(
                        onTap: () => _onTemplateTap(t),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFF4CAF50) : Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.article_outlined, color: Colors.black54, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(category, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                color: isSelected ? const Color(0xFF4CAF50) : Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
    );

    // Fetch in background if first time or cache stale (>60s)
    final isStale = _templatesFetchedAt == null ||
        DateTime.now().difference(_templatesFetchedAt!) > const Duration(seconds: 60);
    if (templates.isEmpty || isStale) {
      _fetchTemplates(); // do not await
    }
  }

  Future<void> _fetchTemplates() async {
    try {
      isTemplatesLoading.value = true;
      final res = await _wa.getTemplates();
      templates.assignAll(res.templates ?? []);
      _templatesFetchedAt = DateTime.now();
    } catch (e) {
      if (templates.isEmpty) {
        templates.clear();
      }
      Get.snackbar('Error', 'Failed to fetch templates');
    } finally {
      isTemplatesLoading.value = false;
    }
  }


  Future<void> _onTemplateTap(GetTemplateModelTemplates template) async {
    try {
      isSending.value = true;
      // 1) Call template send API (server-side knows how to render by name)
      final templateName = (template.name ?? '').trim();
      if (templateName.isEmpty) return;
      await _wa.sendTemplate(templateName: templateName, to: phoneE164);

      // 2) Compose a human-readable message locally from components for chat list & history API
      final textToSend = _composeFromComponents(template.components ?? []);
      if (textToSend.isNotEmpty) {
        // Also call plain send API so history endpoint tracks this message
        await _wa.sendMessage(to: phoneE164, message: textToSend);

        final now = DateTime.now();
        final time = _formatLocal(now);
        messages.add({
          'text': textToSend,
          'time': time,
          'isSentByUser': true,
        });
      }

      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send template');
    } finally {
      isSending.value = false;
    }
  }

  String _composeFromComponents(List<GetTemplateModelComponents> comps) {
    final parts = <String>[];
    String? urlToAppend;

    for (final c in comps) {
      final type = (c.type ?? '').toUpperCase();
      switch (type) {
        case 'HEADER':
          if ((c.text ?? '').trim().isNotEmpty) parts.add(c.text!.trim());
          break;
        case 'BODY':
          if ((c.text ?? '').trim().isNotEmpty) parts.add(c.text!.trim());
          break;
        case 'FOOTER':
          if ((c.text ?? '').trim().isNotEmpty) parts.add(c.text!.trim());
          break;
        case 'BUTTONS':
          final buttons = c.buttons ?? [];
          for (final b in buttons) {
            if ((b.type ?? '').toUpperCase() == 'URL' && (b.url ?? '').trim().isNotEmpty) {
              urlToAppend = b.url!.trim();
              break;
            }
          }
          break;
        default:
          break;
      }
    }

    if (urlToAppend != null) parts.add(urlToAppend);
    return parts.where((e) => e.trim().isNotEmpty).join('\n');
  }

  Future<void> sendMessage() async {
    final content = textController.text.trim();
    try {
      isSending.value = true;

      if (selectedTemplateNames.isNotEmpty) {
        // Send ONLY the template name(s) as text
        final textToSend = selectedTemplateNames.join(' ').trim();
        if (textToSend.isNotEmpty) {
          await _wa.sendMessage(to: phoneE164, message: textToSend);
          final now = DateTime.now();
          final time = _formatLocal(now);
          messages.add({
            'text': textToSend,
            'time': time,
            'isSentByUser': true,
          });
        }
        selectedTemplateNames.clear();
        textController.clear();
      } else {
        if (content.isEmpty) return;
        await _wa.sendMessage(to: phoneE164, message: content);
        final now = DateTime.now();
        final time = _formatLocal(now);
        messages.add({
          'text': content,
          'time': time,
          'isSentByUser': true,
        });
        textController.clear();
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isSending.value = false;
    }
  }

  List<String> _phoneCandidates(String input) {
    final candidates = <String>{};
    final trimmed = input.trim();
    if (trimmed.isNotEmpty) candidates.add(trimmed);

    final digits = trimmed.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.isNotEmpty) candidates.add(digits);

    if (!digits.startsWith('+') && digits.length >= 10) {
      if (digits.length == 10) {
        candidates.add('+91$digits');
      }
      if (digits.length > 10) {
        candidates.add('+$digits');
      }
    }

    return candidates.toList(growable: false);
  }

  String _formatTime(String isoOrDate) {
    try {
      final dt = DateTime.tryParse(isoOrDate)?.toLocal();
      if (dt == null) return isoOrDate;
      return _formatLocal(dt);
    } catch (_) {
      return isoOrDate;
    }
  }

  String _formatLocal(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}