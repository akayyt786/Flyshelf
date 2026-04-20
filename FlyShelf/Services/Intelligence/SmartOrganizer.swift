// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation
import NaturalLanguage
import UniformTypeIdentifiers

class SmartOrganizer {
    static let shared = SmartOrganizer()
    
    enum Category: String, Codable, CaseIterable {
        case documents = "Documents"
        case images = "Images"
        case media = "Media"
        case archives = "Archives"
        case project = "Project"
        case miscellaneous = "Other"
    }
    
    /// Classifies an item based on its type and semantic analysis of its name.
    func classify(_ url: URL) -> Category {
        let pathExtension = url.pathExtension.lowercased()
        
        // 1. Uniform Type Identifier check
        if let uti = UTType(filenameExtension: pathExtension) {
            if uti.conforms(to: .image) { return .images }
            if uti.conforms(to: .audiovisualContent) { return .media }
            if uti.conforms(to: .archive) { return .archives }
            if uti.conforms(to: .pdf) || uti.conforms(to: .text) { return .documents }
        }
        
        // 2. Semantic analysis of the name
        let name = url.lastPathComponent.lowercased()
        let projectKeywords = ["project", "work", "design", "code", "dev"]
        for keyword in projectKeywords {
            if name.contains(keyword) { return .project }
        }
        
        return .miscellaneous
    }
    
    /// Suggests a "Smart Tag" using on-device NLP.
    func suggestTag(for name: String) -> String? {
        let tapper = NLTagger(tagSchemes: [.nameTypeOrLexicalClass])
        tapper.string = name
        var tag: String?
        tapper.enumerateTags(in: name.startIndex..<name.endIndex, unit: .word, scheme: .nameTypeOrLexicalClass, options: [.omitPunctuation, .omitWhitespace]) { nltag, range in
            if nltag == .noun {
                tag = String(name[range])
                return false // Stop after first noun
            }
            return true
        }
        return tag
    }
}
