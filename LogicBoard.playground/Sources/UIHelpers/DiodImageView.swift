import Foundation
import UIKit

public enum ColorDiod: String, CaseIterable {
    case red
    case blue
    case yellow
    case green
    
}

public class DiodImageView: UIImageView {
    public var turnOnImage: UIImage?
    public var turnOffImage: UIImage?
    
    public init(color: ColorDiod) {
        super.init(image: DiodImageView.getImagebyColorDiod(color))
        turnOnImage = DiodImageView.getImagebyColorDiod(color, true)
        turnOffImage = DiodImageView.getImagebyColorDiod(color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimateDiod() {
        animationImages = [turnOnImage!, turnOffImage!]
        animationDuration = 1
        startAnimating()
    }
    
    public static func getImagebyColorDiod(_ color: ColorDiod, _ isTurnOn: Bool = false) -> UIImage? {
        let mode = isTurnOn ? "on" : "off"
        let lampString = "_lamp_"
        return UIImage(named: color.rawValue + lampString + mode)
    }
}
