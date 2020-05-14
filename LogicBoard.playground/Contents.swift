import PlaygroundSupport
import UIKit
import SpriteKit

enum ColorDiod: String, CaseIterable {
    case green
    case red
    case blue
    case yellow
    
}

class DiodImageView: UIImageView {
    var turnOnImage: UIImage?
    var turnOffImage: UIImage?
    var timer: Timer?
    
    
    
    var isActiveState: Bool = false {
        didSet {
            image = isActiveState ? turnOnImage : turnOffImage
        }
    }
    
    init(color: ColorDiod) {
        super.init(image: UIImage())
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeMode), userInfo: nil, repeats: true)
        turnOnImage = getImagebyColorDiod(color, true)
        turnOffImage = getImagebyColorDiod(color)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeMode() {
        isActiveState = !isActiveState
    }
    
    func getImagebyColorDiod(_ color: ColorDiod, _ isTurnOn: Bool = false) -> UIImage? {
        let mode = isTurnOn ? "on" : "off"
        let lampString = "_lamp_"
        return UIImage(named: color.rawValue + lampString + mode)
    }
    
}




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
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Logic\n Board"
        label.textColor = .yellow
        return label
    }()
    
    override func loadView() {
        super.loadView()
        
        
        self.preferredContentSize = CGSize(width: 700, height: 500)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
        // view.layer.isOpaque = false
        // view.frame.size = contSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIFont.familyNames.contains("Bitwise") {
            let url = Bundle.main.url(forResource: "bitwise", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(url, CTFontManagerScope.process, nil)
        }
        titleLabel.font = UIFont(name: "bitwise", size: 80)!
        //view.backgroundColor = .green
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        addDiods()
        
    }
    
    func addDiods() {
        let size  = CGSize(width: 20, height: 40)
        let step = 20
        var x = 0
        var y = 0
        for i in 0..<5 {
            let color = ColorDiod.allCases.randomElement()
            let imageView = DiodImageView(color: color!)
            x = x + step
            y = y + step
            imageView.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            view.addSubview(imageView)
        }
        
    }
        func setupLayout() {
            nextButton.addTarget(self, action: #selector(nextButtonDidtap), for: .touchUpInside)
            
            view.addSubview(titleLabel)
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            view.addSubview(nextButton)
            //        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }
        
        @objc func nextButtonDidtap() {
            let logicBoard = LogicBoard()
            navigationController?.pushViewController(logicBoard, animated: true)
        }
    }
    
    class LogicBoard: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.setNavigationBarHidden(false, animated: false)
            
            navigationController?.navigationBar.tintColor = .yellow
            // navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "bitwise", size: 20)!]
            
            
        }
        
        public func texture(image: UIImage ,size: CGSize) -> SKTexture? {
            let textureSize = CGRect(origin: .zero, size: image.size)
            UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
            let context = UIGraphicsGetCurrentContext()
            context?.draw(image.cgImage!, in: textureSize, byTiling: true)
            let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            var texture: SKTexture? = nil
            if let CGImage = image?.cgImage {
                texture = SKTexture(cgImage: CGImage)
            }
            return texture
        }
        
        override func loadView() {
            super.loadView()
            let skView = SKView(frame: CGRect(origin: .zero, size: contSize))
            // Create the scene and add it to the view
            let scene = SKScene(size: contSize)
            scene.scaleMode = SKSceneScaleMode.aspectFit
            scene.backgroundColor = .clear
            skView.backgroundColor = .clear
            skView.presentScene(scene)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // let backgroundNode = SKSpriteNode(texture: texture(image: UIImage(named: "backgroundPatter.png")!, size: contSize))
            
            
            let redBox = Board(sections: [Section(logicOperators: [.AND, .NAND]), Section(logicOperators: [.AND, .OR])])
            scene.addChild(redBox)
            
            
            // Add a red box to the scene
            // scene.addChild(backgroundNode)
            
            view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
            view.addSubview(skView)
        }
        
    }
    
    
    
    let rootViewController = EscapeViewController()
    let navigation = UINavigationController(rootViewController: rootViewController)
    
    navigation.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
    
    navigation.navigationBar.shadowImage = UIImage()
    navigation.navigationBar.isTranslucent = true
    navigation.view.backgroundColor = .clear
    
    
    
    
    // Create the SpriteKit View
    
    
    // Show in assistant editor
    PlaygroundPage.current.liveView = navigation
    PlaygroundPage.current.needsIndefiniteExecution = true
