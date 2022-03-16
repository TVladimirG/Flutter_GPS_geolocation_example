import 'package:flutter/material.dart';
import 'package:gps_geolocator/exts/extens.dart';
import 'package:gps_geolocator/providers/data_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            ShowAddress(),
            ShowLocation(),
            ShowTime(),
            ShowSpeed(),
            ShowTotalDist(),
            ShowDistanceFilter(),
          ],
        ),
      ),
      floatingActionButton: const StartStopButton(),
    );
  }
}

class ShowAddress extends StatelessWidget {
  const ShowAddress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _currentAddress = context.watch<GeoDataProvider>().address;

    String _textAddress = '';

    if (_currentAddress.isNotEmpty) {
      _textAddress = _currentAddress;
    } else {
      _textAddress = 'Address not defined';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) => Text(
          _textAddress,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}

class ShowLocation extends StatelessWidget {
  const ShowLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('build ShowCurrentLocation');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) {
          final _currentPosition = value.newPosition;

          late final String _textLocation;

          if (_currentPosition != null) {
            final latitude = _currentPosition.latitude.roundCoordinate();
            final longitude = _currentPosition.longitude.roundCoordinate();
            _textLocation = 'Coordinates: \n $latitude / $longitude';
          } else {
            _textLocation = 'Coordinates not defined';
          }

          return Text(
            _textLocation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    );
  }
}

class ShowTime extends StatelessWidget {
  const ShowTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('build ShowCurrentTime');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) {
          final thisInstant = DateTime.now();
          return Text(
            'Last update: ${convertValue(thisInstant.hour)}:${convertValue(thisInstant.minute)}:${convertValue(thisInstant.second)}',
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    );
  }

  String convertValue(int value) {
    if (value.toString().length == 1) {
      return '0$value';
    }
    return '$value';
  }
}

class ShowSpeed extends StatelessWidget {
  const ShowSpeed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('build ShowCurrentSpeed');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) {
          return Text(
            'Current speed: ${value.speed.round()} km/h ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    );
  }
}

class ShowDistanceFilter extends StatelessWidget {
  const ShowDistanceFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('build ShowDistanceFilter');

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) {
          final _included = context.watch<GeoDataProvider>().gpsLaunched;
          if (_included) {
            return const SizedBox.shrink();
          }
          return TextFormField(
            decoration: const InputDecoration(
              labelText: 'Minimum offset:',
              labelStyle: TextStyle(fontSize: 20.0),
            ),
            textAlign: TextAlign.center,
            onChanged: (value) {
              context.read<GeoDataProvider>().changeDistanceFilter(value);
            },
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
          );
        },
      ),
    );
  }
}

class StartStopButton extends StatelessWidget {
  const StartStopButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('build StartStopButton');
    return Consumer<GeoDataProvider>(
      builder: (context, value, child) {
        final _included = value.gpsLaunched;

        return FloatingActionButton.extended(
            onPressed: () => context.read<GeoDataProvider>().changeMode(),
            tooltip: 'Start / Stop',
            icon: setIcon(_included),
            label: setText(_included));
      },
    );
  }

  Icon setIcon(_included) {
    if (_included) {
      return const Icon(Icons.pause);
    }
    return const Icon(Icons.play_arrow_outlined);
  }

  Text setText(_included) {
    if (_included) {
      return const Text('Stop');
    }
    return const Text('Start');
  }
}

class ShowTotalDist extends StatelessWidget {
  const ShowTotalDist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<GeoDataProvider>(
        builder: (context, value, child) {
          return Text(
            'Total distance: ${value.totalDist.toInt()} meters',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    );
  }
}
