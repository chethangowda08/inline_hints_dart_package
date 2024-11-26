library inline_hints_dart_pacakge;

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;

/// Dart Inline Hints Plugin
/// Provides hints and suggestions for Dart code in IDEs.

class InlineHintsPlugin extends ServerPlugin {
  InlineHintsPlugin({required super.resourceProvider});
  @override
  String get name => 'Dart Inline Hints Plugin';
  @override
  String get version => '1.0.0';
  @override
  List<String> get fileGlobsToAnalyze => ['*.dart'];
  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    // Retrieve the resolved unit result for the file.
    final result = await analysisContext.currentSession.getResolvedUnit(path);
    if (result is ResolvedUnitResult) {
      // Generate inline hints for the resolved unit.
      final hints = _generateInlineHints(result.unit);
      // Send the hints to the IDE.
      channel.sendNotification(
        plugin.AnalysisHighlightsParams(path, hints).toNotification(),
      );
    }
  }

  /// Generate inline hints for the given [CompilationUnit].
  List<HighlightRegion> _generateInlineHints(CompilationUnit unit) {
    final visitor = _InlineHintsVisitor();
    unit.visitChildren(visitor);
    return visitor.hints;
  }
}

class _InlineHintsVisitor extends RecursiveAstVisitor<void> {
  final List<HighlightRegion> hints = <HighlightRegion>[];

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    if (node.initializer != null) {
      // Example: Provide a type hint for variables with initializers.
      final type = node.declaredElement?.type.getDisplayString(withNullability: false);
      if (type != null) {
        final offset = node.name.offset;
        hints.add(
          HighlightRegion(
            HighlightRegionType.COMMENT_DOCUMENTATION, // Use a suitable HighlightRegionType
            offset,
            node.name.length,
          ),
        );
      }
    }
    super.visitVariableDeclaration(node); // Call super to continue traversal
  }
}
