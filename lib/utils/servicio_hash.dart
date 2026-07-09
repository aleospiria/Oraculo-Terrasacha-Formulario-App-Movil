import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class ServicioHash {
  static String hashString(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  static Future<String> hashFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return '';
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  static String _canonicalJson(Map<String, dynamic> json) {
    final sortedKeys = json.keys.toList()..sort();
    final map = <String, dynamic>{};
    for (final key in sortedKeys) {
      map[key] = json[key];
    }
    return jsonEncode(map);
  }

  static Future<String> hashReport({
    required Map<String, dynamic> reportJson,
    required List<String> fotoPaths,
    required List<String> audioPaths,
    String? firmaBase64,
  }) async {
    final jsonHash = hashString(_canonicalJson(reportJson));

    final fileHashes = <String>[];
    for (final path in fotoPaths) {
      fileHashes.add(await hashFile(path));
    }
    for (final path in audioPaths) {
      fileHashes.add(await hashFile(path));
    }
    if (firmaBase64 != null && firmaBase64.isNotEmpty) {
      fileHashes.add(hashString(firmaBase64));
    }
    fileHashes.sort();

    final combined = jsonHash + fileHashes.join('');
    return sha256.convert(utf8.encode(combined)).toString();
  }

  static String hashListaReportes(List<String> hashes) {
    final sorted = List<String>.from(hashes)..sort();
    return sha256.convert(utf8.encode(sorted.join(''))).toString();
  }
}
