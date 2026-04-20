// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import AppKit

class NotchDetector {
    static func isPointInNotch(_ point: NSPoint) -> Bool {
        guard let screen = NSScreen.main else { return false }
        
        // Check if there is a notch by looking at safe areas (macOS 12+)
        if #available(macOS 12.0, *) {
            let safeAreaTop = screen.safeAreaInsets.top
            if safeAreaTop > 0 {
                // Approximate notch area in the center-top
                let screenWidth = screen.frame.width
                let notchWidth: CGFloat = 200 // Approximate
                let notchHeight: CGFloat = safeAreaTop
                
                let notchRect = NSRect(
                    x: (screenWidth - notchWidth) / 2,
                    y: screen.frame.height - notchHeight,
                    width: notchWidth,
                    height: notchHeight
                )
                
                return notchRect.contains(point)
            }
        }
        return false
    }
}
