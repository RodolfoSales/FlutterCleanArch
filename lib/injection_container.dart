import 'package:flutter_tostudy/core/injection_container_core.dart';
import 'package:flutter_tostudy/features/injection_container_features.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initFeatures(sl);
  initCore(sl);
}


