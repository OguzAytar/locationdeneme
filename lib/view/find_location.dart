import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locationdeneme/view/find_location_viewmodel.dart';
import 'package:locationdeneme/view/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class FindLocation extends ConsumerStatefulWidget {
  const FindLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FindLocationState();
}

class _FindLocationState extends ConsumerState<FindLocation> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(findLocationProvider.notifier);
    final state = ref.watch(findLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasyon Bul'),
      ),
      body: Stack(
        children: [
          // Ana içerik
          _viewField(state, viewModel, context),
          // Loading ve BackdropFilter
          if (state.isLoading) ...[
            _backDrop(),
          ],
        ],
      ),
    );
  }

  BackdropFilter _backDrop() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Center _viewField(FindLocationViewModel state, FindLocationNotifier viewModel, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Enlem: ${state.enlem}'),
          Text('Boylam: ${state.boylam}'),
          _findLocationButton(viewModel),
          if (state.boylam != 0 && state.enlem != 0) _goToLocationButton(context, state),
        ],
      ),
    );
  }

  TextButton _findLocationButton(FindLocationNotifier viewModel) {
    return TextButton(
      onPressed: () {
        _konumIzniniKontrolEt(viewModel);
      },
      child: const Text('Konum Bul'),
    );
  }

  TextButton _goToLocationButton(BuildContext context, FindLocationViewModel state) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapScreen(latitude: state.enlem, longitude: state.boylam),
        ));
      },
      child: const Text('Konuma git'),
    );
  }

  Future<void> _konumIzniniKontrolEt(FindLocationNotifier viewModel) async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      _konumuAl(viewModel);
    } else if (permission.isDenied || permission.isPermanentlyDenied) {
      bool ayarlaraGit = await openAppSettings();
      if (ayarlaraGit) {
        _konumIzniniKontrolEt(viewModel);
      }
    }
  }

  Future<void> _konumuAl(FindLocationNotifier viewModel) async {
    bool servisAcikMi = await Geolocator.isLocationServiceEnabled();
    if (!servisAcikMi) {
      await Geolocator.openLocationSettings();
    } else {
      viewModel.setIsLoading(true);
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      viewModel.setKonum(position.latitude, position.longitude);
      viewModel.setIsLoading(false);
    }
  }
}
