//
//  Conductor.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit

protocol ConductorDelegate: class {
    func conductorDidRemove(_ conductor: Conductor)
}

protocol ConductorGateDelegate: class {
    func gateStateDidChange()
}

class Conductor: SKShapeNode {
    
    let firstGate: Gate
    let secodGate: Gate
    weak var delegate: ConductorDelegate?
    
    init(connect firstGate: Gate, with secodGate: Gate, _ parentNode: SKNode) {
        self.firstGate = firstGate
        self.secodGate = secodGate
        super.init()
        
        setConductorColor()
        
        lineCap = .round
        glowWidth = 20
        lineWidth = 1.0
        lineWidth = 3
        
        let bezierPath = UIBezierPath()
        let startPosition = firstGate.convert(firstGate.frame.center, to: parentNode)
        let endPosition = secodGate.convert(secodGate.frame.center, to: parentNode)
        bezierPath.move(to: startPosition)
        bezierPath.addLine(to: endPosition)
        let circleSize:CGFloat = 8
        let startCircle = UIBezierPath(ovalIn: CGRect(x: startPosition.x-circleSize/2, y: startPosition.y-circleSize/2, width: circleSize, height: circleSize))
        bezierPath.append(startCircle)
        let endCircle = UIBezierPath(ovalIn: CGRect(x: endPosition.x-circleSize/2, y: endPosition.y-circleSize/2, width: circleSize, height: circleSize))
        bezierPath.append(endCircle)
        self.path = bezierPath.cgPath
        firstGate.conductorDelegate = self
        secodGate.conductorDelegate = self
       
        
        
        commonConfiguration()
        firstGate.addConnection(with: secodGate)
        secodGate.addConnection(with: firstGate)
        
    }
    
    func setConductorColor() {
        
        let zeroSignalColor = UIColor(red: 252.0/255.0, green: 22.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        
        switch firstGate.state {
        case .value(let isOn):
            strokeColor = isOn ? .green : zeroSignalColor
            fillColor = isOn ? .green : zeroSignalColor
        default:
            strokeColor = .lightGray
            fillColor = .lightGray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstGate.removeConnection(with: secodGate)
        secodGate.removeConnection(with: firstGate)
        delegate?.conductorDidRemove(self)
        removeFromParent()
    }
}

extension Conductor: ConductorGateDelegate {
    func gateStateDidChange() {
        setConductorColor()
    }
    
    
}
