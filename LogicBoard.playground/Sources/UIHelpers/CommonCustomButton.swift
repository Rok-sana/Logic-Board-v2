import Foundation
import UIKit

public enum BaseButtonType: String, CaseIterable {
    
    case basic = "Basic"
    case practice = "Practice"
    case tips = "What is Boolean Algebra?"
}

public enum LevelOfDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var countOfOperators: Int {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 2
        case .hard:
            return 3
        }
    }
    var bgColor: UIColor {
        switch self {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
}

public class CommonCustomButton: UIButton {
    
    var logicOperator: LogicOperator?
    var currentLevel: LevelOfDifficulty?
    
    init() {
        super.init(frame: .zero)
    }
    
   public convenience init(logicOperator: LogicOperator) {
        self.init()
        self.logicOperator = logicOperator
        configButton()
        backgroundColor =  UIColor(red: 215/255.0, green: 216/255.0, blue: 211/255.0, alpha: 1.0)//.orange
        setTitle(logicOperator.rawValue, for: .normal)
        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        widthAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
    
    public convenience init(textItem: BaseButtonType) {
        self.init()
        configButton()
        backgroundColor =  UIColor(red: 215/255.0, green: 216/255.0, blue: 211/255.0, alpha: 1.0)
        setTitle(textItem.rawValue, for: .normal)
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        
    }
    
    public convenience init( level: LevelOfDifficulty) {
        self.init()
        configButton()
        currentLevel = level
        backgroundColor = level.bgColor
        setTitle(level.rawValue, for: .normal)
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        widthAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
    func configButton() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(.black, for: .normal)
        layer.borderWidth = 1.0
        titleLabel?.font = UIFont(name: "bitwise", size: 16)!
        let ySpace: CGFloat = 10.0
        let xSpace: CGFloat = 10.0
        contentEdgeInsets = UIEdgeInsets(top: ySpace, left: xSpace, bottom: ySpace, right: xSpace)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
