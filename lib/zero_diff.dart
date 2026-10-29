/// 120Hz Myers $O(ND)$ Code/Text Diff Viewer & Virtualized ANSI Streaming Log
/// Console for Flutter.
///
/// Engineered by RedLight Apps (https://redlightapps.com) with zero external
/// dependencies:
/// - **Myers Diff & Intraline Engine ([MyersDiffEngine]):** Computes line and
///   word-level differences (`compute`, `computeAsync`,
///   `computeIntralineSpans`) and exports Unified Git patches
///   (`toUnifiedPatch`).
/// - **Virtualized Split & Unified Diff Viewer ([ZeroDiffViewer],
///   [DiffViewMode]):** 120Hz side-by-side and unified code comparison.
/// - **Virtualized ANSI Log Console ([ZeroLogConsole], [AnsiLogParser]):**
///   Streams 100,000+ color-coded terminal/CI logs with instant filtering.
library;

export 'src/common/zero_diff_dict.dart';
export 'src/engine/myers_diff_engine.dart';
export 'src/model/diff_models.dart';
export 'src/view/zero_diff_viewer.dart';
export 'src/view/zero_log_console.dart';
