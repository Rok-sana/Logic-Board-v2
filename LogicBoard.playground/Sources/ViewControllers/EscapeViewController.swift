import Foundation
import UIKit

public class EscapeViewController: UIViewController {
    public var arrayImageView: [DiodImageView] = []
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
    
    public override func loadView() {
        super.loadView()
        
        self.preferredContentSize = CGSize(width: 700, height: 500)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPatter.png")!)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIFont.familyNames.contains("Bitwise") {
            let url = Bundle.main.url(forResource: "bitwise", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(url, CTFontManagerScope.process, nil)
        }
        titleLabel.font = UIFont(name: "bitwise", size: 80)!
        subTitleLabel.font = UIFont(name: "bitwise", size: 40)!
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        startAnnimateDiods()
    }
    
    public func setupLayout() {
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
                x = 200
                y = 0
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
            view.addSubview(emptyView)
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
        buttonsStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30).isActive = true
    }
    
    public func startAnnimateDiods() {
        for value in 0..<arrayImageView.count/2 {
            let seconds = 0.3 + Double(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.arrayImageView[value].startAnimateDiod()
                self.arrayImageView[value + 3].startAnimateDiod()
            }
        }
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

