import 'package:flutter/material.dart';

import '../../features/material/ui/material_library_screen.dart';
import '../../features/material/ui/player_audio_screen.dart';
import '../../features/material/ui/reader_pdf_screen.dart';
import 'app_route.dart';

abstract final class MaterialRoutes {
  static Widget? screen(AppRoute route, {String? materialId}) =>
      switch (route) {
        AppRoute.materialLibrary => const MaterialLibraryScreen(),
        AppRoute.readerPdf => ReaderPdfScreen(materialId: materialId),
        AppRoute.playerAudio => PlayerAudioScreen(materialId: materialId),
        _ => null,
      };
}
