import 'package:flutter/material.dart';
import 'package:gps_geolocator/pages/main_page.dart';
import 'package:gps_geolocator/providers/data_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GeoDataProvider>(
            create: (context) => GeoDataProvider()),
      ],
      child: MaterialApp(
        title: 'GPS Geolocator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
