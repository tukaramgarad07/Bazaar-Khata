import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Utility {
  static Future<String?> getImageFromPreferences(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> saveImageToPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  // ignore: non_constant_identifier_names
  static Future<bool> RemoveImageToPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static DecorationImage imageFromBase64StringCustomer(String base64String) {
    return DecorationImage(
      image: MemoryImage(base64Decode(base64String)),
    );
  }

  static ImageProvider imageFromBase64StringCustomerDetail(
      String base64String) {
    return MemoryImage(base64Decode(base64String));
  }

  static Widget imageFromBase64String2(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
