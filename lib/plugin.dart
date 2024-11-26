import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';

import 'inline_hints_dart_package.dart';

ServerPlugin startPlugin(ResourceProvider provider) {
  return InlineHintsPlugin(resourceProvider: provider);
}
