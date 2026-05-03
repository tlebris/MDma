# MDma

A lightweight, native macOS Markdown editor and viewer built with SwiftUI.

## Features

- **Live preview** — Toggle between a rich Markdown preview and a monospaced editor with a single shortcut
- **PDF export** — Export any document to PDF in one click
- **Native macOS experience** — Unified toolbar, document-based architecture, dark mode support
- **Full Markdown support** — Headings, bold, italic, strikethrough, links, code blocks with language labels, blockquotes, ordered and unordered lists, horizontal rules, inline code, and more

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Shift + Cmd + P` | Toggle preview / editor |
| `Shift + Cmd + E` | Export to PDF |

## Requirements

- macOS 26 (Tahoe) or later
- Xcode 26+ (to build from source)

## Installation

### Download

Grab the latest `.dmg` from the [Releases](../../releases) page, open it, and drag **MDma.app** to your Applications folder.

### Build from Source

```bash
git clone https://github.com/thierrylebris/MDma.git
cd MDma
xcodebuild -scheme MDma -configuration Release build
```

Or open `MDma.xcodeproj` in Xcode and hit `Cmd + R`.

### Create a DMG

```bash
./scripts/create-dmg.sh
```

This builds a Release version and packages it into `MDma-1.0.dmg`.

## Setting as Default Markdown Editor

1. Right-click any `.md` file in Finder
2. Select **Get Info** (`Cmd + I`)
3. Under **Open with**, select **MDma**
4. Click **Change All...**

## License

[MIT](LICENSE)
