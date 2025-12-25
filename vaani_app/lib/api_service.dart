import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use your computer's IP if 10.0.2.2 fails
  static const String baseUrl = "http://10.0.2.2:8000"; 

  static Future<Map<String, dynamic>?> sendAudio(String filePath, String targetWord) async {
    var uri = Uri.parse("$baseUrl/analyze-audio");
    
    // Create a Request that sends both File AND Text
    var request = http.MultipartRequest('POST', uri);
    
    // 1. Add the Audio File
    var file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);

    // 2. Add the Target Word (The key "target_word" matches Python)
    request.fields['target_word'] = targetWord;

    try {
      print("🚀 Sending audio + target '$targetWord' to backend...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("✅ Success! Response: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("❌ Failed. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error connecting to backend: $e");
      return null;
    }
  }
}