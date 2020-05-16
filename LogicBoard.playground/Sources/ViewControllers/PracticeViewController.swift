import Foundation
import UIKit
import SpriteKit

public class PracticeViewController: UIViewController, AppleComputerViewDelegate {
    
    var currentLevel: LevelOfDifficulty = .easy // by default
    var redBox: Board?
    var scene: SKScene!
    
    var  skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var buttonsStack: UIStackView  = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
public override func loadView() {
  
        super.loadView()
        self.preferredContentSize = contSize
        // Create the scene and add it to the view
        
        scene = SKScene(size: contSize)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = .clear
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Add a red box to the scene
        redBox = Board(sections: [Section(logicOperators: getRandomSetOfOperators().first!), Section(logicOperators: getRandomSetOfOperators().last!)], diodeColor: .random)
        scene.addChild(redBox!)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
    }
    
  public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //  navigationController?.navigationBar.tintColor = .yellow
        setupLayout()
        
        
    }
    
   public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appleComputerView = AppleComputerView(text:Constant.Text.operatorsSpeech, delegate: self)
        self.view.addSubview(appleComputerView)
        self.view.leadingAnchor.constraint(equalTo: appleComputerView.leadingAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: appleComputerView.bottomAnchor).isActive = true
    }
    
    func setupLayout() {
        
        view.addSubview(skView)
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        LevelOfDifficulty.allCases.forEach {
            let button = CommonCustomButton(level: $0)
            button.addTarget(self, action: #selector(didSelectLevelButton(button: )), for: .touchUpInside)
            buttonsStack.addArrangedSubview(button)
        }
        
        view.addSubview(buttonsStack)
        buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        buttonsStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        view.addSubview(CustomBackButton(for: self))
        
    }
    
    @objc func didSelectLevelButton(button: CommonCustomButton) {
        guard let level = button.currentLevel else { return }
        redBox?.removeFromParent()
        currentLevel = level
        redBox = Board(sections: [Section(logicOperators: getRandomSetOfOperators().first!), Section(logicOperators: getRandomSetOfOperators().last!)], diodeColor: .random)
        scene.addChild(redBox!)
    }
    
    func getRandomSetOfOperators() -> [[LogicOperator]] {
        var array:[LogicOperator] = []
        let amountOfSecrion = 2
        let countOfOperators = currentLevel.countOfOperators * amountOfSecrion
        for i in 0..<countOfOperators {
            if let item = LogicOperator.allCases.randomElement() {
                array.append(item)
            }
        }
        let result = array.chunked(into: currentLevel.countOfOperators)
        return result
    }
    
    func chunked(by array: [LogicOperator],into size: Int) -> [[LogicOperator]] {
        return stride(from: 0, to: array.count, by: size).map {
            Array(array[$0 ..< min($0 + size, array.count)])
        }
    }
    
    //MARK: - AppleComputpublic erViewDelegate
    
  public func speechDidFinish(_ view: AppleComputerView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
        }) { (finish) in
            view.removeFromSuperview()
        }
    }
}
