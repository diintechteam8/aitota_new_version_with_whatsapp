import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aitota_business/core/app-export.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audio_session/audio_session.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/services/api_services.dart';
import '../../../core/services/dio_client.dart';
import 'package:aitota_business/data/model/AgentChatHistory/agent_chat_history_model.dart';
import 'package:aitota_business/data/model/AgentChatHistory/get_by_agent_id_chat_history_model.dart';

class VoiceController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final RxString ttsMode = 'sarvam'.obs;
  String? authToken;
  final ScrollController scrollController = ScrollController();
  final bool initialChatMode;
  final RxString selectedLanguageLabel = 'en-IN'.obs;
  final RxString selectedVoice = 'karun'.obs;
  final String? questionId;
  final RxBool showThinkingBubble = false.obs;
  late TextEditingController chatTextController = TextEditingController();
  late TextEditingController textController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _audioSessionSubscription;
  AudioPlayer? player;
  final RxBool isChatMode = false.obs;
  final RxBool isListening = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  final RxBool isPlayingResponse = false.obs;
  String userTextInput = '';
  String aiReply = '';
  bool _isSpeechInitialized = false;
  String? googleKey;
  String? googleSourceName;
  String? servamKey = "sk_6yuruua2_diZQxbvHwYWMzWarXFLpDcje";
  String? apiKey;
  final bool? isRagChatAvailable;

  // WebSocket related variables
  WebSocketChannel? _webSocketChannel;
  final RxBool isWebSocketConnected = false.obs;
  final RxBool isAgentChatActive = false.obs;
  final RxString currentAgentId = ''.obs;
  final RxString sessionId = ''.obs;
  final RxString connectionId = ''.obs;
  final RxList<Map<String, String>> agentMessages = <Map<String, String>>[].obs;
  final RxBool isAgentListening = false.obs;
  final RxBool isAgentProcessing = false.obs;
  late TextEditingController agentChatTextController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final ApiService apiService = ApiService(dio: DioClient().dio);
  Function()? onAgentConnected;
  final RxString currentAgentName = ''.obs; // New variable to store agent name
  // Drawer support
  final RxString drawerTab = 'agents'.obs;
  final RxBool isDrawerLoading = false.obs;
  final RxList<AgentDetail> agentHistoryList = <AgentDetail>[].obs;

  VoiceController({
    this.initialChatMode = false,
    this.questionId,
    this.isRagChatAvailable = true,
  });

  @override
  Future<void> onInit() async {
    super.onInit();
    messages.clear();
    isChatMode.value = initialChatMode;
    isListening.value = false;
    isLoading.value = false;
    isPlayingResponse.value = false;
    aiReply = '';
    userTextInput = '';

    player = AudioPlayer();
    await _initAudioSession();
    await initializeSpeech();
    await _initializeFlutterTts();

    _playerStateSubscription = player?.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        isPlayingResponse.value = false;
        player?.stop();
        _reinitializeSpeech();
      }
    });

    _audioSessionSubscription = await AudioSession.instance.then((session) {
      return session.becomingNoisyEventStream.listen((_) {
        player?.pause();
        isPlayingResponse.value = false;
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (initialChatMode) {
      isChatMode.value = true;
    }
  }

  void addMessage(Map<String, String> message) {
    messages.add(message);
    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void toggleChatMode() {
    isChatMode.value = !isChatMode.value;
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
  }

  Future<void> initializeSpeech() async {
    _isSpeechInitialized = await speech.initialize(
      onError: (error) async {
        debugPrint('Speech recognition error: $error');
        isListening.value = false;
      },
    );
  }

  Future<void> toggleListening() async {
    if (!_isSpeechInitialized) {
      debugPrint('Speech recognition not initialized, attempting to initialize...');
      await _reinitializeSpeech();
      if (!_isSpeechInitialized) {
        debugPrint('Failed to initialize speech recognition');
        return;
      }
    }

    try {
      if (isListening.value) {
        await speech.stop();
        isListening.value = false;
      } else {
        if (isPlayingResponse.value) {
          await player?.stop();
          isPlayingResponse.value = false;
        }

        userTextInput = '';
        isListening.value = true;

        await speech.listen(
          onResult: (result) {
            userTextInput = result.recognizedWords;
            if (result.finalResult) {
              isListening.value = false;
              if (userTextInput.isNotEmpty) {
                _processSpeechInput();
              }
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
          localeId: selectedLanguageLabel.value,
        );
      }
    } catch (e) {
      isListening.value = false;
      await _reinitializeSpeech();
    }
  }

  Future<void> _processSpeechInput() async {
    if (userTextInput.isEmpty) return;

    isListening.value = false;
    await stopCurrentResponse();
    addMessage({'message': userTextInput, 'sender': 'user'});
    final toSend = userTextInput;
    userTextInput = '';
    await getAIResponse(toSend);
  }

  Future<void> stopCurrentResponse() async {
    try {
      if (isPlayingResponse.value) {
        await player?.stop();
      }
      await flutterTts.stop();
      isPlayingResponse.value = false;
    } catch (e) {
      isPlayingResponse.value = false;
    }
  }

  Future<void> getAIResponse(String input) async {
    if (input.trim().isEmpty) return;

    debugPrint("[AI] User input: $input");
    isLoading.value = true;
    showThinkingBubble.value = true; // Show thinking bubble with waves
    
    try {
      apiKey = "AIzaSyChyY8ObjQX7x2FcwnfwplYrHYYWelyk4U";
      final apiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

      debugPrint("[AI] API URL: $apiUrl");

      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text":
                "You are a helpful assistant. Continue the conversation naturally, using the past user message and your reply as context. Respond in the same language (हिंदी or English) and be concise (20–30 words).\n\nUser: $input",
              },
            ],
          },
        ],
      };

      debugPrint("[AI] Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiText = data['candidates'][0]['content']['parts'][0]['text'];

        aiReply = aiText;
        addMessage({"sender": "ai", "message": aiText});
        showThinkingBubble.value = false; // Hide waves when AI starts speaking

        if (ttsMode.value == 'flutter') {
          await callFlutterTts(aiText);
        } else {
          await callSarvamForTTS(aiText);
        }
      } else if (response.statusCode == 503) {
        debugPrint("[AI] Server overloaded (503)");
        addMessage({
          "sender": "ai",
          "message":
          "We're experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
        });
        showThinkingBubble.value = false;
        await callFlutterTts("Server overloaded. Please try again shortly.");
      } else {
        final error = "Error: ${response.statusCode} - ${response.body}";
        debugPrint("[AI] API Error: $error");
        aiReply = error;
        addMessage({
          "sender": "ai",
          "message":
          "We're experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
        });
        showThinkingBubble.value = false;
        await callFlutterTts("An error occurred. Please try again shortly.");
      }
    } catch (e) {
      debugPrint("[AI] Exception: $e");
      aiReply = "Oops! Something went wrong.";
      addMessage({
        "sender": "ai",
        "message":
        "We're experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
      });
      showThinkingBubble.value = false;
      await callFlutterTts("Something went wrong. Please try again shortly.");
    } finally {
      isLoading.value = false;
      textController.clear();
    }
  }

  Future<void> callSarvamForTTS(String text) async {
    if (ttsMode.value == 'flutter') {
      await callFlutterTts(text);
      return;
    }

    await stopCurrentResponse();

    const apiUrl = "https://api.sarvam.ai/text-to-speech";
    apiKey = servamKey;

    final requestBody = {
      "text": text,
      "speaker": selectedVoice.value,
      "model": "bulbul:v2",
      "target_language_code": selectedLanguageLabel.value,
    };

    try {
      debugPrint("Sending request to Sarvam API...");
      final response = await http
          .post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "api-subscription-key": apiKey.toString(),
        },
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['audios'] != null && responseData['audios'].isNotEmpty) {
          final audioBase64 = responseData['audios'][0];
          try {
            final audioBytes = base64Decode(audioBase64);
            final directory = await getTemporaryDirectory();
            final tempFile = File(
              '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav',
            );
            await tempFile.writeAsBytes(audioBytes);
            await _clearTemporaryFiles();
            isPlayingResponse.value = true;
            await player?.play(DeviceFileSource(tempFile.path));
          } catch (e) {
            await callFlutterTts(text);
            throw Exception("Error processing audio data:${e.toString()}");
          }
        } else {
          await callFlutterTts(text);
        }
      } else if (response.statusCode == 401) {
        await callFlutterTts(text);
      } else {
        await callFlutterTts(text);
      }
    } catch (e) {
      await callFlutterTts(text);
      throw Exception("Sarvam API Exception::${e.toString()}");
    }
  }

  Future<void> callFlutterTts(String text) async {
    await stopCurrentResponse();
    try {
      await flutterTts.setLanguage(selectedLanguageLabel.value);
      await flutterTts.speak(text);
      isPlayingResponse.value = true;
      flutterTts.setCompletionHandler(() {
        isPlayingResponse.value = false;
        _reinitializeSpeech();
      });
      flutterTts.setErrorHandler((msg) {
        isPlayingResponse.value = false;
        _reinitializeSpeech();
      });
    } catch (e) {
      isPlayingResponse.value = false;
      _reinitializeSpeech();
      throw Exception("Flutter TTS Exception:${e.toString()}");
    }
  }

  Future<void> _initializeFlutterTts() async {
    try {
      await flutterTts.setLanguage(selectedLanguageLabel.value);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVoice({
        "name": "en-in-x-ene-network",
        "locale": "en-IN",
      });
      debugPrint("Flutter TTS initialized successfully");
    } catch (e) {
     throw Exception(e.toString());
    }
  }

  Future<void> playVoiceResponse(Uint8List audioBytes) async {
    try {
      await player?.stop();
      isPlayingResponse.value = false;

      final directory = await getTemporaryDirectory();
      final tempFile = File('${directory.path}/audio.mp3');
      await tempFile.writeAsBytes(audioBytes);

      isPlayingResponse.value = true;
      await player?.play(DeviceFileSource(tempFile.path));
      player?.onPlayerComplete.listen((_) {
        isPlayingResponse.value = false;
        player?.stop();
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      isPlayingResponse.value = false;
      await player?.stop();
    }
  }

  Future<void> sendChatMessage() async {
    final text = chatTextController.text.trim();
    if (text.isEmpty) return;

    isLoading.value = true;
    chatTextController.clear();
    addMessage({'message': text, 'sender': 'user'});
    await getAIResponse(text);
  }

  Future<void> _clearTemporaryFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = directory.listSync();
      for (var file in files) {
        if (file.path.contains('audio.') && file is File) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error clearing temporary files: $e');
    }
  }

  Future<void> _reinitializeSpeech() async {
    try {
      if (speech.isListening) {
        await speech.stop();
      }

      isListening.value = false;
      _isSpeechInitialized = false;

      _isSpeechInitialized = await speech.initialize(
        onError: (error) async {
          debugPrint('Speech recognition error: $error');
          isListening.value = false;
          await Future.delayed(const Duration(seconds: 1));
          await _reinitializeSpeech();
        },
      );

      debugPrint('Speech recognition reinitialized: $_isSpeechInitialized');
    } catch (e) {
      await _reinitializeSpeech();
      throw Exception(e.toString());
    }
  }

  Future<void> fetchAgentName(String agentId) async {
    try {
      isLoading.value = true;
      final response = await apiService.getAgentName(agentId);
      if (response.success == true && response.agentInfo?.name != null) {
        print("AgentN:${response}");
        currentAgentName.value = response.agentInfo!.name ?? 'Unknown Agent';
      } else {
        currentAgentName.value = 'Unknown Agent';
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // WebSocket Methods
  Future<void> connectToWebSocket(String agentId) async {
    try {
      currentAgentId.value = agentId;

      // Retrieve clientId from FlutterSecureStorage
      final clientId = await secureStorage.read(key: Constants.id);
      await fetchAgentName(agentId); // Fetch agent name when connecting
      if (clientId == null || clientId.isEmpty) {
        return;
      }

      final wsUrl = Uri.parse('wss://app.aitota.com');
      _webSocketChannel = WebSocketChannel.connect(wsUrl);

      _webSocketChannel!.stream.listen(
            (data) => _handleWebSocketMessage(data),
        onError: (error) => _handleWebSocketError(error),
        onDone: () => _handleWebSocketClosed(),
      );

      isWebSocketConnected.value = true;
      debugPrint('WebSocket connected for agent: $agentId, clientId: $clientId');

      await _startWebSocketSession(clientId);

      if (onAgentConnected != null) {
        onAgentConnected!();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _startWebSocketSession(String clientId) async {
    if (!isWebSocketConnected.value) return;

    final extraData = base64Encode(utf8.encode(jsonEncode({
      'agentId': currentAgentId.value,
      'clientId': clientId,
    })));

    final startMessage = {
      'event': 'start',
      'streamSid': 'stream_${DateTime.now().millisecondsSinceEpoch}',
      'start': {
        'extraData': extraData,
      }
    };

    _webSocketChannel!.sink.add(jsonEncode(startMessage));
    debugPrint('Sent start message: $startMessage');
  }

  void _handleWebSocketMessage(dynamic data) {
    try {
      final message = jsonDecode(data);
      debugPrint('Received WebSocket message: $message');

      switch (message['event']) {
        case 'connected':
          connectionId.value = message['connectionId'] ?? '';
          debugPrint('Connected with ID: ${connectionId.value}');
          break;

        case 'start':
          sessionId.value = message['sessionId'] ?? '';
          isAgentChatActive.value = true;
          debugPrint('Session started: ${sessionId.value}');
          break;

        case 'transcript':
          final text = message['text'] ?? '';
          final isFinal = message['final'] ?? false;
          if (isFinal && text.isNotEmpty) {
            addAgentMessage({'message': text, 'sender': 'user'});
          }
          break;

        case 'conversation':
          final aiResponse = message['aiResponse'] ?? '';
          if (aiResponse.isNotEmpty) {
            addAgentMessage({'message': aiResponse, 'sender': 'agent'});
          }
          isAgentProcessing.value = false;
          break;

        case 'media':
          final audioPayload = message['media']?['payload'];
          if (audioPayload != null) {
            _playAgentAudio(audioPayload);
          }
          break;

        case 'stop':
          isAgentChatActive.value = false;
          debugPrint('Session stopped');
          break;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _handleWebSocketError(dynamic error) {
    debugPrint('WebSocket error: $error');
    isWebSocketConnected.value = false;
    isAgentChatActive.value = false;
  }

  void _handleWebSocketClosed() {
    debugPrint('WebSocket connection closed');
    isWebSocketConnected.value = false;
    isAgentChatActive.value = false;
  }

  void addAgentMessage(Map<String, String> message) {
    agentMessages.add(message);
    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
  }

  Future<void> sendAgentTextMessage(String text) async {
    if (!isWebSocketConnected.value || text.trim().isEmpty) return;

    addAgentMessage({'message': text, 'sender': 'user'});
    isAgentProcessing.value = true;

    final message = {
      'event': 'user_message',
      'text': text,
    };

    _webSocketChannel!.sink.add(jsonEncode(message));
    debugPrint('Sent text message: $message');

    Timer(const Duration(seconds: 30), () {
      if (isAgentProcessing.value) {
        isAgentProcessing.value = false;
        addAgentMessage({'message': 'No response received from agent', 'sender': 'system'});
      }
    });
  }

  Future<void> _playAgentAudio(String base64Audio) async {
    try {
      final audioBytes = base64Decode(base64Audio);
      await playVoiceResponse(audioBytes);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> stopAgentSession() async {
    if (!isWebSocketConnected.value) return;

    // Immediately stop all audio playback
    try {
      // Stop TTS immediately
      await flutterTts.stop();
      
      // Stop audio player immediately
      if (player != null) {
        await player?.stop();
        isPlayingResponse.value = false;
      }
      
      // Stop speech recognition if active
      if (speech.isListening) {
        await speech.stop();
        isAgentListening.value = false;
      }
      
      // Stop any ongoing audio processing
      isAgentProcessing.value = false;
      
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }

    // Send stop message to WebSocket
    final message = {
      'event': 'stop',
    };

    try {
      _webSocketChannel?.sink.add(jsonEncode(message));
      await _webSocketChannel?.sink.close();
    } catch (e) {
      debugPrint('Error closing WebSocket: $e');
    }

    // Reset all states immediately
    isWebSocketConnected.value = false;
    isAgentChatActive.value = false;
    isAgentListening.value = false;
    isAgentProcessing.value = false;
    agentMessages.clear();
    currentAgentId.value = '';
    sessionId.value = '';
    connectionId.value = '';
    
    // Clear any pending audio
    _clearTemporaryFiles();
    
    debugPrint('Agent session stopped and all audio cleared');
  }

  Future<void> reconnectToAgent() async {
    if (currentAgentId.value.isNotEmpty) {
      await connectToWebSocket(currentAgentId.value);
    }
  }

  String getConnectionStatus() {
    if (isWebSocketConnected.value && isAgentChatActive.value) {
      return 'Connected to Agent ${currentAgentId.value}';
    } else if (isWebSocketConnected.value) {
      return 'Connecting to Agent...';
    } else {
      return 'Disconnected';
    }
  }

  Future<void> toggleAgentListening() async {
    if (!isWebSocketConnected.value) return;

    if (isAgentListening.value) {
      await speech.stop();
      isAgentListening.value = false;
    } else {
      if (isPlayingResponse.value) {
        await player?.stop();
        isPlayingResponse.value = false;
      }

      isAgentListening.value = true;
      await speech.listen(
        onResult: (result) {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            isAgentListening.value = false;
            sendAgentTextMessage(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        localeId: selectedLanguageLabel.value,
      );
    }
  }

  void sendAgentChatMessage() {
    final text = agentChatTextController.text.trim();
    if (text.isEmpty) return;

    agentChatTextController.clear();
    sendAgentTextMessage(text);

    Future.delayed(Duration(milliseconds: 100), scrollToBottom);
  }

  // Drawer: History
  Future<void> fetchAgentChatHistory() async {
    try {
      isDrawerLoading.value = true;
      // clientId from secure storage
      final clientId = await secureStorage.read(key: Constants.id);
      if (clientId == null || clientId.isEmpty) {
        agentHistoryList.clear();
        return;
      }
      final history = await apiService.getAiAgentChatHistory(clientId);
      if (history.success == true && history.data?.agents != null) {
        agentHistoryList.assignAll(history.data!.agents!);
      } else {
        agentHistoryList.clear();
      }
    } catch (e) {
      agentHistoryList.clear();
    } finally {
      isDrawerLoading.value = false;
    }
  }

  Future<void> loadHistoryChat(String agentId) async {
    try {
      isLoading.value = true;
      // Get clientId
      final clientId = await secureStorage.read(key: Constants.id);
      if (clientId == null || clientId.isEmpty) return;
      final detail = await apiService.getByAiAgentChatHistoryDetail(clientId, agentId);
      final messagesList = detail.data?.messages ?? <ChatMessage>[];
      messages.clear();
      for (final m in messagesList) {
        final roleLower = (m.role ?? '').toLowerCase();
        String text = m.text ?? '';

        // Skip empty texts
        if (text.trim().isEmpty) continue;

        // Only keep human/assistant style messages; drop system/session/meta
        if (roleLower == 'user') {
          messages.add({'message': text, 'sender': 'user'});
          continue;
        }

        // Map known assistant roles to AI; ignore anything else (e.g., system)
        const aiRoles = ['assistant', 'ai', 'agent', 'bot'];
        if (aiRoles.contains(roleLower)) {
          // Clean agent name prefixes like "**AgentName**: " or "Agent: "
          text = text.replaceAll(RegExp(r'^\*\*[^*]+\*\*:\s*'), '');
          text = text.replaceAll(RegExp(r'^(Agent|MyPaai)[:：]\s*', caseSensitive: false), '');
          messages.add({'message': text, 'sender': 'ai'});
          continue;
        }

        // For unknown roles, ignore to avoid showing session/status logs
        continue;
      }
      // Scroll to bottom after a brief delay
      Future.delayed(const Duration(milliseconds: 200), scrollToBottom);
    } catch (e) {
      // ignore and keep existing chat
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    try {
      _playerStateSubscription?.cancel();
      _audioSessionSubscription?.cancel();

      // Stop all audio immediately
      if (speech.isListening) {
        speech.stop();
      }

      if (isPlayingResponse.value) {
        player?.stop();
      }
      
      // Stop TTS immediately
      flutterTts.stop();
      
      player?.dispose();

      chatTextController.dispose();
      textController.dispose();
      agentChatTextController.dispose();
      scrollController.dispose();

      // Ensure agent session is stopped
      stopAgentSession();

      isChatMode.value = false;
      isListening.value = false;
      isPlayingResponse.value = false;
      isLoading.value = false;
      messages.clear();
      agentMessages.clear();

      _isSpeechInitialized = false;

      _clearTemporaryFiles();
    } catch (e) {
      debugPrint('Error during controller disposal: $e');
    }
    super.onClose();
  }
}

class VoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoiceController(initialChatMode: false));
  }
}