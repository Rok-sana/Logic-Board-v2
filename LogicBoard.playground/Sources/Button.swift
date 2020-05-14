//
//  Button.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit

protocol ButtonDelegate: class {
    func button( _ button: Button, didSelect gate: Gate)
}

class Button: SKSpriteNode {
    var gate: Gate
    var selected: Bool = false
    weak var delegate: ButtonDelegate?
    let width: CGFloat
    
    init() {
        let point = CGPoint(x: Constant.buttonSize + Constant.marginBetweenButtonAndGate, y: 0)
        gate = Gate(type: .output, position: point)
        self.width = Constant.buttonSize + gate.frame.width + Constant.marginBetweenButtonAndGate
        super.init(texture: SKTexture(imageNamed: "0.png"), color:.red, size: CGSize(width: Constant.buttonSize, height: Constant.buttonSize))
        gate.state = .value(false)
        gate.delegate = self
        addChild(gate)
        isUserInteractionEnabled = true
        alpha = 1.0
        zPosition = 1
        anchorPoint = CGPoint(x: 0, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selected = !selected
        texture = SKTexture(imageNamed: selected ? "1.png" : "0.png")
        gate.state = .value(selected)
    }
    
    func highlight(_ flag: Bool) {
        gate.highlight(flag)
    }
}

extension Button: GateDelegate {
    
    // MARK: - GateDelegate
    
    func gateDidSelect(_ gate: Gate) {
        delegate?.button(self, didSelect: gate)
    }
    
    func gateStateDidChange(_ gate: Gate) { }
}
