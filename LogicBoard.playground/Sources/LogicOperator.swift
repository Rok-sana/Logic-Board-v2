//
//  LogicOperator.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import UIKit
import SpriteKit

public enum LogicOperator: String, CaseIterable, Equatable {
    case AND
    case OR
    case XOR
    case NOR
    case NAND
    case NXOR
    
    func path(frame: CGRect) -> LogicOperatorDetails {
        switch self {
        case .AND:
            return andPath(frame)
        case .OR:
            return orPath(frame)
        case .NAND:
            return andPath(frame, inversion: true)
        case .NOR:
            return orPath(frame, inversion: true)
        case .XOR:
            return xorPath(frame)
        case .NXOR:
            return xorPath(frame, inversion: true)
        }
    }
    
    func logicResult(firstState: Bool, secondState: Bool) -> Bool {
        switch self {
        case .AND:
            return firstState && secondState
        case .OR:
            return firstState || secondState
        case .NAND:
            return !(firstState && secondState)
        case .NOR:
            return !(firstState || secondState)
        case .XOR:
            return firstState != secondState
        case .NXOR:
            return !(firstState != secondState)
        }
    }
    
    // Current LogicOperator have only 2 inputs.
    func numberOfInputs() -> Int {
        return 2
    }
}

extension LogicOperator {

    typealias LogicOperatorDetails = (bezierPath: UIBezierPath, inputPositions: [CGPoint], ouputPosition: CGPoint)
    typealias TwoInputsPositions = (firstPosition: CGPoint, secondPosition: CGPoint)
    
    private func inOutLineWidth(for frame: CGRect) -> CGFloat {
        // 20 - is 20%
        return frame.width * 20/100
    }
    
    private func addInputLine(to bezierPath: UIBezierPath, frame: CGRect, isCurveOperator: Bool = false) -> TwoInputsPositions {
        let inLineY = frame.height/4
        let lineWidth = inOutLineWidth(for: frame)
        var xPosition: CGFloat = frame.origin.x + lineWidth
        if isCurveOperator { xPosition += Constant.operatorCurveMargin/3 }
        let inLin1Path = UIBezierPath()
        let input1Point = CGPoint(x: frame.origin.x, y: frame.origin.y + inLineY)
        inLin1Path.move(to: input1Point)
        inLin1Path.addLine(to: CGPoint(x: xPosition, y: frame.origin.y + inLineY))
        bezierPath.append(inLin1Path)
        let inLin2Path = UIBezierPath()
        let input2Point = CGPoint(x: frame.origin.x, y: frame.origin.y + inLineY*3)
        inLin2Path.move(to: input2Point)
        inLin2Path.addLine(to: CGPoint(x: xPosition, y: frame.origin.y + inLineY*3))
        bezierPath.append(inLin2Path)
        
        return (input1Point,input2Point)
    }
    
    private func addOutput(to bezierPath: UIBezierPath, operatorMaxX: CGFloat, frame: CGRect, inversion: Bool) -> CGPoint {
        var outputPoint: CGPoint = .zero
        let lineWidth = inOutLineWidth(for: frame)
        if inversion {
            let circleSize: CGFloat = Constant.symbolNotCircleSize
            let circle = UIBezierPath(ovalIn: CGRect(x: operatorMaxX, y: frame.origin.y + frame.height/2.0 - circleSize/2, width: circleSize, height: circleSize))
            bezierPath.append(circle)
            let outLinPath = UIBezierPath()
            outLinPath.move(to: CGPoint(x: circle.bounds.maxX, y: frame.origin.y + frame.height/2.0))
            outputPoint = CGPoint(x: circle.bounds.maxX + lineWidth, y: frame.origin.y + frame.height/2.0)
            outLinPath.addLine(to: outputPoint)
            bezierPath.append(outLinPath)
        } else {
            let outLinPath = UIBezierPath()
            outLinPath.move(to: CGPoint(x: operatorMaxX, y: frame.origin.y + frame.height/2.0))
            outputPoint = CGPoint(x: operatorMaxX + lineWidth, y: frame.origin.y + frame.height/2.0)
            outLinPath.addLine(to: outputPoint)
            bezierPath.append(outLinPath)
        }
        return outputPoint
    }
    
