// ignore_for_file: prefer_final_fields
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PersonModel {
  double _x;
  double _y;
  double _z;

  double _lat;
  double _lon;
  double _alt;

  // getters
  double get x => _x;
  double get y => _y;
  double get z => _z;

  double get lat => _lat;
  double get lon => _lon;
  double get alt => _alt;

  // setters
  set setx(double value) {
    _x = value;
    //TODO: atualizar lat, lon, alt
  }

  set sety(double value) {
    _y = value;
    //TODO: atualizar lat, lon, alt
  }

  set setz(double value) {
    _z = value;
    //TODO: atualizar lat, lon, alt
  }

  set setLat(double newLat) {
    //calcular novo x com base na lat
    double delta = lat - newLat;
    _x += delta;
  }

  set setLon(double newLon) {
    double delta = lon - newLon;
    _y += delta;
  }

  // construtor
  PersonModel(this._x, this._y, this._z, this._lat, this._lon, this._alt) {
    if(!kIsWeb){
      if (Platform.isAndroid) {
        while (true) {
          Future.delayed(const Duration(seconds: 2)).then((value) =>
              _determinePosition().then((value) => _lat +=
                  _lat - double.parse(value.latitude.toStringAsFixed(3))));
        }
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /*StreamSubscription<ServiceStatus> serviceStatusStream =
      Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    print(status);
  });

  StreamSubscription<Position> positionStream =
      Geolocator.getPositionStream().listen((Position position) {});*/

  // toString
  @override
  String toString() {
    return 'PersonModel{_x: $_x, _y: $_y, _z: $_z, _lat: $_lat, _lon: $_lon, _alt: $_alt}';
  }
}
