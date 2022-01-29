import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoDataProvider with ChangeNotifier {
  bool _gpsLaunched = false;
  Position? _newPosition;
  String _address = '';
  double _speed = 0.00;
  double _totalDist = 0.00;

  bool get gpsLaunched => _gpsLaunched;
  Position? get newPosition => _newPosition;
  String get address => _address;
  double get speed => _speed;
  double get totalDist => _totalDist;

  late int _distanceFilter = initDistanceFilter();
  double _distance = 0;
  late StreamSubscription<Position> _positionStreamSubscription;

  int initDistanceFilter() {
    // default value for example 10.
    // except 0
    return 10;
  }

  // Запускаем опредедение местоположения и подписываемся на поток
  void launchStreamPosition() {
    if (_distanceFilter == 0) {
      _distanceFilter = initDistanceFilter();
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: _distanceFilter,
    );

    try {
      _positionStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((position) {
        if (_newPosition == null) {
          _newPosition = position;
          return;
        }

        _distance = Geolocator.distanceBetween(_newPosition!.latitude,
            _newPosition!.longitude, position.latitude, position.longitude);

        _totalDist = _totalDist + _distance;

        if (_distance >= _distanceFilter) {
          _newPosition = position;
          _getCurrentSpeed();
          _getAddress();

          notifyListeners();
        }
      });
    } catch (e) {
      log(e.toString());
      _positionStreamSubscription.cancel();
    }
  }

  void _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _newPosition!.latitude, _newPosition!.longitude);

      Placemark place = placemarks[0];

      _address =
          '${place.country} (${place.isoCountryCode}), ${place.locality}, ${place.street}';
    } catch (e) {
      //log(e.toString());
      _address = 'Location error';
    }
  }

  void _getCurrentSpeed() {
    try {
      _speed = _newPosition!.speed * 3.6;
    } catch (e) {
      _speed = 0.00;
    }
  }

  void cancelStreamPosition() {
    _positionStreamSubscription.cancel();
    _speed = 0.00;

    notifyListeners();
  }

  Future<void> changeMode() async {
    _gpsLaunched = !_gpsLaunched;
    notifyListeners();

    if (_gpsLaunched) {
      launchStreamPosition();
    } else {
      cancelStreamPosition();
    }
  }

  changeDistanceFilter(String newValue) {
    try {
      _distanceFilter = int.parse(newValue);
    } catch (e) {
      // set default value
      _distanceFilter = initDistanceFilter();
      log('error - changeDistanceFilter');
    }
  }
}
