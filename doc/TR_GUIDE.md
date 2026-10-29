# `zero_diff` — Türkçe Mimari ve Kullanım Kılavuzu

## 1. Neden `zero_diff`?
AI kodlama araçları, Git arayüzleri ve CI/CD log panelleri için Flutter'da hem kelime düzeyinde satır içi (`intraline`) kod farkı gösteren hem de 100.000+ satırlık ANSI renkli log akışını 120Hz hızında sanallaştıran sıfır bağımlılıklı bir paket ihtiyacı vardır.

## 2. Temel Bileşenler
- **`MyersDiffEngine`:** Satır ve kelime bazlı fark hesaplama (`compute`, `computeAsync`) + `toUnifiedPatch`.
- **`ZeroDiffViewer`:** `DiffViewMode.unified` ve `DiffViewMode.sideBySide` görünümleri.
- **`ZeroLogConsole` & `AnsiLogParser`:** ANSI renk çözücülü ve anlık arama destekli sanallaştırılmış log konsolu.
