// ignore_for_file: prefer_final_fields
import 'dart:math';

import 'package:flutter/material.dart';

class PersonModel {
  double _x;
  double _y;
  double _z;

  double _lat;
  double _lon;
  double _alt;

  // construtor
  PersonModel(this._x, this._y, this._z, this._lat, this._lon, this._alt);

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

  // metodos
  IconData bussola(double objetivoX, double objetivoY) {
    double angulo = 0;
    double x = objetivoX - _x;
    double y = objetivoY - _y;
    double z = _z;

    double anguloX = atan(x / z);
    double anguloY = atan(y / z);

    angulo = anguloX + anguloY;

    // angulo to N, S, E, W
    if (angulo > 0 && angulo < pi / 2) {
      return Icons.arrow_upward;
    } else if (angulo > pi / 2 && angulo < pi) {
      return Icons.arrow_left;
    } else if (angulo > pi && angulo < 3 * pi / 2) {
      return Icons.arrow_downward;
    } else if (angulo > 3 * pi / 2 && angulo < 2 * pi) {
      return Icons.arrow_right;
    } else {
      return Icons.error;
    }
  }

  // toString
  @override
  String toString() {
    return 'PersonModel{_x: $_x, _y: $_y, _z: $_z, _lat: $_lat, _lon: $_lon, _alt: $_alt}';
  }
}
