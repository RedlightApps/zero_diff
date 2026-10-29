<div align="center">

# 🧬 zero_diff

**120Hz Myers $O(ND)$ Code/Text Diff Viewer & Virtualized ANSI Streaming Log Console for Flutter.**  
*Unified & Side-by-Side split views, word-level intraline highlighting, background `Isolate` diffing, Unified Git Patch export, and 100,000+ line ANSI color log console — Zero external dependencies.*

[![pub package](https://img.shields.io/pub/v/zero_diff.svg?color=00E676&label=pub.dev)](https://pub.dev/packages/zero_diff)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-2979FF)](https://pub.dev/packages/zero_diff)
[![Zero Dependencies](https://img.shields.io/badge/dependencies-ZERO-FF1744)](https://pub.dev/packages/zero_diff)
[![License: MIT](https://img.shields.io/badge/license-MIT-AA00FF)](https://opensource.org/licenses/MIT)
[![RedLight Apps](https://img.shields.io/badge/Crafted%20by-RedLight%20Apps-FF3D00)](https://redlightapps.com)

<br/>

### 🌍 Available Documentation in 11 Languages
[**English**](#english-overview) · [**Türkçe**](#türkçe-genel-bakış) · [**Deutsch**](#deutsch-übersicht) · [**Français**](#français-aperçu) · [**Español**](#español-resumen) · [**Русский**](#русский-обзор) · [**中文**](#中文-概述) · [**日本語**](#日本語-概要) · [**한국어**](#한국어-개요) · [**العربية**](#العربية-نظرة-عامة) · [**Português**](#português-visão-geral)

📚 **Deep-Dive Guides:** [Full Architecture (`DOCUMENTATION.md`)](DOCUMENTATION.md) · [Türkçe Kılavuz (`doc/TR_GUIDE.md`)](doc/TR_GUIDE.md) · [English Guide (`doc/EN_GUIDE.md`)](doc/EN_GUIDE.md)

</div>

---

<a name="english-overview"></a>
## 🇬🇧 English Overview

### Why `zero_diff`?
AI coding assistants, Git clients, JSON inspectors, and DevOps dashboards built in Flutter need a fast side-by-side/unified code diff viewer with word-level intraline highlights and a virtualized ANSI terminal log viewer.

**`zero_diff` provides both engines in a single zero-dependency package:**
1. **`MyersDiffEngine` (Line & Word-Level Intraline Diff + Background Isolate):** Computes shortest edit scripts (`compute`, `computeAsync`), highlights exact changed words inside modified lines (`computeIntralineSpans`), and exports standard Unified Git patches (`toUnifiedPatch`).
2. **`ZeroDiffViewer` (120Hz Virtualized Split & Unified Code Diff):** Switch on the fly between `DiffViewMode.unified` and `DiffViewMode.sideBySide` with dual line-number gutters and `+added / -deleted` badges.
3. **`ZeroLogConsole` & `AnsiLogParser` (100,000+ Line ANSI Log Console):** Renders high-volume streaming CI/CD and telemetry logs at 120Hz with full ANSI color escape decoding (`\x1B[32m`, etc.) and instant substring filtering.

### Quick Start
```yaml
dependencies:
  zero_diff: ^1.0.0
```

```dart
import 'package:zero_diff/zero_diff.dart';

// 1. 120Hz Unified / Side-by-Side Code Diff Viewer:
ZeroDiffViewer(
  oldText: oldSourceCode,
  newText: newSourceCode,
  initialMode: DiffViewMode.sideBySide,
);

// 2. 100,000+ Line Virtualized ANSI Log Console:
ZeroLogConsole(
  logs: myStreamingAnsiLogs,
);
```

---

<a name="türkçe-genel-bakış"></a>
## 🇹🇷 Türkçe — Genel Bakış

`zero_diff`, Flutter için geliştirilmiş **sıfır harici bağımlılıklı, 120Hz Kod/Metin Karşılaştırma (`ZeroDiffViewer`) ve Sanallaştırılmış ANSI Log Konsolu (`ZeroLogConsole`) motorudur**.
- **`MyersDiffEngine`:** Satır ve kelime bazlı satır içi (`intraline`) farkları hesaplar, büyük metinleri arka plan `Isolate` üzerinde işler (`computeAsync`) ve `git diff` formatında Unified Patch üretir.
- **`ZeroDiffViewer`:** Tek tıkla `Unified` (Birleşik) ve `Side-by-Side` (Yan Yana) kod karşılaştırma görünümleri arasında geçiş yapar.
- **`ZeroLogConsole` & `AnsiLogParser`:** 100.000+ satırlık ANSI renk kodlu logları 120Hz hızında sanallaştırarak çizer ve anlık filtreleme sunar.

---

<a name="deutsch-übersicht"></a>
## 🇩🇪 Deutsch — Übersicht

`zero_diff` ist eine **120Hz Code/Text-Diff-Viewer- und virtualisierte ANSI-Log-Konsolen-Engine** für Flutter ohne externe Abhängigkeiten (`MyersDiffEngine`, `ZeroDiffViewer` Unified/Split-Ansicht und `ZeroLogConsole`).

---

<a name="français-aperçu"></a>
## 🇫🇷 Français — Aperçu

`zero_diff` est un **visualiseur de différences de code/texte (Unified & Side-by-Side) et une console de logs ANSI virtualisée à 120Hz** pour Flutter sans dépendance externe (`MyersDiffEngine`, `ZeroDiffViewer`, `ZeroLogConsole`).

---

<a name="español-resumen"></a>
## 🇪🇸 Español — Resumen

`zero_diff` es un **visor de diferencias de código/texto (Unified y Side-by-Side) y consola de registros ANSI virtualizada a 120Hz** para Flutter sin dependencias externas (`MyersDiffEngine`, `ZeroDiffViewer`, `ZeroLogConsole`).

---

<a name="русский-обзор"></a>
## 🇷🇺 Русский — Обзор

`zero_diff` — это **движок сравнения кода/текста (Unified и Side-by-Side) и виртуализированная ANSI лог-консоль 120Hz** для Flutter без внешних зависимостей (`MyersDiffEngine`, пословная подсветка изменений, `ZeroLogConsole`).

---

<a name="中文-概述"></a>
## 🇨🇳 中文 — 概述

`zero_diff` 是专为 Flutter 打造的**零外部依赖 120Hz 代码/文本差异对比器 (`ZeroDiffViewer`) 与虚拟化 ANSI 实时日志控制台 (`ZeroLogConsole`)**，支持 Unified 与并排双栏对比、词级行内高亮、后台 `Isolate` 计算及 100,000+ 行彩色日志过滤。

---

<a name="日本語-概要"></a>
## 🇯🇵 日本語 — 概要

`zero_diff` は外部依存ゼロの **Flutter 向け 120Hz コード/テキスト差分ビューア (`ZeroDiffViewer`) & 仮想化 ANSI ログコンソール (`ZeroLogConsole`)** です（Unified/Side-by-Side 表示、単語レベルの行内ハイライト、10万行以上の ANSI カラーログ対応）。

---

<a name="한국어-개요"></a>
## 🇰🇷 한국어 — 개요

`zero_diff`는 외부 의존성이 없는 **Flutter용 120Hz 코드/텍스트 Diff 뷰어 (`ZeroDiffViewer`) 및 가상화 ANSI 로그 콘솔 (`ZeroLogConsole`)** 엔진입니다 (통합/분할 비교, 단어 단위 하이라이트, 백그라운드 `Isolate` 및 100,000줄 이상의 로그 필터링 지원).

---

<a name="العربية-نظرة-عامة"></a>
## 🇸🇦 العربية — نظرة عامة

`zero_diff` هو **محرك مقارنة النصوص والأكواد (`ZeroDiffViewer`) ووحدة تحكم سجلات ANSI افتراضية بسرعة 120Hz (`ZeroLogConsole`)** لـ Flutter بدون أي تبعيات خارجية.

---

<a name="português-visão-geral"></a>
## 🇧🇷 Português — Visão Geral

`zero_diff` é um **visualizador de diff de código/texto (Unified e Side-by-Side) e console de logs ANSI virtualizado a 120Hz** para Flutter com zero dependências externas (`MyersDiffEngine`, `ZeroDiffViewer`, `ZeroLogConsole`).

---

## 💖 Sponsor & Support

Crafted with precision by **[RedLight Apps](https://redlightapps.com)** (Yusuf Kaval).
- ☕ [Buy Me a Coffee](https://www.buymeacoffee.com/yusufkaval)
- 💜 [GitHub Sponsors (@kvlyusuf)](https://github.com/sponsors/kvlyusuf)
- 🌐 [RedLight Apps Official Website](https://redlightapps.com)
