//
//  Section.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit

protocol SectionDelegate: class {
    func section(_ section: Section, didSelect gate: Gate)
}

/// Contains Symbols in one column
public class Section: SKSpriteNode {
    
    var symbols: [Symbol] = []
    weak var delegate: SectionDelegate?
    let width: CGFloat
    
    public init(logicOperators: [LogicOperator]) {
        let reversed: [LogicOperator] = logicOperators.reversed()
        let sectionHeight: CGFloat = Constant.symbolSize.height * CGFloat(reversed.count) + Constant.marginBetweenSymbolsInSection * CGFloat(reversed.count+1)
        
        for index in 0...reversed.count-1 {
            let logicOperator = reversed[index]
            let yPositon = -sectionHeight/2 + Constant.marginBetweenSymbolsInSection * CGFloat(index+1) + Constant.symbolSize.height * CGFloat(index)
            let symbol = Symbol(yPositon, logicOperator)
            symbols.append(symbol)
        }
        let widestSymbol = symbols.max(by: {$0.width < $1.width})!
        width = widestSymbol.width
        
        super.init(texture: nil, color: .clear, size: CGSize(width: width, height: sectionHeight))
        
        anchorPoint = CGPoint.zero
        zPosition = 1
        
        for symbol in symbols {
            symbol.delegate = self
            addChild(symbol)
        }
    }
    
    func availableGates(for gateType: Gate.GType) -> [Gate] {
        switch gateType {
        case .input:
            return symbols.map({$0.output})
        case .output:
            var inputGates: [Gate] = []
            for symbol in symbols {
                let gates = symbol.inputs.filter({$0.isAvailableForConnect})
                inputGates.append(contentsOf: gates)
            }
            return inputGates
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Section: SymbolDelegate {
    
    // MARK: - SymbolDelegate
    
    func symbol(_ symbol: Symbol, didSelect gate: Gate) {
        delegate?.section(self, didSelect: gate)
    }
}
