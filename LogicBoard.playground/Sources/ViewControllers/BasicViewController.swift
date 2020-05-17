import Foundation
import UIKit
import SpriteKit

public class BasicViewController: UIViewController {
    
    var logicOperator: LogicOperator = .AND // by default
    var logicOperatorsButtons: [CommonCustomButton] = []
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
        redBox = Board(sections: [Section(logicOperators: [logicOperator])])
        scene.addChild(redBox!)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
    }
    
   public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.addSubview(skView)
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor, constant: -60).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        LogicOperator.allCases.forEach {
            let button = CommonCustomButton(logicOperator: $0)
            logicOperatorsButtons.append(button)
            button.addTarget(self, action: #selector(didSelectOperator(button:)), for: .touchUpInside)
            buttonsStack.addArrangedSubview(button)
        }
        
        view.addSubview(buttonsStack)
        buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        buttonsStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        view.addSubview(CustomBackButton(for: self))
        
    }
    @objc func didSelectOperator(button: CommonCustomButton) {
        guard let pattern = button.logicOperator else { return }
        redBox?.removeFromParent()
        redBox = Board(logicOperator: pattern)
        scene.addChild(redBox!)
    }
    
}

