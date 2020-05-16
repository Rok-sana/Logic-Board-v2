import Foundation
import UIKit

public class CustomBackButton: UIButton {
    
    let selfSize = CGSize(width: 60.0, height: 30.0)
    let currentVC: UIViewController
    
    init(for vc: UIViewController) {
        currentVC = vc
        super.init(frame: CGRect(origin: CGPoint(x: 10.0, y: 20.0), size: selfSize))
        configButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configButton() {
        addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        setTitle("Back", for: .normal)
        titleLabel?.font = UIFont(name: "bitwise", size: 15)!
        let image = UIImage(named: "arrowBack")?.withTintColor(.yellow)
        setImage(image, for: .normal)
        setTitleColor(.yellow, for: .normal)
        backgroundColor = .clear
    }
    
    @objc func dismiss() {
        currentVC.navigationController?.popViewController(animated: true)
    }
}
