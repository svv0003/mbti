import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  // Getter
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // 로그인 처리 관련 함수
  Future<void> login(User user) async {
    _user = user;
    _isLoading = false;
    // SharedPreferences에 사용자 정보 저장하여 어플 재시작해도 로그인 유지되도록 하는 모듈이다.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);
    await prefs.setString('userName', user.userName);
    notifyListeners();  // UI 업데이트
  }

  // 로그아웃 처리 관련 함수
  Future<void> logout() async {
    _user = null;
    // SharedPreferences에 저장된 사용자 정보 삭제한다.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    notifyListeners();  // UI 업데이트
  }

  // 어플 시작 시 저장된 로그인 상태 복원한다. (내 기기에 내장되어 있는 데이터로 복원한다.)
  Future<void> loadSaveUser() async {
    _isLoading = true;
    notifyListeners();  // UI 업데이트
    // SharedPreferences에 저장된 사용자 정보 삭제한다.
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userName = prefs.getString('userName');
      if(userId != null && userName != null){
        _user = User(
          id: userId,
          userName: userName,
          createdAt: null,
          lastLogin: null
        );
      }
    } catch(e) {
      print("Error loading saved User: $e");
    } finally {
      _isLoading = false;
      notifyListeners();  // UI 업데이트
    }
  }

  // 로딩 상태 설정
  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();  // UI 업데이트
  }
}

