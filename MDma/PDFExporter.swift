import SwiftUI
import AppKit

enum PDFExporter {
    private static let pageWidth: CGFloat = 612   // US Letter, 72 dpi
    private static let margin: CGFloat = 56

    @MainActor
    static func export(markdown: String, to url: URL) {
        let content = MarkdownView(text: markdown)
            .frame(width: pageWidth - margin * 2, alignment: .leading)
            .padding(margin)
            .background(Color.white)
            .environment(\.colorScheme, .light)
            .foregroundStyle(.black)

        let renderer = ImageRenderer(content: content)
        renderer.proposedSize = ProposedViewSize(width: pageWidth, height: nil)

        renderer.render { size, renderContext in
            var mediaBox = CGRect(origin: .zero, size: size)
            guard let pdf = CGContext(url as CFURL, mediaBox: &mediaBox, nil) else { return }
            pdf.beginPDFPage(nil)
            renderContext(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
    }
}
