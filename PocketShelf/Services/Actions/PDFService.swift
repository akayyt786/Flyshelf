import Foundation
import PDFKit
import AppKit

class PDFService {
    static let shared = PDFService()
    
    /// Converts images or text files to a PDF.
    func convertToPDF(urls: [URL]) -> URL? {
        let pdfDocument = PDFDocument()
        
        for (index, url) in urls.enumerated() {
            if let image = NSImage(contentsOf: url),
               let pdfPage = PDFPage(image: image) {
                pdfDocument.insert(pdfPage, at: index)
            }
        }
        
        if pdfDocument.pageCount == 0 { return nil }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Converted_\(UUID().uuidString).pdf")
        if pdfDocument.write(to: outputURL) {
            return outputURL
        }
        
        return nil
    }
    
    /// Merges multiple PDFs into one.
    func mergePDFs(urls: [URL]) -> URL? {
        let mergedDocument = PDFDocument()
        var pageIndex = 0
        
        for url in urls {
            if let doc = PDFDocument(url: url) {
                for i in 0..<doc.pageCount {
                    if let page = doc.page(at: i) {
                        mergedDocument.insert(page, at: pageIndex)
                        pageIndex += 1
                    }
                }
            }
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Merged_\(UUID().uuidString).pdf")
        if mergedDocument.write(to: outputURL) {
            return outputURL
        }
        return nil
    }
}
