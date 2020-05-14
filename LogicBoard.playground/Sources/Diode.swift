//
//  Diode.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/22/19.
//

import Foundation
import SpriteKit

protocol DiodeDelegate: class {
    func diode( _ diode: Diode, didSelect gate: Gate)
}

public enum DiodeColor: String, CaseIterable, Equatable{
    case blue, green, red, yellow, random
    
    func imageName(isOn: Bool) -> String {
        switch self {
        case .random:
            return randomColor().imageName(isOn: isOn)
        default:
            return  concatImageName(self.rawValue, isOn)
        }
    }
    
    func concatImageName(_ color: String, _ isOn: Bool) -> String {
        let state = isOn ? "_lamp_on.png" : "_lamp_off.png"
        return color.trimmingCharacters(in: .whitespaces) + state
    }
    
    func randomColor() -> DiodeColor {
        var all: [DiodeColor] = DiodeColor.allCases
        if let randomIndex = all.index(of: .random) {
            all.remove(at: randomIndex)
        }
        let randomIndex = Int(arc4random()) % all.count
        return all[randomIndex]
    }
}

class Diode: SKSpriteNode {
    
    var gate: Gate
    var state: Bool = false
    weak var delegate: DiodeDelegate?
    let lampNode: SKSpriteNode
    var diodeColor: DiodeColor
    var isAvailableForConnect: Bool {
        return gate.connectedGates.isEmpty
    }
    
    init(color: DiodeColor) {
        if color == .random {
            diodeColor = color.randomColor()
        } else {
            diodeColor = color
        }
        gate = Gate(type: .input)
        let texture = SKTexture(imageNamed: diodeColor.imageName(isOn: false))
        let ratio = gate.frame.width / texture.size().width
        let scaledHeight = texture.size().height * ratio
        lampNode = SKSpriteNode(texture: texture, size: CGSize(width: gate.frame.width, height: scaledHeight))
        
        super.init(texture: nil, color: .clear, size: gate.frame.size)
        
        addChild(lampNode)
        lampNode.anchorPoint = .zero
        lampNode.position = CGPoint(x: -3, y: gate.frame.height)
        gate.delegate = self
        addChild(gate)
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight(_ flag: Bool) {
        gate.highlight(flag)
    }
}

extension Diode: GateDelegate {
    
    // MARK: - GateDelegate
    
    func gateDidSelect(_ gate: Gate) {
        delegate?.diode(self, didSelect: gate)
    }
    
    func gateStateDidChange(_ gate: Gate) {
        lampNode.texture = SKTexture(imageNamed: diodeColor.imageName(isOn:gate.state == Gate.State.value(true)))
    }
}


