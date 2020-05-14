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

class Conductor: SKShapeNode {
    
    let firstGate: Gate
    let secodGate: Gate
    weak var delegate: ConductorDelegate?
    
    init(connect firstGate: Gate, with secodGate: Gate, _ parentNode: SKNode) {
        self.firstGate = firstGate
        self.secodGate = secodGate
        super.init()
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
        strokeColor = .yellow
        fillColor = .yellow
        lineWidth = 1.0
        lineWidth = 3
        commonConfiguration()
        firstGate.addConnection(with: secodGate)
        secodGate.addConnection(with: firstGate)
        
        
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
