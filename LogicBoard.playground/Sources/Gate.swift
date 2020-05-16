//
//  Gate.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit

protocol GateDelegate: class {
    func gateDidSelect(_ gate: Gate)
    func gateStateDidChange(_ gate: Gate)
}

class Gate: SKShapeNode {
    
    enum GType {
        case input, output
    }
    
    enum State: Equatable {
        case none
        case value(Bool)
    }
    
    let type: GType
    weak var delegate: GateDelegate?
    weak var conductorDelegate: ConductorGateDelegate?
    var selected: Bool = false
    var connectedGates:[Gate] = []
    
    var state: State = .none {
        didSet {
            /// Swift 4.2: for loop doesn't call didSet for other gates(connectedGates) but forEach calls
            self.connectedGates.forEach({ if $0.type != .output { $0.state = self.state } })
            if self.type != .output {
                delegate?.gateStateDidChange(self)
            }
            
            conductorDelegate?.gateStateDidChange()
        }
    }
    
    var isAvailableForConnect: Bool {
        switch type {
        case .input:
            return connectedGates.isEmpty
        case .output:
            return true
        }
    }
    
    init(type: GType, position: CGPoint? = nil) {
        self.type = type
        super.init()
        
        var xPosition: CGFloat = 0
        var yPosition: CGFloat = 0
        if let position = position {
            xPosition = position.x + (type == .input ? -Constant.gateSize : 0)
            yPosition = position.y - Constant.gateSize/2
        }
        let circle = UIBezierPath(ovalIn: CGRect(x: xPosition, y: yPosition, width: Constant.gateSize, height: Constant.gateSize) )
        self.path = circle.cgPath
        strokeColor = .yellow
        fillColor = .clear
        lineWidth = 1.0
        lineWidth = 3
        zPosition = 3
        commonConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAvailableForConnect {
            selected = !selected
            strokeColor = selected ? .red : .yellow
            delegate?.gateDidSelect(self)
        }
    }
    
    func deSelect() {
        selected = false
        strokeColor = .yellow
    }
    
    func highlight(_ flag: Bool) {
        fillColor = flag ? .green : .clear
    }
    
    func removeConnection(with gate: Gate) {
        if let index = connectedGates.index(of: gate) {
            if self.type == .input {
                self.state = .none
            }
            connectedGates.remove(at: index)
        }
    }
    
    func addConnection(with gate: Gate) {
        connectedGates.append(gate)
        if self.type == .output {
            gate.state = state
        }
    }
}
