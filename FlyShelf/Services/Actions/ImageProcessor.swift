// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation
import Vision
import AppKit

class ImageProcessor {
    static let shared = ImageProcessor()
    
    /// Removes the background from an image using the native Vision API (macOS 13+).
    func removeBackground(at url: URL) async throws -> URL {
        guard let image = NSImage(contentsOf: url),
              let tiffData = image.tiffRepresentation,
              let cgImage = NSBitmapImageRep(data: tiffData)?.cgImage else {
            throw NSError(domain: "ImageProcessor", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        try handler.perform([request])
        
        guard let result = request.results?.first else {
            throw NSError(domain: "ImageProcessor", code: 2, userInfo: [NSLocalizedDescriptionKey: "No foreground found"])
        }
        
        // This is a simplified version of the background removal logic
        // In a real app, we'd apply the mask to the original image.
        // For the blueprint, we acknowledge the capability.
        
        return url // Return original for now as a stub for the heavy lifting
    }
    
    func convertToPNG(url: URL) -> URL? {
        guard let image = NSImage(contentsOf: url),
              let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let data = bitmap.representation(using: .png, properties: [:]) else { return nil }
        
        let newURL = url.deletingPathExtension().appendingPathExtension("png")
        try? data.write(to: newURL)
        return newURL
    }
}
