import 'package:aitota_business/core/services/role_provider.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_contact_model.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_contacts_list_model.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_campaign_model.dart';
import 'package:aitota_business/data/model/AgentChatHistory/agent_chat_history_model.dart';
import 'package:aitota_business/data/model/AgentChatHistory/get_by_agent_id_chat_history_model.dart';
import 'package:aitota_business/data/model/CommonModel/common_model.dart';
import 'package:aitota_business/data/model/ai_agent/end_call_model.dart';
import 'package:aitota_business/data/model/ai_agent/live_call_logs_model.dart';
import 'package:aitota_business/data/model/auth_models/google_login_model.dart';
import 'package:aitota_business/data/model/auth_models/pending_approval_model.dart';
import 'package:aitota_business/data/model/auth_models/complete_profile_model.dart';
import 'package:aitota_business/data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import 'package:aitota_business/data/model/inbound/inbound_call_statics_model.dart';
import 'package:aitota_business/data/model/inbound/inbound_conversation_model.dart';
import 'package:aitota_business/data/model/myBusiness/add_my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/update_my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/upload_image_model.dart';
import 'package:aitota_business/data/model/myDial/add_disposition_model.dart';
import 'package:aitota_business/data/model/myDial/my_dial_leads_model.dart';
import 'package:aitota_business/data/model/myDial/my_dial_reports_model.dart';
import 'package:aitota_business/data/model/myDial/sale_done_model.dart';
import 'package:aitota_business/data/model/outbound/ai_leads/ai_leads_campaign_contacts_model.dart';
import 'package:aitota_business/data/model/outbound/ai_leads/ai_leads_campaigns_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/add_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/add_group_in_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/campaign_call_stats_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/campaign_completed_call_logs_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/campaign_completed_call_table_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/get_all_groups_in_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/get_contacts_in_group_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/outbound_campaign_detail_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/start_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/stop_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/sync_groups_model.dart';
import 'package:aitota_business/data/model/outbound/outbound_call_statics_reports_model.dart';
import 'package:aitota_business/data/model/outbound/outbound_conversations_model.dart';
import 'package:aitota_business/data/model/outbound/outbound_leads_model.dart';
import 'package:aitota_business/data/model/outbound/users/add_contact_model.dart';
import 'package:aitota_business/data/model/outbound/users/create_group_model.dart';
import 'package:aitota_business/data/model/outbound/users/sync_contacts_model.dart';
import 'package:aitota_business/data/model/outbound/users/update_group_model.dart';
import 'package:aitota_business/data/model/payment/add_recharge_model.dart';
import 'package:aitota_business/data/team_models/outbound/users/group_contacts_model.dart';
import 'package:aitota_business/data/team_models/outbound/users/team_groups_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../data/model/ai_agent/history_call_logs_model.dart';
import '../../data/model/auth_models/admin_clients_model.dart';
import '../../data/model/auth_models/get_all_profiles_model.dart';
import '../../data/model/auth_models/get_profile_model.dart';
import '../../data/model/auth_models/update_user_profile_model.dart';
import '../../data/model/inbound/inbound_lead_conversations_model.dart';
import '../../data/model/inbound/settings/ai_agent/update_ai_agent_model.dart';
import '../../data/model/inbound/settings/business_info/update_business_info_model.dart';
import '../../data/model/myDial/call_filter_response_model.dart';
import '../../data/model/myDial/upload_call_logs_model.dart';
import '../../data/model/outbound/ai_leads/get_ai_leads_campaign_contacts_logs_model.dart';
import '../../data/model/outbound/campaign/get_all_campaing_model.dart';
import '../../data/model/outbound/campaign/get_contacts_group_campaign_model.dart';
import '../../data/model/outbound/campaign/live_campaign_call_log_model.dart';
import '../../data/model/outbound/campaign/update_campaign_campaign_model.dart';
import '../../data/model/outbound/users/outbound_all_group_model.dart';
import '../../data/model/auth_models/google_profiles_response.dart';
import '../../data/model/auth_models/switch_role_response.dart';
import '../../data/model/auth_models/email_login_model.dart';
import '../../data/model/auth_models/register_step1_model.dart';
import '../../data/model/auth_models/otp_models.dart';
import '../../data/model/auth_models/check_email_model.dart';
import '../../data/model/auth_models/register_step3_model.dart';
import '../../data/model/auth_models/forgot_password_model.dart';
import '../constants/constants.dart';
import 'api_endpoints.dart';
import 'api_repository.dart';
import 'package:aitota_business/data/model/more/get_all_human_agents.dart';
import 'package:aitota_business/data/model/more/get_team_clients.dart';
import '../../data/model/auth_models/client_token_model.dart';
import '../../data/model/myDial/analysis_models/call_analytics_summary_model.dart';
import '../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';

class ApiService implements ApiRepository {
  final Dio dio;
  final RoleProvider? roleProvider;
  ApiService({required this.dio, this.roleProvider});

