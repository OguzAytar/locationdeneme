// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindLocationNotifier extends StateNotifier<FindLocationViewModel> {
  FindLocationNotifier() : super(FindLocationViewModel(boylam: 0, enlem: 0, isLoading: false));

  void setKonum(double enlem, double boylam) {
    // Yeni bir state oluşturup durumu güncelleyin
    state = state.copyWith(enlem: enlem, boylam: boylam);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}

final findLocationProvider = StateNotifierProvider<FindLocationNotifier, FindLocationViewModel>(
  (ref) => FindLocationNotifier(),
);

class FindLocationViewModel {
  final double enlem;
  final double boylam;
  final bool isLoading;
  FindLocationViewModel({
    this.isLoading = false, // Varsayılan olarak false verildi
    required this.enlem,
    required this.boylam,
  });
  FindLocationViewModel copyWith({
    double? enlem,
    double? boylam,
    bool? isLoading,
  }) {
    return FindLocationViewModel(
      enlem: enlem ?? this.enlem,
      boylam: boylam ?? this.boylam,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
