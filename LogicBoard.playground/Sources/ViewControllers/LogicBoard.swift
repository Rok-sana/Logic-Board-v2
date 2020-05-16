import Foundation
import UIKit
import SpriteKit

public class LogicBoard: UIViewController {
    
   public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.tintColor = .yellow
    }
    
   public override func loadView() {
        super.loadView()
        let skView = SKView(frame: CGRect(origin: .zero, size: contSize))
        // Create the scene and add it to the view
        let scene = SKScene(size: contSize)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = .clear
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        let redBox = Board(sections: [Section(logicOperators: [.AND, .NAND, .OR]), Section(logicOperators: [.AND, .OR])])
        scene.addChild(redBox)
        
        
        // Add a red box to the scene
        // scene.addChild(backgroundNode)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
        view.addSubview(skView)
    }
    
}
