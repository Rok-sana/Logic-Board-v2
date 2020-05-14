//
//  Board.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/22/19.
//

import Foundation
import UIKit
import SpriteKit

/// Board contains Sections with symbols. Draws green background from the pattern image
/// Add connections between gates.
public class Board: SKSpriteNode {
    
    var sections: [Section] = []
    var diods: [Diode] = []
    let firstSignalButton = Button()
    let secondSignalButton = Button()
    var availabelGatesForConnect: [Gate]?
    var selectedGate: Gate?
    
    public init(sections: [Section], diodeColor: DiodeColor? = nil) {
        self.sections = sections
        let higherSection = sections.max(by: {$0.frame.height < $1.frame.height})
        let sectionsWidth: CGFloat = sections.map({$0.width}).reduce(0, +) + Constant.marginBetweenSections * CGFloat(sections.count-1)
        
        // Load font
        if !UIFont.familyNames.contains("Bitwise") {
            let url = Bundle.main.url(forResource: "bitwise", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(url, CTFontManagerScope.process, nil)
        }
        
        let label = SKLabelNode(text: "Logic\n Board")
        label.numberOfLines = 2
        label.fontSize = 15
        label.fontName = "bitwise"
        label.fontColor = .yellow
        label.zPosition = 1
        
        let diodWidth = Constant.gateSize
        let boardSize = CGSize(width: Constant.marginBetweenBoardAndButton + firstSignalButton.width + Constant.marginBetweenButtonAndSection + sectionsWidth + Constant.marginBetweenSectionAndDiod + diodWidth + Constant.marginBetweenBoardAndDiod, height: higherSection!.frame.size.height)
        
        super.init(texture: UIImage(named: "backgroundPatter.png")!.texture(size: boardSize), color: .red, size: boardSize)
        
        let buttonXPostion: CGFloat = -self.frame.size.width/2 + Constant.marginBetweenBoardAndButton
        firstSignalButton.position = CGPoint(x: buttonXPostion, y: Constant.buttonYPosition)
        secondSignalButton.position = CGPoint(x: buttonXPostion, y: -Constant.buttonYPosition)
        firstSignalButton.delegate = self
        secondSignalButton.delegate = self
        addChild(firstSignalButton)
        addChild(secondSignalButton)
        
        var lastSection: Section?
        for section in sections {
            section.delegate = self
            var xPosition: CGFloat = lastSection == nil ? firstSignalButton.position.x + firstSignalButton.width + Constant.marginBetweenButtonAndSection : lastSection!.width + lastSection!.position.x
            
            xPosition += lastSection == nil ? 0 : Constant.marginBetweenSections
            section.position = CGPoint(x: xPosition, y: 0)
            addChild(section)
            lastSection = section
        }
        
        let diodXPosition = lastSection!.position.x + lastSection!.width + Constant.marginBetweenSectionAndDiod
        
        var defaultDiodeColor: DiodeColor = .red
        if let diodeColor = diodeColor {
            defaultDiodeColor = diodeColor
        }
        
        for symbol in lastSection!.symbols {
            let diod = Diode(color: defaultDiodeColor)
            diod.delegate = self
            diod.position = CGPoint(x: diodXPosition, y: symbol.output.frame.origin.y)
            addChild(diod)
            self.diods.append(diod)
        }
        
        let bottomLabelMargin: CGFloat = 4
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: self.frame.size.width/2 - label.frame.width - Constant.logoLeftMargin, y: -self.frame.size.height/2 + bottomLabelMargin)
        addChild(label)
        
    }
    
   public convenience init(logicOperator: LogicOperator, diodeColor: DiodeColor? = nil) {
        let section = Section(logicOperators: [logicOperator])
        self.init(sections: [section], diodeColor: diodeColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connectGatesIfPosible(_ gate: Gate, else prepareavailabelGates:() -> Void) {
        if selectedGate == gate {
            undoConnections()
        } else if let selectedGate = selectedGate, let availabelGatesForConnect = availabelGatesForConnect {
            if availabelGatesForConnect.contains(gate) {
                let conductor = Conductor(connect: selectedGate, with: gate, self)
                conductor.delegate = self
                addChild(conductor)
                gate.deSelect()
                undoConnections()
            } else {
                gate.deSelect()
            }
        } else {
            selectedGate = gate
            prepareavailabelGates()
        }
    }
    
    func undoConnections() {
        if let availabelGatesForConnect = availabelGatesForConnect {
            for gate in availabelGatesForConnect {
                gate.highlight(false)
            }
        }
        self.selectedGate?.deSelect()
        self.selectedGate = nil
        self.availabelGatesForConnect = nil
        firstSignalButton.highlight(false)
        secondSignalButton.highlight(false)
        
        for diod in diods {
            diod.highlight(false)
        }
        
    }
    
    func highlightAvalilabelGates( type: Gate.GType, in section: Section) {
        let gates = section.availableGates(for: type)
        availabelGatesForConnect = gates
        for availabelGate in gates {
            availabelGate.highlight(true)
        }
    }
}


extension Board: SectionDelegate, ButtonDelegate, DiodeDelegate, ConductorDelegate {
    
    // MARK: - ButtonDelegate
    
    func section(_ section: Section, didSelect gate: Gate) {
        connectGatesIfPosible(gate) {
            let index: Int = sections.index(of: section)!
            var neededSectionIndex: Int = index
            neededSectionIndex += gate.type == .output ? 1 : -1
            
            if sections.indices.contains(neededSectionIndex) {
                let section = sections[neededSectionIndex]
                highlightAvalilabelGates(type: gate.type, in: section)
            } else {
                switch gate.type {
                case .output:
                    var gates: [Gate] = []
                    for diod in diods {
                        if diod.isAvailableForConnect {
                            diod.highlight(true)
                            gates.append(diod.gate)
                        }
                    }
                    availabelGatesForConnect = gates
                    break
                case .input:
                    availabelGatesForConnect = [firstSignalButton.gate, secondSignalButton.gate]
                    firstSignalButton.highlight(true)
                    secondSignalButton.highlight(true)
                    break
                }
            }
        }
    }
    
    // MARK: - ButtonDelegate
    
    func button(_ button: Button, didSelect gate: Gate) {
        connectGatesIfPosible(gate) {
            highlightAvalilabelGates(type: gate.type, in: sections.first!)
        }
    }
    
    // MARK: - DiodeDelegate
    
    func diode(_ diode: Diode, didSelect gate: Gate) {
        connectGatesIfPosible(gate) {
            highlightAvalilabelGates(type: gate.type, in: sections.last!)
        }
    }
    
    // MARK: - ConductorDelegate
    
    func conductorDidRemove(_ conductor: Conductor) {
        if selectedGate != nil {
            undoConnections()
        }
    }
}
