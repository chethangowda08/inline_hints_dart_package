import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart' show PhysicalResourceProvider;
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart' show ServerPluginStarter;
import 'package:inline_hints_dart_package/inline_hints_dart_package.dart';

void main(List<String> args) {
  final resourceProvider = PhysicalResourceProvider.INSTANCE;
  final plugin = InlineHintsPlugin(resourceProvider: resourceProvider);
  ServerPluginStarter(plugin).start(args as SendPort);
}
