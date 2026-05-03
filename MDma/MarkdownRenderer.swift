import SwiftUI
import AppKit
import Markdown

struct MarkdownView: View {
    let text: String

    var body: some View {
        let document = Document(parsing: text)
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(document.blockChildren.enumerated()), id: \.offset) { _, block in
                BlockView(block: block)
            }
        }
    }
}

private struct BlockView: View {
    let block: BlockMarkup

    var body: some View {
        switch block {
        case let heading as Heading:
            SwiftUI.Text(InlineRenderer.attributedString(for: heading))
                .font(Typography.heading(heading.level))
                .padding(.top, Typography.headingTopSpacing(heading.level))

        case let paragraph as Paragraph:
            SwiftUI.Text(InlineRenderer.attributedString(for: paragraph))
                .fixedSize(horizontal: false, vertical: true)

        case let quote as BlockQuote:
            HStack(alignment: .top, spacing: 0) {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(MarkdownColors.blockquoteBar)
                    .frame(width: 4)
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(Array(quote.blockChildren.enumerated()), id: \.offset) { _, child in
                        BlockView(block: child)
                    }
                }
                .padding(.leading, 14)
                .padding(.vertical, 2)
            }
            .padding(.vertical, Spacing.xs)
            .padding(.leading, 2)
            .padding(.trailing, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(MarkdownColors.blockquoteBackground)
            )
            .foregroundStyle(.secondary)

        case let code as CodeBlock:
            VStack(alignment: .leading, spacing: 0) {
                if let language = code.language, !language.isEmpty {
                    SwiftUI.Text(language)
                        .font(Typography.codeLabel)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                        .padding(.bottom, Spacing.xs)
                }
                SwiftUI.Text(code.code.trimmingCharacters(in: .newlines))
                    .font(Typography.codeBlock)
                    .textSelection(.enabled)
                    .padding(.horizontal, 14)
                    .padding(.vertical, (code.language != nil && !code.language!.isEmpty) ? 10 : 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(MarkdownColors.codeBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(MarkdownColors.codeBorder, lineWidth: 0.5)
            )

        case let list as UnorderedList:
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(list.listItems.enumerated()), id: \.offset) { _, item in
                    ListItemRow(marker: "•", item: item)
                }
            }

        case let list as OrderedList:
            let start = Int(list.startIndex)
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(list.listItems.enumerated()), id: \.offset) { idx, item in
                    ListItemRow(marker: "\(start + idx).", item: item)
                }
            }

        case is ThematicBreak:
            Rectangle()
                .fill(Color.secondary.opacity(0.2))
                .frame(height: 1)
                .padding(.vertical, Spacing.md)

        case let html as HTMLBlock:
            SwiftUI.Text(html.rawHTML)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)

        default:
            SwiftUI.Text(block.format())
        }
    }

}

private struct ListItemRow: View {
    let marker: String
    let item: ListItem

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            SwiftUI.Text(marker)
                .foregroundStyle(.tertiary)
                .frame(minWidth: 20, alignment: .trailing)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(item.blockChildren.enumerated()), id: \.offset) { _, child in
                    BlockView(block: child)
                }
            }
        }
    }
}

private enum InlineRenderer {
    static func attributedString(for block: BlockMarkup) -> AttributedString {
        var result = AttributedString()
        for child in block.children {
            if let inline = child as? InlineMarkup {
                result.append(render(inline))
            }
        }
        return result
    }

    static func render(_ inline: InlineMarkup) -> AttributedString {
        switch inline {
        case let text as Markdown.Text:
            return AttributedString(text.string)

        case let emphasis as Emphasis:
            var s = concatInlines(emphasis.inlineChildren)
            s.mergeAttributes(AttributeContainer().font(.body.italic()))
            return s

        case let strong as Strong:
            var s = concatInlines(strong.inlineChildren)
            s.mergeAttributes(AttributeContainer().font(.body.bold()))
            return s

        case let strike as Strikethrough:
            var s = concatInlines(strike.inlineChildren)
            s.mergeAttributes(AttributeContainer().strikethroughStyle(.single))
            return s

        case let code as InlineCode:
            var s = AttributedString("\u{2009}" + code.code + "\u{2009}")
            s.mergeAttributes(AttributeContainer()
                .font(.system(.body, design: .monospaced))
                .backgroundColor(MarkdownColors.inlineCodeBackground))
            return s

        case let link as Markdown.Link:
            var s = concatInlines(link.inlineChildren)
            if let dest = link.destination, let url = URL(string: dest) {
                s.link = url
                s.foregroundColor = .accentColor
                s.underlineStyle = .single
            }
            return s

        case is SoftBreak:
            return AttributedString(" ")

        case is LineBreak:
            return AttributedString("\n")

        case let html as InlineHTML:
            return AttributedString(html.rawHTML)

        case let image as Markdown.Image:
            var s = AttributedString("[" + (image.title ?? image.plainText) + "]")
            s.foregroundColor = .secondary
            return s

        default:
            return AttributedString(inline.format())
        }
    }

    private static func concatInlines<S: Sequence>(_ inlines: S) -> AttributedString
    where S.Element == InlineMarkup {
        var result = AttributedString()
        for child in inlines {
            result.append(render(child))
        }
        return result
    }
}