    private func orPath(_ frame: CGRect, inversion: Bool = false) -> LogicOperatorDetails {
        let bezierPath = UIBezierPath()
        
        let lineWidth = inOutLineWidth(for: frame)
        let inputsPositions = addInputLine(to: bezierPath, frame: frame, isCurveOperator: true)
        let operatorXPosition = frame.origin.x + lineWidth
        let operatorPath = UIBezierPath()
        let operatorWidth = frame.width-lineWidth*2
        operatorPath.move(to: CGPoint(x: operatorXPosition, y: frame.origin.y))
        // Curve doesn't close without magic 0.0001
        operatorPath.addLine(to:  CGPoint(x: operatorXPosition + 0.0001, y: frame.origin.y))
        operatorPath.addQuadCurve(to: CGPoint(x: operatorXPosition, y: frame.origin.y + frame.height), controlPoint: CGPoint(x: operatorXPosition + operatorWidth*2, y: frame.origin.y + frame.height/2.0))
        operatorPath.addQuadCurve(to: CGPoint(x: operatorXPosition + 0.0001, y: frame.origin.y), controlPoint: CGPoint(x: operatorPath.bounds.origin.x + Constant.operatorCurveMargin, y: frame.origin.y + frame.height/2.0))
        bezierPath.append(operatorPath)
        let outputPosition: CGPoint = addOutput(to: bezierPath, operatorMaxX: operatorPath.bounds.maxX, frame: frame, inversion: inversion)
        return (bezierPath, [inputsPositions.firstPosition, inputsPositions.secondPosition], outputPosition)
    }
    
    private func andPath(_ frame: CGRect, inversion: Bool = false) -> LogicOperatorDetails {
        let bezierPath = UIBezierPath()
        let lineWidth = inOutLineWidth(for: frame)
        let inputsPositions = addInputLine(to: bezierPath, frame: frame)
        let operatorPath = UIBezierPath()
        let operatorWidth = frame.width-lineWidth*2
        let operatorXPostion = frame.origin.x + lineWidth
        operatorPath.move(to: CGPoint(x: operatorXPostion, y: frame.origin.y))
        operatorPath.addLine(to: CGPoint(x: operatorXPostion + operatorWidth/2.0, y: frame.origin.y))
        operatorPath.addQuadCurve(to: CGPoint(x: operatorXPostion + operatorWidth/2.0, y: frame.origin.y + frame.height), controlPoint: CGPoint(x: operatorXPostion + operatorWidth/2.0 + operatorWidth , y: frame.origin.y + frame.height/2.0))
        
        operatorPath.addLine(to: CGPoint(x: operatorXPostion, y: frame.origin.y + frame.height))
        operatorPath.close()
        bezierPath.append(operatorPath)
        let outputPosition: CGPoint = addOutput(to: bezierPath, operatorMaxX: operatorPath.bounds.maxX, frame: frame, inversion: inversion)
        return (bezierPath, [inputsPositions.firstPosition, inputsPositions.secondPosition], outputPosition)
    }
    
    private func xorPath(_ frame: CGRect, inversion: Bool = false) -> LogicOperatorDetails {
        let bezierPath = UIBezierPath()
        let lineWidth = inOutLineWidth(for: frame)
        let inputsPositions = addInputLine(to: bezierPath, frame: frame)
        let operatorXPostion = frame.origin.x + lineWidth
        let inLinsCurvePath = UIBezierPath()
        inLinsCurvePath.move(to: CGPoint(x: operatorXPostion, y: frame.origin.y))
        // Curve doesn't close without magic 0.0001
        inLinsCurvePath.addQuadCurve(to: CGPoint(x: operatorXPostion + 0.0001, y: frame.origin.y + frame.height), controlPoint: CGPoint(x: operatorXPostion + Constant.operatorCurveMargin, y: frame.origin.y + frame.height/2.0))
        bezierPath.append(inLinsCurvePath)
        
        let operatorPath = UIBezierPath()
        let operatorWidth = frame.width-lineWidth*2
        let xorMargin: CGFloat = Constant.symbolLineWidth * 2
        operatorPath.move(to: CGPoint(x: operatorXPostion + xorMargin, y: frame.origin.y))
        operatorPath.addLine(to:  CGPoint(x: operatorXPostion + xorMargin + 0.0001, y: frame.origin.y))
        operatorPath.addQuadCurve(to: CGPoint(x: operatorXPostion + xorMargin, y: frame.origin.y + frame.height), controlPoint: CGPoint(x: operatorXPostion + operatorWidth*2, y: frame.origin.y + frame.height/2.0))
        operatorPath.addQuadCurve(to: CGPoint(x: operatorXPostion + xorMargin + 0.0001, y: frame.origin.y), controlPoint: CGPoint(x: operatorPath.bounds.origin.x + Constant.operatorCurveMargin, y: frame.origin.y + frame.height/2.0))
        bezierPath.append(operatorPath)
        let outputPosition: CGPoint = addOutput(to: bezierPath, operatorMaxX: operatorPath.bounds.maxX, frame: frame, inversion: inversion)
        return (bezierPath, [inputsPositions.firstPosition, inputsPositions.secondPosition], outputPosition)
    }
}

