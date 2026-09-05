import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AiChatMessage {
  final String role; // 'system', 'user', 'assistant'
  final String content;

  AiChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory AiChatMessage.fromJson(Map<String, dynamic> json) => AiChatMessage(
        role: json['role'] ?? 'user',
        content: json['content'] ?? '',
      );
}

class AiGatewayService {
  static final AiGatewayService instance = AiGatewayService._internal();
  AiGatewayService._internal();

  static const String _baseUrl = 'https://one.apprentice.cyou/v1';
  static const String _apiKey =
      'AR_7651fb06_0f19ac85a3a409b4fe568b2afb7a1512';
  static const String _defaultModel = 'gemini-3.1-flash-lite';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 25),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    ),
  );

  static String cleanMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*{1,3}'), '')
        .replaceAll(RegExp(r'#{1,6}\s*'), '')
        .replaceAll(RegExp(r'_{1,2}'), '')
        .replaceAll(RegExp(r'`{1,3}'), '')
        .replaceAll(RegExp(r'~{2}'), '')
        .trim();
  }

  Future<String> chat({
    required List<AiChatMessage> messages,
    String model = _defaultModel,
    double temperature = 0.7,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages.map((m) => m.toJson()).toList(),
          'temperature': temperature,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final choices = response.data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final content = choices[0]['message']?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            return cleanMarkdown(content);
          }
        }
      }
    } catch (e) {
      debugPrint('AI Gateway Service Error: $e');
    }
    return 'Maaf, AI Guru sedang beristirahat sebentar. Coba tanyakan lagi ya! 🌟';
  }

  Future<String> askAiTeacher({
    required String userPrompt,
    String topic = 'Bahasa Inggris SD',
  }) async {
    final systemPrompt = AiChatMessage(
      role: 'system',
      content:
          'Kamu adalah "Guru AI Ceria", asisten ramah, seru, dan pintar untuk anak-anak SD di Indonesia yang sedang belajar Bahasa Inggris (Topik: $topic). '
          'PENTING MUTLAK: DILARANG MENGGUNAKAN SIMBOL MARKDOWN SEPERTI **, *, ##, ATAU #. Tuliskan jawaban dalam TEKS BIASA BERSIH, ramah anak, dan penuh emoji ceria!',
    );

    final userMessage = AiChatMessage(
      role: 'user',
      content: userPrompt,
    );

    final reply = await chat(messages: [systemPrompt, userMessage], temperature: 0.7);
    return cleanMarkdown(reply);
  }

  Future<String> getHintForQuestion({
    required String questionPrompt,
    required String targetAnswer,
  }) async {
    final systemPrompt = AiChatMessage(
      role: 'system',
      content:
          'Kamu adalah asisten guru kuis Bahasa Inggris SD. Berikan petunjuk singkat (1-2 kalimat saja) yang ramah anak tanpa langsung memberi tahu jawaban utuh. '
          'DILARANG MENGGUNAKAN SIMBOL MARKDOWN **, *, ##. Soal: "$questionPrompt", Jawaban Benar: "$targetAnswer".',
    );

    final userMessage = AiChatMessage(
      role: 'user',
      content: 'Bisa minta petunjuk?',
    );

    final reply = await chat(messages: [systemPrompt, userMessage], temperature: 0.7);
    return cleanMarkdown(reply);
  }
}
