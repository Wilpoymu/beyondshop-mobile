import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

class PhotoLocationScreen extends StatefulWidget {
  @override
  _PhotoLocationScreenState createState() => _PhotoLocationScreenState();
}

class _PhotoLocationScreenState extends State<PhotoLocationScreen> {
  XFile? _image;
  Position? _position;
  LatLng? _currentLatLng;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están denegados permanentemente, no podemos solicitar permisos.');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _position = position;
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomar Foto y Ubicación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No se ha tomado ninguna foto.')
                : Image.file(File(_image!.path)),
            SizedBox(height: 20),
            _position == null
                ? Text('No se ha obtenido la ubicación.')
                : Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        center: _currentLatLng,
                        zoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        if (_currentLatLng != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: _currentLatLng!,
                                builder: (ctx) => Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: Text('Tomar Foto'),
            ),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Obtener Ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