  @override
  Future<GoogleLoginModel> googleLogin(Map<String, dynamic> request) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.userGoogleLogin}',
      );
      final response = await dio.post(
        ApiEndpoints.userGoogleLogin,
        data: request,
      );
      print("GoogleLoginResponse: ${response.data}");
      if (response.statusCode == 200) {
        final model = GoogleLoginModel.fromJson(response.data);
        return model;
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CheckEmailResponse> checkEmail(CheckEmailRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.checkEmail}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("CheckEmailResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckEmailResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e, stackTrace) {
      print('========= CHECK EMAIL DIO ERROR =========');
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Stack Trace: $stackTrace');
      print('=========================================');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e, stackTrace) {
      print('========= CHECK EMAIL GENERAL ERROR =========');
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      print('=============================================');
      throw Exception(e.toString());
    }
  }

  @override
  Future<RegisterStep3Response> registerStep3(RegisterStep3Request request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.registerStep3}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("RegisterStep3Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterStep3Response.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordRequest(ForgotPasswordRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.forgotPasswordRequest}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("ForgotPasswordResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgotPasswordResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordResendOtp(ForgotPasswordRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.forgotPasswordResendOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("ForgotPasswordResendResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgotPasswordResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<VerifyForgotPasswordOtpResponse> verifyForgotPasswordOtp(VerifyForgotPasswordOtpRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.verifyForgotPasswordOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("VerifyForgotPasswordOtpResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerifyForgotPasswordOtpResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.resetPassword}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("ResetPasswordResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgotPasswordResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<EmailLoginResponse> loginWithEmail(EmailLoginRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.emailLogin}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("EmailLoginResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return EmailLoginResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<CommonResponseModel> forgotPasswordRequest(Map<String, dynamic> request) async {
  //   try {
  //     final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.forgotPasswordRequest}";
  //     print('Calling URL: $url');
  //     print("Request Data: $request");
  //     final response = await dio.post(url, data: request);
  //     print("ForgotPasswordResponse: ${response.data}");
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return CommonResponseModel.fromJson(response.data);
  //     } else {
  //       throw Exception('Backend error: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     String detailedError = e.message ?? 'Unknown error';
  //     final data = e.response?.data;
  //     if (data is Map && data.containsKey('message')) {
  //       detailedError = data['message'].toString();
  //     }
  //     throw Exception('API Error: $detailedError');
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  @override
  Future<RegisterStep1Response> registerStep1(RegisterStep1Request request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.registerStep1}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("RegisterStep1Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterStep1Response.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OtpResponse> verifyEmailOtp(VerifyEmailOtpRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.verifyEmailOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("VerifyEmailOtpResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OtpResponse> sendMobileOtp(SendMobileOtpRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.sendMobileOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("SendMobileOtpResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OtpResponse> verifyMobileOtp(VerifyMobileOtpRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.verifyMobileOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("VerifyMobileOtpResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OtpResponse> resendEmailOtp(ResendEmailOtpRequest request) async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.resendEmailOtp}";
      print('Calling URL: $url');
      print("Request Data: ${request.toJson()}");
      final response = await dio.post(url, data: request.toJson());
      print("ResendEmailOtpResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      String detailedError = e.message ?? 'Unknown error';
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        detailedError = data['message'].toString();
      }
      throw Exception('API Error: $detailedError');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Google profiles discovery (POST)
  Future<GoogleProfilesResponse> getGoogleProfiles(String googleIdToken) async {
    try {
      final String url =
          'https://aitotabackend-sih2.onrender.com/api/v1/client/google/profiles';
      print('Calling URL: $url');
      print('Request data: {"token": "$googleIdToken"}');

      final response = await dio.post(url, data: {
        "token": googleIdToken,
        "clientId": Constants.clientId,
      });
      print("GoogleProfilesResponse: ${response.data}");

      if (response.statusCode == 200) {
        return GoogleProfilesResponse.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e, stackTrace) {
      print('========= GET GOOGLE PROFILES DIO ERROR =========');
      print('DioException: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('Stack Trace: $stackTrace');
      print('=================================================');
      throw Exception('API Error: ${e.message}');
    } catch (e, stackTrace) {
      print('========= GET GOOGLE PROFILES GENERAL ERROR =========');
      print('General Exception: $e');
      print('Stack Trace: $stackTrace');
      print('=====================================================');
      throw Exception(e.toString());
    }
  }

  /// Roles: get available profiles for current user (GET)
  Future<GetAllProfilesModel> getAllProfiles() async {
    try {
      // Use the authenticated dio instance instead of creating a plain one
      final String url =
          'https://aitotabackend-sih2.onrender.com/api/v1/client/auth/profiles';

      // Debug
      print('Calling URL (roles): $url');
      final response = await dio.get(url);
      print("GetAllProfies: ${response.data}");
      if (response.statusCode == 200) {
        return GetAllProfilesModel.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Roles: switch active role (POST)
  Future<SwitchRoleResponse> switchRole(Map<String, dynamic> payload) async {
    try {
      // Use Render dev host explicitly for switch API
      final String url =
          'https://aitotabackend-sih2.onrender.com/api/v1/client/auth/switch';

      print("SwitchRole API - URL: $url");
      print("SwitchRole API - Payload: $payload");

      final response = await dio.post(url, data: payload);
      print("SwitchRole API - Response: ${response.data}");

      if (response.statusCode == 200) {
        return SwitchRoleResponse.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      print("SwitchRole API - DioException: ${e.message}");
      print("SwitchRole API - Response data: ${e.response?.data}");
      print("SwitchRole API - Status code: ${e.response?.statusCode}");
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      print("SwitchRole API - General error: $e");
      throw Exception(e.toString());
    }
  }

  /// Select a specific Google profile (POST)
  Future<GoogleProfilesResponse> selectGoogleProfile(
      Map<String, dynamic> payload) async {
    try {
      final String url =
          'https://aitotabackend-sih2.onrender.com/api/v1/client/google/select';
      print('Calling URL: $url');
      print('Request data: $payload');

      final response = await dio.post(url, data: payload);
      print("SelectGoogleProfileResponse: ${response.data}");

      if (response.statusCode == 200) {
        return GoogleProfilesResponse.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('DioException response: ${e.response?.data}');
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<CompleteProfileModel> userRegister(Map<String, dynamic> request) async {
    try {
      print('Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.userRegister}');
      final response = await dio.post(ApiEndpoints.userRegister, data: request);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CompleteProfileModel.fromJson(response.data);
      } else {
        return CompleteProfileModel(
          success: false,
          message: response.statusMessage.toString(),
        );
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<PendingApprovalModel> getPendingApproval() async {
    try {
      final url = "${ApiEndpoints.newBaseUrl}${ApiEndpoints.pendingApproval}";
      print('Calling URL: $url');

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return PendingApprovalModel.fromJson(response.data);
      } else {
        return PendingApprovalModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetProfileModel> getUserProfile(String profileId) async {
    final String endpoint = '${ApiEndpoints.getUserProfile}$profileId';
    try {
      print('Calling URL:$endpoint');

      final response = await dio.get(endpoint);
      print("Profile:${response.toString()}");
      if (response.statusCode == 200) {
        final model = GetProfileModel.fromJson(response.data);
        // If role info exists in profile, update RoleProvider → AppConfig
        final String? rawRole = (response.data is Map<String, dynamic>)
            ? (response.data['data']?['role'] ?? response.data['role'])
            : null;
        if (rawRole != null && roleProvider != null) {
          roleProvider!.setRole(rawRole.toString());
          // Debug ensure base URL switched
          // ignore: avoid_print
        }
        return model;
      } else {
        return GetProfileModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception("CampaignErr:${e.toString()}");
    }
  }

  Future<GetProfileModel> getUserProfileMainServer(String profileId) async {
    try {
      final String url =
          'https://app.aitota.com/api/v1/auth/client/profile/$profileId';
      print('Calling URL: $url');

      final response = await dio.get(url);
      print("GetUserProfileResponse: ${response.data}");

      if (response.statusCode == 200) {
        return GetProfileModel.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<InboundCallStaticsReportModel> getInboundCallStaticsReports({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getInboundCallStaticsReport;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) {
        queryParameters['filter'] = filter;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return InboundCallStaticsReportModel.fromJson(response.data);
      } else {
        return InboundCallStaticsReportModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<InboundConversationModel> getInboundConversations({
    String? filter,
    String? startDate,
    String? endDate,
    int page = 1, // Add page parameter
  }) async {
    try {
      final String url = ApiEndpoints.getInboundConversations;
      final Map<String, dynamic> queryParameters = {'page': page.toString()};
      if (filter != null) {
        queryParameters['filter'] = filter;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return InboundConversationModel.fromJson(response.data);
      } else {
        return InboundConversationModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<InboundLeadConversationsModel> getInboundLeads({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getInboundLeads;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) queryParameters['filter'] = filter;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );
      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return InboundLeadConversationsModel.fromJson(response.data);
      } else {
        return InboundLeadConversationsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetAllAgentsModel> getAllAgents() async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getInboundClientAgent}',
      );

      final response = await dio.get(ApiEndpoints.getInboundClientAgent);

      if (response.statusCode == 200) {
        return GetAllAgentsModel.fromJson(response.data);
      } else {
        return GetAllAgentsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateInboundAiAgentModel> updateInboundAiAgent(
    Map<String, dynamic> request,
    String agentId,
  ) async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.updateInboundAiAgent}$agentId';

      print('Calling PUT URL: $url');
      final response = await dio.put(url, data: request);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateInboundAiAgentModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to update AI agent. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<SyncContactsModel> syncUserContacts(
    List<Map<String, String>> contacts,
  ) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.syncUserContacts}',
      );

      final response = await dio.post(
        ApiEndpoints.syncUserContacts,
        data: {"contacts": contacts},
      );

      if (response.statusCode == 201) {
        return SyncContactsModel.fromJson(response.data);
      } else {
        return SyncContactsModel(
          status: false,
          message: "Unexpected status code: ${response.statusCode}",
          results: null,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // return SyncContactsModel(
        //   status: false,
        //   message: 'All contacts already exist',
        //   results: null,
        // );
      }
      return SyncContactsModel(
        status: false,
        message: e.response?.data['message'] ?? 'Failed to sync contacts',
        results: null,
      );
    }
  }

  @override
  Future<UpdateInboundBusinessInfoModel> updateInboundBusinessInfo(
    Map<String, dynamic> request,
    String agentId,
  ) async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.updateInboundBusinessInfo}/$agentId';

      print('Calling PUT URL: $url');
      final response = await dio.put(url, data: request);

      if (response.statusCode == 200) {
        return UpdateInboundBusinessInfoModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to update business info. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<OutboundCreateGroupModel> createGroup(
    Map<String, dynamic> request,
  ) async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.outboundCreateGroup}';
      print('Calling URL: $url');
      final response = await dio.post(
        url,
        data: request,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return OutboundCreateGroupModel.fromJson(response.data);
      } else {
        return OutboundCreateGroupModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OutboundAllGroupModel> getOutboundGroups() async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getOutboundGroups}',
      );

      final response = await dio.get(ApiEndpoints.getOutboundGroups);
      if (response.statusCode == 200) {
        return OutboundAllGroupModel.fromJson(response.data);
      } else {
        return OutboundAllGroupModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteOutboundGroup(String userId) async {
    try {
      final finalUrl =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.deleteOutboundGroups}$userId';
      print(
        'Calling URL: $finalUrl',
      );
      final response = await dio.delete(finalUrl);
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateOutboundGroupModel> updateOutboundGroups(
    String groupId,
    Map<String, dynamic> request,
  ) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.updateOutboundGroups}$groupId',
      );
      final response = await dio.put(
        '${ApiEndpoints.updateOutboundGroups}$groupId',
        data: request,
      );
      if (response.statusCode == 200) {
        return UpdateOutboundGroupModel.fromJson(response.data);
      } else {
        return UpdateOutboundGroupModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddContactModel> addContactInGroup(
    Map<String, dynamic> request,
    String groupId,
  ) async {
    final url = ApiEndpoints.addContactInGroup(groupId);
    print('Calling URL: ${ApiEndpoints.baseUrl}$url');

    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}$url',
        data: request,
      );
      if (response.statusCode == 200) {
        return AddContactModel.fromJson(response.data);
      } else {
        return AddContactModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteContactInGroup(
    String groupId,
    String contactId,
  ) async {
    final url = ApiEndpoints.deleteContactsInGroup(groupId, contactId);
    print('Calling URL: ${ApiEndpoints.baseUrl}$url');

    try {
      final response = await dio.delete('${ApiEndpoints.baseUrl}$url');
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MyBusinessModel> getMyBusinesses() async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getMyBusinesses}',
      );
      final response = await dio.get(ApiEndpoints.getMyBusinesses);
      if (response.statusCode == 200) {
        return MyBusinessModel.fromJson(response.data);
      } else {
        return MyBusinessModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddDispositionCallLogsModel> addDispositionCallLogs(
    Map<String, dynamic> request,
  ) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.addDispositionCallLogs}',
      );
      final response = await dio.post(
        ApiEndpoints.addDispositionCallLogs,
        data: request,
      );
      print("addDispostion1:${response.toString()}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        return AddDispositionCallLogsModel.fromJson(response.data);
      } else {
        return AddDispositionCallLogsModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetDialLeadsModel> getDialLeads({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getDialLeads;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) queryParameters['filter'] = filter;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        print("addDispostion2:${response.toString()}");
        return GetDialLeadsModel.fromJson(response.data);
      } else {
        return GetDialLeadsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetDialReportsModel> getDialReports({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getDialReports;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) queryParameters['filter'] = filter;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);
      print("addDispostion3:${response.toString()}");
      if (response.statusCode == 200) {
        return GetDialReportsModel.fromJson(response.data);
      } else {
        return GetDialReportsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddMyBusinessModel> addMyBusiness(Map<String, dynamic> request) async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.addMyBusiness}';
      print('Calling URL: $url');

      final response = await dio.post(url, data: request);

      print("MyAdd: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddMyBusinessModel.fromJson(response.data);
      } else {
        return AddMyBusinessModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<UpdateMyBusinessModel> updateMyBusiness(
    FormData request,
    String id,
  ) async {
    final String url = '${ApiEndpoints.updateMyBusiness}$id';

    try {
      print('Calling URL: ${ApiEndpoints.baseUrl}$url');
      final response = await dio.put(
        '${ApiEndpoints.baseUrl}$url',
        data: request,
      );
      if (response.statusCode == 200) {
        return UpdateMyBusinessModel.fromJson(response.data);
      } else {
        return UpdateMyBusinessModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UploadImageModel> uploadUrlInMyBusiness({
    required String fileName,
    required String fileType,
  }) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.uploadUrlInMyBusiness}?fileName=$fileName&fileType=$fileType',
      );

      final response = await dio.get(
        ApiEndpoints.uploadUrlInMyBusiness,
        queryParameters: {'fileName': fileName, 'fileType': fileType},
      );
      if (response.statusCode == 200) {
        return UploadImageModel.fromJson(response.data);
      } else {
        return UploadImageModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<HistoryCallLogsModel> getHistoryCallLogs(String agentId) async {
    final url = ApiEndpoints.getHistoryCallLogs(agentId);
    print('Calling URL: ${ApiEndpoints.baseUrl}$url');

    try {
      final response = await dio.get('${ApiEndpoints.baseUrl}$url');
      if (response.statusCode == 200) {
        return HistoryCallLogsModel.fromJson(response.data);
      } else {
        return HistoryCallLogsModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<LiveCallLogsModel> getLiveCallLogs(String uniqueId) async {
    final url = ApiEndpoints.getLiveCallLogs; // e.g., "/api/v1/logs"
    final fullUrl = '${ApiEndpoints.baseUrl}$url';

    // Debug print
    print('Calling URL: $fullUrl?uniqueid=$uniqueId');

    try {
      final response = await dio.get(
        fullUrl,
        queryParameters: {'logs': uniqueId},
      );

      if (response.statusCode == 200) {
        return LiveCallLogsModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch live call logs: Status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'API Error: ${e.response?.statusCode} - ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<SaleDoneModel> getSaleDone({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getSaleDone;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) queryParameters['filter'] = filter;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );
      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return SaleDoneModel.fromJson(response.data);
      } else {
        return SaleDoneModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<EndCallModel> endCall(Map<String, dynamic> request) async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.endCall}';
      print('Calling URL: $url');
      final response = await dio.post(url, data: request);

      if (response.statusCode == 200) {
        return EndCallModel.fromJson(response.data);
      } else {
        return EndCallModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<GetAllOutboundCampaignsModel> getAllOutboundCampaigns() async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getAllOutboundCampaigns}',
      );

      final response = await dio.get(ApiEndpoints.getAllOutboundCampaigns);
      if (response.statusCode == 200) {
        return GetAllOutboundCampaignsModel.fromJson(response.data);
      } else {
        return GetAllOutboundCampaignsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddCampaignCampaignModel> createOutboundCampaign(
    Map<String, dynamic> request,
  ) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.addOutboundCampaign}',
      );

      final response = await dio.post(
        ApiEndpoints.addOutboundCampaign,
        data: request,
      );
      if (response.statusCode == 201) {
        return AddCampaignCampaignModel.fromJson(response.data);
      } else {
        return AddCampaignCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateCampaignModel> updateOutboundCampaign(
    Map<String, dynamic> request,
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.updateOutboundCampaign}$campaignId";

      print("Calling URL: $url");

      final response = await dio.put(url, data: request);
      if (response.statusCode == 200) {
        return UpdateCampaignModel.fromJson(response.data);
      } else {
        return UpdateCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteOutboundCampaign(String campaignId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.deleteOutboundCampaign}$campaignId";

      print("Calling URL: $url");

      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetOutboundCampaignDetailModel> getOutboundCampaignById(
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.updateOutboundCampaign}$campaignId";

      print("Calling URL: $url");

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return GetOutboundCampaignDetailModel.fromJson(response.data);
      } else {
        return GetOutboundCampaignDetailModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddGroupInCampaignModel> addGroupsInCampaign(
    Map<String, dynamic> request,
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.addGroupsInCampaign(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.post(url, data: request);
      if (response.statusCode == 200) {
        return AddGroupInCampaignModel.fromJson(response.data);
      } else {
        return AddGroupInCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetAllGroupsCampaignModel> getCampaignsAllGroup(
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getAllGroupsInCampaign(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return GetAllGroupsCampaignModel.fromJson(response.data);
      } else {
        return GetAllGroupsCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteCampaignGroup(
    String campaignId,
    String groupId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.deleteGroupsInCampaign(campaignId, groupId)}";

      print("Calling URL: $url");

      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetContactsInGroupsCampaignModel> getCampaignContacts(
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignContacts(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return GetContactsInGroupsCampaignModel.fromJson(response.data);
      } else {
        return GetContactsInGroupsCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetContactsInGroupModel> getCampaignContactsByGroupId(
    String groupId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignContactByGroupId}$groupId";

      print("Calling URL: $url");

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return GetContactsInGroupModel.fromJson(response.data);
      } else {
        return GetContactsInGroupModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SyncGroupsModel> syncContactGroups(String campaignId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.syncContactsInGroup(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.post(url);
      if (response.statusCode == 200) {
        return SyncGroupsModel.fromJson(response.data);
      } else {
        return SyncGroupsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<StartCampaignModel> startCampaign(
    Map<String, dynamic> request,
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.startCampaign(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.post(url, data: request);
      if (response.statusCode == 200) {
        return StartCampaignModel.fromJson(response.data);
      } else {
        return StartCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<StopCampaignModel> stopCampaign(
    Map<String, dynamic> request,
    String campaignId,
  ) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.stopCampaign(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.post(url, data: request);
      if (response.statusCode == 200) {
        return StopCampaignModel.fromJson(response.data);
      } else {
        return StopCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CampaignCompletedCallTableModel> getCompletedCallsTable(
    String campaignId, {
    int page = 1,
  }) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignCompletedCallsTable(campaignId)}?page=$page";
      print("🔗 Calling URL: $url");
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final model = CampaignCompletedCallTableModel.fromJson(response.data);
        if (model.completedCalls != null && model.completedCalls!.isNotEmpty) {
          final first = model.completedCalls!.first;
          print(
            "👉 First Call => Name: ${first.name}, Number: ${first.number}, Status: ${first.leadStatus}",
          );
        }
        return model;
      } else {
        return CampaignCompletedCallTableModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

@override
Future<CampaignCompletedCallLogsModel> getCompletedCallsLogs(
  String campaignId,
  String documentId,
) async {
  try {
    // Build the correct endpoint with documentId as PATH parameter
    final String endpoint =
        '/client/campaigns/$campaignId/logs/$documentId';

    print("Calling URL: ${dio.options.baseUrl}$endpoint");

    final response = await dio.get(endpoint);

    return CampaignCompletedCallLogsModel.fromJson(response.data);
  } on DioException catch (e) {
    // Proper error logging
    final errorMsg = e.response?.data ?? e.message;
    print("API Error: $errorMsg");
    throw Exception('Failed to fetch call logs: $errorMsg');
  } catch (e) {
    print("Unexpected error: $e");
    rethrow;
  }
}

  @override
  Future<CampaignCallStatsModel> getCampaignCallStats(String campaignId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignCallStats(campaignId)}";

      print("Calling URL: $url");

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return CampaignCallStatsModel.fromJson(response.data);
      } else {
        return CampaignCallStatsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OutboundCallStaticsReportModel> getOutboundCallStaticsReports({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getIOutboundCallStaticsReport;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) {
        queryParameters['filter'] = filter;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return OutboundCallStaticsReportModel.fromJson(response.data);
      } else {
        return OutboundCallStaticsReportModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OutboundLeadsModel> getOutboundLeads({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final String url = ApiEndpoints.getOutboundLeads;

      final Map<String, dynamic> queryParameters = {};
      if (filter != null) {
        queryParameters['filter'] = filter;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return OutboundLeadsModel.fromJson(response.data);
      } else {
        return OutboundLeadsModel(success: false);
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<OutboundConversationsModel> getOutboundConversations({
    String? filter,
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    try {
      final String url = ApiEndpoints.getOutboundConversations;
      final Map<String, dynamic> queryParameters = {'page': page.toString()};
      if (filter != null) {
        queryParameters['filter'] = filter;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      print(
        'Calling URL: ${ApiEndpoints.baseUrl}$url${queryParameters.isNotEmpty ? '?${Uri(queryParameters: queryParameters).query}' : ''}',
      );

      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return OutboundConversationsModel.fromJson(response.data);
      } else {
        return OutboundConversationsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteMyBusiness(String businessId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.deleteMyBusiness}$businessId";

      print("Calling URL: $url");

      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetLiveCampaignCallLogsModel> getCampaignLiveCallsLogs(
      String uniqueId) async {
    try {
      final url = "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignLiveLogs}";

      print("Calling URL: $url?uniqueid=$uniqueId");

      final response = await dio.get(
        url,
        queryParameters: {"uniqueid": uniqueId},
      );
      if (response.statusCode == 200) {
        return GetLiveCampaignCallLogsModel.fromJson(response.data);
      } else {
        return GetLiveCampaignCallLogsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> getAgentName(String agentId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getAgentName(agentId)}";

      print("Calling URL: $url");

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AgentChatHistoryModel> getAiAgentChatHistory(String clientId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getAiAgentChatHistory}$clientId";

      print("Client ID: $clientId");
      print("Calling URL: $url");

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        return AgentChatHistoryModel.fromJson(response.data);
      } else {
        return AgentChatHistoryModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetByAgentIdChatHistoryModel> getByAiAgentChatHistoryDetail(
      String clientId, String agentId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getByAiAgentIdChatHistory}";

      print("Calling URL: $url?clientId=$clientId&agentId=$agentId");

      final response = await dio.get(
        url,
        queryParameters: {"clientId": clientId, "agentId": agentId},
      );
      if (response.statusCode == 200) {
        return GetByAgentIdChatHistoryModel.fromJson(response.data);
      } else {
        return GetByAgentIdChatHistoryModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AddRechargeModel> addRechargePlan(Map<String, dynamic> request) async {
    try {
      print(
        'Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.addRechargePlan}',
      );

      final response = await dio.post(
        ApiEndpoints.addRechargePlan,
        data: request,
      );
      if (response.statusCode == 200) {
        return AddRechargeModel.fromJson(response.data);
      } else {
        return AddRechargeModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateUserProfileModel> updateUserProfile(
      String userId, Map<String, dynamic> request) async {
    try {
      final finalUrl =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.updateUserProfile}$userId';
      print('Calling URL: $finalUrl');

      final response = await dio.put(
        finalUrl,
        data: request,
      );
      if (response.statusCode == 200) {
        return UpdateUserProfileModel.fromJson(response.data);
      } else {
        return UpdateUserProfileModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetTeamGroupsModel> getAllTeamsGroups({String? owner}) async {
    try {
      final base = '${ApiEndpoints.getTeamGroups}';
      final url = owner == null || owner.isEmpty ? base : '$base?owner=$owner';
      print('Calling URL: $url');

      final response = await dio.get(
        base,
        queryParameters:
            owner == null || owner.isEmpty ? null : {'owner': owner},
      );
      print("${response.toString()}");
      if (response.statusCode == 200) {
        return GetTeamGroupsModel.fromJson(response.data);
      } else {
        return GetTeamGroupsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

 @override
Future<GetTeamGroupContactsModel> getTeamGroupContacts(
  String groupId, {
  required int page,
  required int limit,
}) async {
  final url = ApiEndpoints.getTeamGroupContacts(groupId);

  print('Calling URL: ${ApiEndpoints.baseUrl}$url?page=$page&limit=$limit');

  try {
    final response = await dio.get(
      '${ApiEndpoints.baseUrl}$url',
      queryParameters: {
        "page": page,
        "limit": limit,
      },
    );

    print("ContactResponse:${response.toString()}");

    if (response.statusCode == 200) {
      return GetTeamGroupContactsModel.fromJson(response.data);
    } else {
      return GetTeamGroupContactsModel(success: false);
    }
  } on DioException catch (e) {
    throw Exception('API Error: ${e.message}');
  } catch (e) {
    throw Exception(e.toString());
  }
}


  @override
  Future<AILeadsCampaignModel> getAiLeadsCampaign() async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.getAiLeadsCampaign}';
      print('Calling URL: $url');

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return AILeadsCampaignModel.fromJson(response.data);
      } else {
        return AILeadsCampaignModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AiLeadsCampaignContactsModel> getAiLeadsCampaignContacts(
      String campaignId) async {
    try {
      final url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAiLeadsCampaignContacts}';
      print('Calling URL: $url?campaignId=$campaignId');

      final response = await dio.get(
        url,
        queryParameters: {'campaignId': campaignId},
      );

      if (response.statusCode == 200) {
        return AiLeadsCampaignContactsModel.fromJson(response.data);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  @override
  Future<GetAiLeadsCampaignContactsLogsModel> getAiLeadsCampaignContactLogs(
      String campaignId, String documentId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}${ApiEndpoints.getCampaignCompletedCallsLogs(campaignId)}";
      print("Calling URL: $url$documentId");
      final response = await dio.get(
        url,
        queryParameters: {"documentId": documentId},
      );

      if (response.statusCode == 200) {
        return GetAiLeadsCampaignContactsLogsModel.fromJson(response.data);
      } else {
        return GetAiLeadsCampaignContactsLogsModel();
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get human agents for client (GET)
  Future<GetAllHumanAgents> getHumanAgents() async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getHumanAgents}';
      print('Calling URL: $url');

      final response = await dio.get(url);
      print("HumanAgentsResponse: ${response.data}");

      if (response.statusCode == 200) {
        return GetAllHumanAgents.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get associated clients for human agent (GET)
  Future<GetTeamClients> getAssociatedClients() async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAssociatedClients}';
      print('Calling URL: $url');

      final response = await dio.get(url);
      print("AssociatedClientsResponse: ${response.data}");

      if (response.statusCode == 200) {
        return GetTeamClients.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get admin clients (GET)
  Future<AdminClientsModel> getAdminClients() async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAdminClients}';
      print('Calling URL: $url');

      final response = await dio.get(url);
      print("AdminClientsResponse: ${response.data}");

      if (response.statusCode == 200) {
        return AdminClientsModel.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get admin clients (GET) using provided admin token override
  Future<AdminClientsModel> getAdminClientsAsAdmin(String adminToken) async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAdminClients}';
      print('Calling URL (as admin): $url');

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $adminToken',
          },
          extra: {
            'authTokenOverride': adminToken,
          },
        ),
      );
      print("AdminClientsResponse (as admin): ${response.data}");

      if (response.statusCode == 200) {
        return AdminClientsModel.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get client token by client ID (legacy GET)
  Future<ClientTokenModel> getClientToken(String clientId) async {
    try {
      final String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getClientToken(clientId)}';
      print('Client ID: $clientId');
      print('Calling URL: $url');

      final response = await dio.get(url);
      print("ClientTokenResponse: ${response.data}");

      if (response.statusCode == 200) {
        return ClientTokenModel.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get client token by client ID (POST with tokens body)
  Future<ClientTokenModel> getClientTokenPost(
    String clientId,
    Map<String, dynamic> tokensBody, {
    String? adminTokenOverride,
  }) async {
    try {
      // Use Render dev host explicitly for admin token switching
      final String url =
          'https://aitotabackend-sih2.onrender.com/api/v1/${ApiEndpoints.getClientToken(clientId)}';
      print('Client ID: $clientId');
      print('Calling URL (POST): $url');
      print('Request body: $tokensBody');

      final response = await dio.post(
        url,
        data: tokensBody,
        options: Options(
          extra: adminTokenOverride != null && adminTokenOverride.isNotEmpty
              ? {'authTokenOverride': adminTokenOverride}
              : null,
        ),
      );
      print("ClientTokenResponse (POST): ${response.data}");

      if (response.statusCode == 200) {
        return ClientTokenModel.fromJson(response.data);
      }
      throw Exception('Backend error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UploadCallLogsResponse> uploadCallLogs(UploadCallLogsRequest request) async {
    try {
      print(' ${ApiEndpoints.uploadCallLogs}');
      print('Request data: ${request.toJson()}');

      final response = await dio.post(
        ApiEndpoints.uploadCallLogs,
        data: request.toJson(),
      );

      print("UploadCallLogsResponse: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadCallLogsResponse.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('DioException response: ${e.response?.data}');
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<CallAnalyticsSummaryModel> getCallLogsSummary({
    required String range,
    String? start,
    String? end,
    String? direction,
  }) async {
    try {
      final endpoint = ApiEndpoints.getCallLogsSummary(range, start: start, end: end, direction: direction);
      print('Calling URL: $endpoint');
      
      final response = await dio.get(endpoint);
      print("CallLogsSummary Response: ${response.data}");
      
      if (response.statusCode == 200) {
        final model = CallAnalyticsSummaryModel.fromJson(response.data);
        return model;
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CallAnalyticsAnalysisModel> getCallLogsAnalysis({
    required String range,
    required String type,
    String? start,
    String? end,
    String? direction,
  }) async {
    try {
      final endpoint = ApiEndpoints.getCallLogsAnalysis(range, type, start: start, end: end, direction: direction);
      print('Calling URL: $endpoint');
      
      final response = await dio.get(endpoint);
      print("CallLogsAnalysis Response: ${response.data}");
      
      if (response.statusCode == 200) {
        final model = CallAnalyticsAnalysisModel.fromJson(response.data);
        return model;
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

    @override
  Future<CallLogDetailModel> getCallLogDetail(String callLogId) async {
    try {
      final endpoint = ApiEndpoints.getCallLogDetail(callLogId);
      print('Calling URL: $endpoint');
      
      final response = await dio.get(endpoint);
      print("CallLogDetail Response: ${response.data}");
      
      if (response.statusCode == 200) {
        final model = CallLogDetailModel.fromJson(response.data);
        return model;
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 2. NEW – filtered list (used by analytics)
  // --------------------------------------------------------------
  Future<CallLogsFilterResponse> getFilteredCallLogs({
    required String range,
    int page = 1,
    int limit = 200,
    String? direction,
    String? status,
    DateTime? start,
    DateTime? end,
  }) async {
    final Map<String, dynamic> query = {
      'range': range,
      'page': page,
      'limit': limit,
    };
    if (direction != null) query['direction'] = direction;
    if (status != null) query['status'] = status;
    if (start != null) query['start'] = DateFormat('yyyy-MM-dd').format(start);
    if (end != null) query['end'] = DateFormat('yyyy-MM-dd').format(end);

    final res = await dio.get(
      ApiEndpoints.callLogsFilters,
      queryParameters: query,
    );

    return CallLogsFilterResponse.fromJson(res.data);
  }

  @override
  Future<WhatsAiContactResponseModel> createWhatsAiContact(Map<String, dynamic> request) async {
    try {
      final response = await dio.post(ApiEndpoints.whatsAiContacts, data: request);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return WhatsAiContactResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add contact');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WhatsAiContactsListModel> getWhatsAiContacts({
    int page = 1,
    int limit = 20,
    String search = "",
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.whatsAiContacts,
        queryParameters: {
          'page': page,
          'limit': limit,
          'search': search,
        },
      );
      if (response.statusCode == 200) {
        return WhatsAiContactsListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch contacts');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WhatsAiContactResponseModel> updateWhatsAiContact(String id, Map<String, dynamic> request) async {
    try {
      final response = await dio.patch("${ApiEndpoints.whatsAiContacts}/$id", data: request);
      if (response.statusCode == 200) {
        return WhatsAiContactResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update contact');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CommonResponseModel> deleteWhatsAiContact(String id) async {
    try {
      final response = await dio.delete("${ApiEndpoints.whatsAiContacts}/$id");
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to delete contact');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WhatsAiCampaignListModel> getWhatsAiCampaigns() async {
    try {
      final String url = ApiEndpoints.whatsAiCampaigns;
      print('Calling URL: $url');
      final response = await dio.get(url);
      print("WhatsAiCampaignsResponse: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return WhatsAiCampaignListModel.fromJson(response.data);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
