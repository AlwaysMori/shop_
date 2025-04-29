import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/employee.dart';

class EmployeeService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final _iv = encrypt.IV.fromLength(16);

  String _encryptPassword(String password) {
  final iv = encrypt.IV.fromSecureRandom(16); // <-- IV random 16 byte
  final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(password, iv: iv);

  // Gabungkan IV + Encrypted Password supaya bisa disimpan jadi 1
  final result = base64Encode(iv.bytes) + ':' + encrypted.base64;
  return result;
}

String _decryptPassword(String encryptedData) {
  try {
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data');

    final iv = encrypt.IV(base64Decode(parts[0]));
    final encryptedPassword = parts[1];

    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  } catch (e) {
    throw Exception('Failed to decrypt password: $e');
  }
}


  Future<List<Employee>> getEmployees() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? employeesData = prefs.getString('employees');
    if (employeesData != null) {
      final List<dynamic> jsonList = jsonDecode(employeesData);
      return jsonList.map((json) => Employee.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveEmployee(Employee employee) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Employee> employees = await getEmployees();

    // Encrypt password before saving
    final encryptedPassword = _encryptPassword(employee.password);

    // Simpan password terenkripsi ke secure storage
    await _secureStorage.write(
      key: employee.username,
      value: encryptedPassword,
    );

    // Simpan data lainnya ke SharedPreferences
    employees.add(Employee(
      username: employee.username,
      password: '', // Jangan simpan password di SharedPreferences
      name: employee.name,
      position: employee.position,
    ));
    final String jsonString =
        jsonEncode(employees.map((e) => e.toJson()).toList());
    await prefs.setString('employees', jsonString);
  }

  Future<bool> validateLogin(String username, String password) async {
    final String? encryptedPassword = await _secureStorage.read(key: username);
    if (encryptedPassword == null) return false;

    try {
      final decryptedPassword = _decryptPassword(encryptedPassword);
      return decryptedPassword == password;
    } catch (e) {
      return false; // Return false if decryption fails
    }
  }

  Future<String?> getUserRole(String username, String password) async {
    final List<Employee> employees = await getEmployees();
    try {
      final employee = employees.firstWhere(
        (e) => e.username == username,
      );

      // Validasi password dari secure storage
      final String? encryptedPassword = await _secureStorage.read(key: username);
      if (encryptedPassword != null) {
        try {
          final decryptedPassword = _decryptPassword(encryptedPassword);
          if (decryptedPassword == password) {
            return employee.position;
          }
        } catch (e) {
          return null; // Return null if decryption fails
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
