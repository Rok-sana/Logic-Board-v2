//
//  Symbol.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit


protocol SymbolDelegate: class {
    func symbol(_ symbol: Symbol, didSelect gate: Gate)
}

/// Draws LogicOperator
final class Symbol: SKShapeNode {
    
    let logicOperator: LogicOperator
    weak var delegate: SymbolDelegate?
    let inputs: [Gate]
    let output: Gate
    let width: CGFloat
    
    init(_ yPosition: CGFloat, _ logicOperator: LogicOperator) {
        let frame = CGRect(origin: CGPoint(x: Constant.gateSize, y: yPosition), size: Constant.symbolSize)
        self.logicOperator = logicOperator
        let details = logicOperator.path(frame: frame)
        self.output = Gate(type: .output, position: details.ouputPosition)
        self.inputs = details.inputPositions.map({Gate(type: .input, position: $0)})
        self.width = details.bezierPath.bounds.width + self.output.frame.width*2
        super.init()
        for input in inputs {
            input.delegate = self
            addChild(input)
        }
        self.output.delegate = self
        addChild(self.output)
        self.path = details.bezierPath.cgPath
        strokeColor = .white
        fillColor = .clear
        lineWidth = Constant.symbolLineWidth
        commonConfiguration()
        let lable = SKLabelNode(text: logicOperator.rawValue)
        lable.fontSize = 20
        lable.fontName = "Helvetica"
        lable.fontColor = .white
        lable.position = CGPoint(x: frame.midX, y: frame.midY-lable.frame.height/2)
        lable.zPosition = 1
        addChild(lable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Symbol : GateDelegate {
    
    // MARK: - GateDelegate
    
    func gateDidSelect(_ gate: Gate) {
        delegate?.symbol(self, didSelect: gate)
    }
    
    func gateStateDidChange(_ gate: Gate) {
        if inputs.count == logicOperator.numberOfInputs() {
            let firstGate = inputs.first!
            let secondGate = inputs.last!
            
            switch (firstGate.state, secondGate.state) {
            case (.value(let a), .value(let b)):
                output.state = .value(logicOperator.logicResult(firstState: a, secondState: b))
                break
            default:
                output.state = .none
            }
        }
    }
}
