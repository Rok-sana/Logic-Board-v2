import PlaygroundSupport
import UIKit
import SpriteKit

//let redBox = Board(logicOperator: .AND, diodeColor: .red)
let contSize = CGSize(width: 700, height: 500)

class EscapeViewController: UIViewController {
    var nextButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        self.preferredContentSize = CGSize(width: 700, height: 500)
       // view.frame.size = contSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupLayout()
    }
    
    func setupLayout() {
        nextButton.addTarget(self, action: #selector(nextButtonDidtap), for: .touchUpInside)
        view.addSubview(nextButton)
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func nextButtonDidtap() {
        let logicBoard = LogicBoard()
        navigationController?.pushViewController(logicBoard, animated: true)
    }
}

class LogicBoard: UIViewController {
    
    override func loadView() {
        super.loadView()
        let skView = SKView(frame: CGRect(origin: .zero, size: contSize))
        // Create the scene and add it to the view
        let scene = SKScene(size: contSize)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = .white
        skView.presentScene(scene)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add a red box to the scene
        scene.addChild(redBox)
        view = skView
    }
    
}
let rootViewController = EscapeViewController()
let navigation = UINavigationController(rootViewController: rootViewController)



let redBox = Board(sections: [Section(logicOperators: [.AND, .NAND]), Section(logicOperators: [.AND, .OR])])

// Create the SpriteKit View


// Show in assistant editor
PlaygroundPage.current.liveView = navigation
PlaygroundPage.current.needsIndefiniteExecution = true
