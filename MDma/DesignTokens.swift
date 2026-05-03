import SwiftUI
import AppKit

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

enum Typography {
    static func heading(_ level: Int) -> Font {
        switch level {
        case 1: return .system(size: 32, weight: .bold)
        case 2: return .system(size: 26, weight: .bold)
        case 3: return .system(size: 22, weight: .semibold)
        case 4: return .system(size: 18, weight: .semibold)
        case 5: return .system(size: 16, weight: .semibold)
        default: return .system(size: 14, weight: .medium)
        }
    }

    static func headingTopSpacing(_ level: Int) -> CGFloat {
        switch level {
        case 1: return 24
        case 2: return 20
        case 3: return 16
        case 4: return 14
        case 5: return 10
        default: return 8
        }
    }

    static let codeBlock: Font = .system(size: 12.5, design: .monospaced)
    static let codeLabel: Font = .system(size: 11, weight: .medium, design: .monospaced)
    static let editor: Font = .system(size: 13.5, weight: .regular, design: .monospaced)
}

enum MarkdownColors {
    static let codeBackground = Color(nsColor: .quaternarySystemFill)
    static let codeBorder = Color.secondary.opacity(0.1)
    static let blockquoteBar = Color.accentColor.opacity(0.5)
    static let blockquoteBackground = Color.accentColor.opacity(0.04)
    static let inlineCodeBackground = Color(nsColor: .quaternarySystemFill)
    static let linkUnderline = Color.accentColor.opacity(0.4)
}

let maxReadingWidth: CGFloat = 680
