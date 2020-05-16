import PlaygroundSupport
import UIKit
import SpriteKit

enum LevelOfDifficulty: String, CaseIterable {
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

class PracticeViewController: UIViewController {
    
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
    
    override func loadView() {
        
        super.loadView()
        self.preferredContentSize = CGSize(width: 700, height: 500)
        // Create the scene and add it to the view
        
        scene = SKScene(size: contSize)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = .clear
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Add a red box to the scene
        // scene.addChild(backgroundNode)
        redBox = Board(sections: [Section(logicOperators: getRandomSetOfOperators().first!), Section(logicOperators: getRandomSetOfOperators().last!)], diodeColor: .random)
        scene.addChild(redBox!)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //  navigationController?.navigationBar.tintColor = .yellow
        setupLayout()
        
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
    
}



enum ColorDiod: String, CaseIterable {
    case red
    case blue
    case yellow
    case green
    
}

enum BaseButtonType: String, CaseIterable {
    
    case basic = "Basic"
    case practice = "Practice"
    case tips = "What is Boolean Algebra?"
    
}

class CommonCustomButton: UIButton {
    
    var logicOperator: LogicOperator?
    var currentLevel: LevelOfDifficulty?
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(logicOperator: LogicOperator) {
        self.init()
        self.logicOperator = logicOperator
        configButton()
        backgroundColor =  UIColor(red: 215/255.0, green: 216/255.0, blue: 211/255.0, alpha: 1.0)//.orange
        setTitle(logicOperator.rawValue, for: .normal)
        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        widthAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
    
    convenience init(textItem: BaseButtonType) {
        self.init()
        configButton()
        backgroundColor =  UIColor(red: 215/255.0, green: 216/255.0, blue: 211/255.0, alpha: 1.0)
        setTitle(textItem.rawValue, for: .normal)
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        
    }
    
    convenience init( level: LevelOfDifficulty) {
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
        let xSpace: CGFloat = 15.0
        contentEdgeInsets = UIEdgeInsets(top: ySpace, left: xSpace, bottom: ySpace, right: xSpace)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BasicViewController: UIViewController {
    
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
    
    override func loadView() {
        
        super.loadView()
        self.preferredContentSize = CGSize(width: 700, height: 500)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.addSubview(skView)
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        LogicOperator.allCases.forEach {
            let button = CommonCustomButton(logicOperator: $0)
            logicOperatorsButtons.append(button)
            button.addTarget(self, action: #selector(didSelectOperator(button:)), for: .touchUpInside)
            buttonsStack.addArrangedSubview(button)
        }
        
        view.addSubview(buttonsStack)
        buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        buttonsStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
    }
    @objc func didSelectOperator(button: CommonCustomButton) {
        guard let pattern = button.logicOperator else { return }
        redBox?.removeFromParent()
        redBox = Board(logicOperator: pattern)
        scene.addChild(redBox!)
    }
    
}

class DiodImageView: UIImageView {
    var turnOnImage: UIImage?
    var turnOffImage: UIImage?
    var timer: Timer?
    
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
        label.text = " Basics of Boolean Algebra"
        label.textColor = .yellow
        return label
    }()
    
    var buttonsStack: UIStackView  = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
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
            
            
            var r = max(170 * i, 10)
            var u =  10
            for j in 0..<3 {
                let color = ColorDiod.allCases[j]
                let imageView = DiodImageView(color: color)
                arrayImageView.append(imageView)
                
                
                //var y =  max(emptyView.bounds.minY * CGFloat(j), emptyView.bounds.minY)
                x = 200/// min(x + CGFloat(step), emptyView.frame.maxX)
                y = 0//min(y + CGFloat(step), emptyView.frame.maxY)
                
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
        }
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        view.addSubview(subTitleLabel)
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        
        
        let basicButton = CommonCustomButton(textItem: .basic)
        basicButton.addTarget(self, action: #selector(nextButtonDidtap), for: .touchUpInside)
        
        let practiceButton = CommonCustomButton(textItem: .practice)
        practiceButton.addTarget(self, action: #selector(practiceButtonDidTap), for: .touchUpInside)
        let tipsButton = CommonCustomButton(textItem: .tips)
        buttonsStack.addArrangedSubview(basicButton)
        buttonsStack.addArrangedSubview(practiceButton)
        buttonsStack.addArrangedSubview(tipsButton)
        view.addSubview(buttonsStack)
        buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonsStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30).isActive = true
        
        
    }
    
    @objc func nextButtonDidtap() {
        let logicBoard = BasicViewController()//LogicBoard()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(logicBoard, animated: true)
        }
        
    }
    
    
    @objc func practiceButtonDidTap() {
           let logicBoard =  PracticeViewController()//LogicBoard()
           DispatchQueue.main.async {
               self.navigationController?.pushViewController(logicBoard, animated: true)
           }
           
       }
   
}

class LogicBoard: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.tintColor = .yellow
        
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
