//
//  Extensions.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/22/19.
//

import Foundation
import SpriteKit
import PlaygroundSupport

public struct CustomError : Error {
    public var localizedDescription: String
}

extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension SKShapeNode {
    
    func commonConfiguration() {
        lineCap = .round
        lineJoin = .round
        zPosition = 1
        isUserInteractionEnabled = true
        isAntialiased = false
    }
}

extension UIImage {
    
    func texture(size: CGSize) -> SKTexture? {
        let textureSize = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        let context = UIGraphicsGetCurrentContext()
        context?.draw(self.cgImage!, in: textureSize, byTiling: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var texture: SKTexture? = nil
        if let CGImage = image?.cgImage {
            texture = SKTexture(cgImage: CGImage)
        }
        return texture
    }
}


