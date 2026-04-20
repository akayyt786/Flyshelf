// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation
import NaturalLanguage
import Vision
import AppKit

class SmartRenamer {
    static let shared = SmartRenamer()
    
    /// Analyzes a file and suggests a descriptive name using on-device NLP and OCR.
    func suggestName(for url: URL) async -> String? {
        let extension_ = url.pathExtension
        var detectedKeywords: [String] = []
        
        // 1. Natural Language analysis of current name
        let nameOnly = url.deletingPathExtension().lastPathComponent
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = nameOnly
        tagger.enumerateTags(in: nameOnly.startIndex..<nameOnly.endIndex, unit: .word, scheme: .lexicalClass, options: [.omitPunctuation, .omitWhitespace]) { tag, range in
            if let tag = tag, (tag == .noun || tag == .otherWord) {
                detectedKeywords.append(String(nameOnly[range]))
            }
            return true
        }
        
        // 2. OCR Analysis if it's an image
        if let image = NSImage(contentsOf: url) {
            let ocrText = await performOCR(on: image)
            if !ocrText.isEmpty {
                detectedKeywords.append(contentsOf: extractKeywords(from: ocrText))
            }
        }
        
        // 3. Construct suggestion
        let uniqueKeywords = Array(Set(detectedKeywords.filter { $0.count > 2 })).prefix(3)
        if uniqueKeywords.isEmpty { return nil }
        
        let dateString = ISO8601DateFormatter().string(from: Date()).prefix(10)
        let suggestion = "\(dateString)_\(uniqueKeywords.joined(separator: "_")).\(extension_)"
        
        return suggestion
    }
    
    private func performOCR(on image: NSImage) async -> String {
        guard let tiffData = image.tiffRepresentation,
              let cgImage = NSBitmapImageRep(data: tiffData)?.cgImage else { return "" }
        
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                continuation.resume(returning: recognizedText)
            }
            
            request.recognitionLevel = .accurate
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    private func extractKeywords(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        var keywords: [String] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: [.omitPunctuation, .omitWhitespace]) { tag, range in
            if tag == .noun {
                keywords.append(String(text[range]))
            }
            return true
        }
        return Array(keywords.prefix(10))
    }
}
