import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myevpanet4/Dialogs/changetariff.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/globals.dart';

Future<List<String>> authenticate(
    {required String token,
    required String phoneNumber,
    required String uid}) async {
  try {
    var url = Uri.https('evpanet.com', '/api/apk/login/user');
    final response = await http.post(
      url,//Uri.parse('https://evpanet.com/api/apk/login/user'),
      headers: {'token': token},
      body: {'number': phoneNumber, 'uid': uid},
    );

    printLog(jsonDecode(response.body));
    printLog(response.statusCode);
    printLog({'number': phoneNumber, 'uid': uid, 'token': token});

    if (response.statusCode >= 200 && response.statusCode < 210) {
      // Парсим ответ и возвращаем массив GUID
      // Предположим, что ответ имеет структуру {"guids": ["guid1", "guid2", ...]}
      // Вам может потребоваться адаптировать под фактический формат ответа
      var decoded = jsonDecode(response.body);
      return (decoded['message']['guids'] as List).cast<String>();
    } else if (response.statusCode >= 400 && response.statusCode < 410) {
      lastApiErrorMessage = jsonDecode(response.body)['message'];
      // Обработка ошибок
      return [];
    } else {
      // Обработка ошибок
      throw Exception('Failed to authenticate user');
    }
  } catch (e) {
    printLog(e);
  }
  return [];
}

Future<Account?> getAccountDataFromAPI(
    {required String token, required String guid}) async {
    try {
      final response = await http.get(
        Uri.parse('https://evpanet.com/api/apk/user/info/$guid'),
        headers: {'token': token},
      );

      //print(jsonDecode(response.body));
      //print(response.statusCode);
      //print({'guid': guid, 'token': token});

      if (response.statusCode >= 200 && response.statusCode < 210) {
        // Парсим ответ и возвращаем данные об абоненте
        var decoded = jsonDecode(response.body);
        return Account.loadFromServerJson(
            (decoded['message']['userinfo'] as Map<String, dynamic>), guid);
      } else if (response.statusCode >= 400 && response.statusCode < 410) {
        lastApiErrorMessage = jsonDecode(response.body)['message'];
      } else {
        throw Exception('Failed to get user information');
      }
      return null;
      
    } catch (e) {
      printLog(e);
    }
    return null;
}

Future<bool?> changeActivationFlagAPI(
    {required String token, required String guid}) async {
  try {
    final response = await http.put(
      Uri.parse('https://evpanet.com/api/apk/user/auto_activation/'),
      headers: {'token': token},
      body: {'guid': guid}
    );

    print(jsonDecode(response.body));
    print(response.statusCode);
    print({'guid': guid, 'token': token});

    if (response.statusCode >= 200 && response.statusCode < 210) {
      var decoded = jsonDecode(response.body);
      return decoded['message']['value'].toString() == '0' ? false : true;
    } else if (response.statusCode >= 400 && response.statusCode < 410) {
      lastApiErrorMessage = jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to get user information');
    }
    return null;
  } catch (e) {
    printLog('[changeActivationFlagAPI] $e');
  }
  return null;
}

Future<bool?> changeParentAccessFlagAPI(
    {required String token, required String guid}) async {
  try {
    final response = await http.put(
      Uri.parse('https://evpanet.com/api/apk/user/parent_control/'),
      headers: {'token': token},
      body: {'guid': guid}
    );

    print(jsonDecode(response.body));
    print(response.statusCode);
    print({'guid': guid, 'token': token});

    if (response.statusCode >= 200 && response.statusCode < 210) {
      var decoded = jsonDecode(response.body);
      return decoded['message']['value'].toString() == '0' ? false : true;
    } else if (response.statusCode >= 400 && response.statusCode < 410) {
      lastApiErrorMessage = jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to get user information');
    }
    return null;
  } catch (e) {
    printLog('[changeParentFlagAPI] $e');
  }
  return null;
}

Future<String?> updateTarifWithConfirmation(BuildContext context, String token, String tarifId, String guid) async {
  // Отображаем диалог подтверждения
  await showConfirmationDialogChangeTariff(context, () async {
    // После подтверждения пользователя, фактически изменяем тариф
    final response = await http.patch(
      Uri.parse('https://evpanet.com/api/apk/user/tarif'),
      headers: {'token': token},
      body: {'tarif': tarifId, 'guid': guid},
    );

    if (response.statusCode >= 200 && response.statusCode <= 210) {
      print(response.body);
      Map<String, dynamic> decoded = json.decode(response.body);
      Navigator.of(context).pop(); // Закрываем диалог
      return decoded['message']['tarif_id'];
    } else if (response.statusCode >= 400 && response.statusCode < 410) {
      lastApiErrorMessage = jsonDecode(response.body)['message'];
    }
      else {
      // Обработка ошибок
      throw Exception('Failed to update tarif');
    }
  });
  return null;
}