import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /*
  KakaoMapController  자료형,
  _mapController      변수명을 사용할 것이다.
  이 변수에 데이터가 존재하지 않으면 null 값을 허용하겠다. -> 에러 발생 방지
   */
  KakaoMapController? _mapController;
  /*
  private 변수에 위도/경도로 내 위치를 담는다.
  자료형은 LatLng 사용할 것이고, 데이터가 없으면 null 값을 허용하겠다.
   */
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();     // 화면 시작 시 위치 가져오는 기능 (우리가 만들 기능이다.)
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;                                            // 기기 GPS 상태 확인을 위한 변수 공간 준비 상태 T/F
    LocationPermission permission;                                  // 현재 어플의 기기 GPS 사용 권한 저장
    serviceEnabled = await Geolocator.isLocationServiceEnabled();   // Geolocator.isLocationServiceEnabled()에서 GPS 상태 확인 저장

    if(!serviceEnabled) return;                                     // GPS 상태가 false이기 때문에 return한다.

    permission = await Geolocator.checkPermission();                // 현재 어플의 기기 GPS 사용 권한 상태 T/F
    if(permission == LocationPermission.denied) {                   // 위치 권한 상태가 false라면
      permission = await Geolocator.requestPermission();            // 위치 권한을 요청하는 시스템 팝업 띄우기 기능을 동작시킨다.
      if(permission == LocationPermission.denied) return;           // 요청 거절당하면 return한다.
    }                                                               // 위치 접근 권한 상태가 true라면
    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.low,                         // 정확도 낮게 설정한다.
            timeLimit: Duration(seconds: 5)                         // 5초 제한
          )
      );      // 실제 위도/경도 데이터를 가져와 객체 변수에 담는다.
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);   // 객체 변수의 데이터를 추출해서 전역 변수에 담는다.
      });
      print("position : $position");
    } catch(e) {
      /*
      위치를 가져오지 못하면
      1. 이전 화면으로 되돌리거나
      2. 현위치를 임의로 지정하여 지도를 띄운다.
       */
      print("위치를 가져오지 못했습니다. $e");
      setState(() {
        _currentPosition = LatLng(37.402056, 127.108212);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    Scaffold : .html처럼 한 페이지의 한 위젯을 나타낸다.
     */
    return Scaffold(
      appBar: AppBar(
        title: Text("내 위치 확인하기"),
      ),
      body: _currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : KakaoMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            center: _currentPosition,
            markers: [
              Marker(markerId: 'my_location', latLng: _currentPosition!)
            ],
        )
    );
  }
}
