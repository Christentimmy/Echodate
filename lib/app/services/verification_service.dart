import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:echodate/app/utils/base_url.dart';
import 'package:http/http.dart' as http;

class VerificationService {

  Future<http.Response?> uploadVerificationFiles({
    required String token,
    required File idFront,
    required File idBack,
    required File selfie,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/verification/upload-id');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('id_front', idFront.path))
        ..files.add(await http.MultipartFile.fromPath('id_back', idBack.path))
        ..files.add(await http.MultipartFile.fromPath('selfie', selfie.path));

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } on TimeoutException catch (_) {
      return http.Response(jsonEncode({'message': 'Request timed out'}), 408);
    } on SocketException catch (_) {
      return http.Response(jsonEncode({'message': 'Network error'}), 503);
    } catch (e) {
      return http.Response(jsonEncode({'message': 'Unexpected error: $e'}), 500);
    }
  }
}
