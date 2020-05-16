//
//  Constant.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/20/19.
//

import Foundation
import SpriteKit

public struct Constant {
    
    static let boardAncherName: String = "BoardAncher"
    static let symbolSize: CGSize = CGSize(width: 160, height: 80)
    static let symbolNotCircleSize: CGFloat = 15
    static let symbolLineWidth: CGFloat = 3.5
    static let marginBetweenSymbolsInSection: CGFloat = 40
    static let marginBetweenSections: CGFloat = 30
    static let gateSize: CGFloat = 20
    static let buttonSize: CGFloat = 30
    static let buttonYPosition: CGFloat = 30
    static let marginBetweenButtonAndGate: CGFloat = 10
    static let marginBetweenButtonAndSection: CGFloat = 40
    static let marginBetweenSectionAndDiod: CGFloat = 25
    static let marginBetweenBoardAndButton: CGFloat = 15
    static let marginBetweenBoardAndDiod: CGFloat = 15
    static let operatorCurveMargin: CGFloat = 16
    static let logoLeftMargin: CGFloat = 8
    
    //MARK: - Texts
    public struct Text {

        static let introductionSpeech = "Hello, I'm Macintosh. Welcome to the Logic Bord game. Let me help you with basics of Boolean algebra. Press next button... \n\nP.S. If you don't know what is it Boolean algebra press info button."
        
        static let whatIsBooleanAlgebraSpeech = "Boolean algebra deals with Boolean (also called binary) values that are typically labeled true / false, 1 / 0, yes / no, on / off, and so forth. We will use 1 and 0. A Boolean function is a function that operates on binary inputs and returns binary outputs. Since computer hardware is based on the representation and manipulation of binary values, Boolean functions play a central role in the specification, construction, and optimization of hardware architectures. It's also used in electronics, databases and in computer programming languages."
        
        public static let operatorsSpeech = "Elementary algebra has four operations. Boolean algebra has only three basic operations: AND, OR, NOT, and several derived operations. Operations allow us to define relationships between input variables and get result on output.\n\nWell, it's time to practise. To see an operator behavior, you need to connect buttons to the operator's inputs and output to the light. Turn on the light!!! \n\nEach operator has Truth table, press on the question button to get more details about specific operator. Good Luck!"
        
        static let AND = "AND operatoe, so-called because the output of this gate will be true if and only if all inputs (first input and the second input) are true. Otherwise, the output is false."
        
        
        public static let OR = "OR gate, so-called because the output of this gate will be true if either or both of the inputs are true. If both inputs are false, then the output is false."
        
        static let NAND = "A variation on the idea of the AND operator is called the NAND operator. The word “NAND” is a verbal contraction of the words NOT and AND. The output is true if any of the inputs are false.\n\nThe symbol is an AND operator with a small circle on the output to illustrate this output signal inversion. NOT is inversion."
        
        static let NOR = "NOR operator is an OR operator with its output inverted. Its output is true if both inputs are false. Otherwise, the output is false. \n\nThe symbol is an OR operator with a small circle on the output. The small circle represents inversion. NOT is inversion."
        
        static let XOR = "The XOR (Exclusive-OR) operator’s output is true if either, but not both, of the inputs are true. The output is false if both inputs are false or if both inputs are true. Another way of looking at this circuit is to observe that the output is true if the inputs are different, and false if the inputs are the same."
        
        static let XNOR = "The XNOR operator is a combination of an XOR gate followed by a NOT operator. Its output is true if the inputs are the same, and false if the inputs are different.\n\nThe symbol is an XOR operator with a small circle on the output that represents the inversion. NOT is inversion."
        
        static let greenLine = "Green line means active line ( 1 between two gates)"
        static let redLine = "Red line means passive line ( 0 between two gates)"
        static let grayLine = "Gray line means some of operators don't have iputs value ( NoNe between two gates)"
        static let yellowCircle = "Yellow circle it's gate. You can connect gates between each other. Press on the gate to see available connections"
        static let buttons = "Press on the button to change output value 1 or 0"
        static let light = "The light is on when value on gate is 1"
        
        
       // static let operatorsSpeech = "Elementary algebra has four operations. Boolean algebra has only three basic operations: AND, OR, NOT, and several derived operations. Operations allow us to define relationships between input variables and get result on output.\n\nTo see behaviour of operator on practice. You should connect buttons to the operator's inputs and output to light.\n\nEach operator has Truth table, press on the question button to get more details about specific operator. Good Luck!"
    }
}
