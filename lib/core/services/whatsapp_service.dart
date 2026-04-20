import 'package:dio/dio.dart';
import 'package:aitota_business/data/model/outbound/icons/whatsapp/send_message_model.dart';
import 'package:aitota_business/data/model/outbound/icons/whatsapp/get_message_model.dart';
import 'package:aitota_business/data/model/outbound/icons/whatsapp/get_templates_model.dart';

class WhatsAppService {
  WhatsAppService._internal()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://whatsapp-template-module.onrender.com/api/',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      validateStatus: (_) => true,
    ),
  );

  static final WhatsAppService _instance = WhatsAppService._internal();
  factory WhatsAppService() => _instance;

  final Dio _dio;

  Future<SendWhatsappMessageModel> sendMessage({
    required String to,
    required String message,
  }) async {
    final payload = {'to': to, 'message': message};
    final res = await _dio.post('whatsapp/send-message', data: payload);
    if (res.statusCode == 200 || res.statusCode == 201) {
      if (res.data is Map<String, dynamic>) {
        return SendWhatsappMessageModel.fromJson(res.data as Map<String, dynamic>);
      }
      return SendWhatsappMessageModel(
        success: res.statusCode == 200 || res.statusCode == 201,
        message: 'Message sent',
      );
    }
    throw Exception('WhatsApp send failed: ${res.statusCode} ${res.data}');
  }

  Future<List<GetWhatsappMessageModel>> getMessages({
    required String phoneE164,
  }) async {
    final encoded = Uri.encodeComponent(phoneE164);
    final res = await _dio.get('chat/messages/$encoded');
    if (res.statusCode == 200) {
      final data = res.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => GetWhatsappMessageModel.fromJson(e))
            .toList();
      }
      throw Exception('Unexpected messages payload: ${res.data.runtimeType}');
    }
    throw Exception('WhatsApp get messages failed: ${res.statusCode}');
  }

  Future<GetTemplateModel> getTemplates() async {
    final res = await _dio.get('whatsapp/get-templates');
    if (res.statusCode == 200) {
      if (res.data is Map<String, dynamic>) {
        return GetTemplateModel.fromJson(res.data as Map<String, dynamic>);
      }
      throw Exception('Unexpected templates payload: ${res.data.runtimeType}');
    }
    throw Exception('Get templates failed: ${res.statusCode}');
  }

  Future<Response> sendTemplate({
    required String templateName,
    required String to,
  }) async {
    // Endpoint pattern: send-{name}, e.g. send-jansuraaj
    final path = 'whatsapp/send-$templateName';
    final res = await _dio.post(path, data: {
      'to': to,
    });
    if (res.statusCode == 200 || res.statusCode == 201) return res;
    throw Exception('Template send failed: ${res.statusCode} ${res.data}');
  }
}