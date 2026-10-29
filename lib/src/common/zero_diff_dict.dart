/// Centralized UI and accessibility string dictionary for `zero_diff`.
abstract final class ZeroDiffDict {
  /// Label for Unified single-column diff mode.
  static const String unifiedModeLabel = 'UNIFIED';

  /// Label for Side-by-Side split diff mode.
  static const String sideBySideModeLabel = 'SPLIT';

  /// Placeholder when both compared texts are empty or identical.
  static const String noDifferencesLabel = 'No differences found';

  /// Placeholder when the log console has no matching entries.
  static const String emptyLogConsoleLabel = 'No matching log entries';

  /// Search bar hint for filtering log console lines.
  static const String filterLogsHint = 'Search logs...';
}
