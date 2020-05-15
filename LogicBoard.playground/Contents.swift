import PlaygroundSupport
import UIKit
import SpriteKit

enum ColorDiod: String, CaseIterable {
    case red
    case blue
    case yellow
    case green
    
}

class DiodImageView: UIImageView {
    var turnOnImage: UIImage?
    var turnOffImage: UIImage?
    var timer: Timer?
    
    //    var isActiveState: Bool = false {
    //        didSet {
    //            image = isActiveState ? turnOnImage : turnOffImage
    //        }
    //    }
    
    init(color: ColorDiod) {
        super.init(image: DiodImageView.getImagebyColorDiod(color))
        turnOnImage = DiodImageView.getImagebyColorDiod(color, true)
        turnOffImage = DiodImageView.getImagebyColorDiod(color)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimateDiods() {
        animationImages = [turnOnImage!, turnOffImage!]
        animationDuration = 1
        startAnimating()
    }

   static func getImagebyColorDiod(_ color: ColorDiod, _ isTurnOn: Bool = false) -> UIImage? {
        let mode = isTurnOn ? "on" : "off"
        let lampString = "_lamp_"
        return UIImage(named: color.rawValue + lampString + mode)
    }
    
}

//let redBox = Board(logicOperator: .AND, diodeColor: .red)
let contSize = CGSize(width: 700, height: 500)

class EscapeViewController: UIViewController {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Logic\n Board"
        label.textColor = .yellow
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = " Basics \n  of \n Boolean Algebra"
        label.textColor = .yellow
        return label
    }()
    
    
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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIFont.familyNames.contains("Bitwise") {
            let url = Bundle.main.url(forResource: "bitwise", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(url, CTFontManagerScope.process, nil)
        }
        titleLabel.font = UIFont(name: "bitwise", size: 80)!
        subTitleLabel.font = UIFont(name: "bitwise", size: 40)!
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        addDiods()
        
    }
    
    func addDiods() {
        
        
    }
    
    func setupLayout() {
        
        var arrayImageView: [DiodImageView] = []
        let size  = CGSize(width: 20, height: 40)
        let step = 60
        let point = 500
        
        for i in 0..<2 {
            
            var emptyView = UIView(frame: CGRect(x: point * i , y: 0, width: 200, height: 200))
            emptyView.backgroundColor = .clear
            var x = emptyView.frame.minX
            var y =  emptyView.frame.minY
            print(emptyView.frame.minX)
            //print(point * i )
            var r = max(170 * i, 10)
            var u =  10
            for j in 0..<3 {
                let color = ColorDiod.allCases[j]
                let imageView = DiodImageView(color: color)
                arrayImageView.append(imageView)
                
                
                //var y =  max(emptyView.bounds.minY * CGFloat(j), emptyView.bounds.minY)
                x = 200/// min(x + CGFloat(step), emptyView.frame.maxX)
                y = 0//min(y + CGFloat(step), emptyView.frame.maxY)
                print(emptyView.frame.maxX)
                imageView.frame = CGRect(origin: CGPoint(x: r, y: u), size: size)
                if i < 1 {
                    r += step
                    u += step
                } else {
                    r -= step
                    u -= step * (-1)
                }
                
                emptyView.addSubview(imageView)
            }
            
            //            x = x + step
            //            y = y + step
            
            
            
            view.addSubview(emptyView)
            
        }
        
        
        for value in 0..<arrayImageView.count/2 {
            var dispatchAfter = DispatchTimeInterval.seconds(value)
            
            UIView.animate(withDuration: 0, delay: TimeInterval(value), options: .curveLinear, animations: {
                arrayImageView[value].startAnimateDiods()
                arrayImageView[value + 3].startAnimateDiods()
            }, completion: nil)
            
//            DispatchQueue.main.asyncAfter(deadline: dispatchAfter, execute: {
//
//        })
        }
//        for i in 0..<2 {
//            stride(from: i, to: arrayImageView.count, by: 3).forEach { value in
//                DispatchQueue.main.asyncAfter(deadline: .now() + i, execute: {
//                    if value <= arrayImageView.count - 1 {
//                        arrayImageView[value].startAnimateDiods()
//                        print(value)
//                    }
//
//                    //print(arrayImageView.count)
//                   // arrayImageView[value + 2].startAnimateDiods()
//                })
//            }
//        }
        
//        DispatchQueue.main.async {
//            d
//            arrayImageView.forEach{ $0.startAnimateDiods()}
//        }
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        view.addSubview(subTitleLabel)
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonDidtap), for: .touchUpInside)
        
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
        
        
        let redBox = Board(sections: [Section(logicOperators: [.AND, .NAND, .OR]), Section(logicOperators: [.AND, .OR])])
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
