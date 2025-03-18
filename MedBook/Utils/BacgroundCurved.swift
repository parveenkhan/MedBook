//
//  BacgroundCurved.swift
//  MedBook
//
//  Created by ParveenKhan on 16/03/25.
//

import SwiftUI

struct CurvedTopBackground: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.height - 50)) // Left start below the curve
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height - 50), control: CGPoint(x: rect.width / 2, y: rect.height + 50)) // Smooth curved edge
        path.addLine(to: CGPoint(x: rect.width, y: 0)) // Top right
        path.addLine(to: CGPoint(x: 0, y: 0)) // Top left
        path.closeSubpath()
        
        return path
    }
}
