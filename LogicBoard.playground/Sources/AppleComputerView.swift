//
//  AppleComputerView.swift
//  WWDC
//
//  Created by Oksana Bolibok on 15.05.2020.
//  Copyright © 2020 Oksana Bolibok. All rights reserved.
//

import UIKit
import AVFoundation

public protocol AppleComputerViewDelegate: class{
    func speechDidFinish(_ view: AppleComputerView)
}

public class AppleComputerView: UIView {
   
    private var speechSynthesizer = AVSpeechSynthesizer()
    private let utterance: AVSpeechUtterance
    private weak var delegate: AppleComputerViewDelegate?
    
    private let appleComputerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appleComputer.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        imageView.animationImages = [UIImage(named:"appleComputer.png")!,UIImage(named:"appleComputer1.png")!]
        imageView.animationDuration = 1;
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "bitwise", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let container = UIView()
    
    public init(text: String, delegate: AppleComputerViewDelegate) {
        self.delegate = delegate
        utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.3
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        super.init(frame: .zero)
        speechSynthesizer.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(appleComputerImageView)
        appleComputerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        appleComputerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: appleComputerImageView.trailingAnchor, constant: -15).isActive = true
        container.bottomAnchor.constraint(equalTo: appleComputerImageView.topAnchor).isActive = true
        self.alpha = 0
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1
        }) { (finish) in
            self.speechSynthesizer.speak(self.utterance)
        }
    }
    
    private func animateSpeach() {
        var lastView: UIView?
        let dotSizes = [8,16,22]
        let animationDuration: Double = 0.25
        
        for (index, size) in dotSizes.enumerated() {
            let dot = UIView()
            dot.alpha = 0.0
            dot.backgroundColor = .black
            dot.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(dot)
            dot.heightAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
            dot.widthAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
            
            if lastView == nil {
                container.bottomAnchor.constraint(equalTo: dot.bottomAnchor).isActive = true
                container.leadingAnchor.constraint(equalTo: dot.leadingAnchor).isActive = true
            } else {
                dot.bottomAnchor.constraint(equalTo: lastView!.topAnchor, constant: -5).isActive = true
                dot.leadingAnchor.constraint(equalTo: lastView!.trailingAnchor, constant: 5).isActive = true
            }
            lastView = dot
            
            UIView.animate(withDuration: animationDuration, delay: Double(index) * animationDuration, options: .curveLinear, animations: {
                dot.alpha = 1.0
            }, completion: nil)
        }
        
        let bubble = UIView()
        bubble.alpha = 0
        bubble.backgroundColor = .black
        container.addSubview(bubble)
        bubble.addSubview(label)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.bottomAnchor.constraint(equalTo: lastView!.topAnchor, constant: -5).isActive = true
        bubble.leadingAnchor.constraint(equalTo: lastView!.trailingAnchor, constant: 5).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        
        label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8).isActive = true
        label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        bubble.clipsToBounds = true
        
        UIView.animate(withDuration: animationDuration, delay: Double(dotSizes.count)*animationDuration, options: .curveLinear, animations: {
            
            bubble.alpha = 1.0
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleComputerView: AVSpeechSynthesizerDelegate {
  
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let start = String.Index(utf16Offset: 0, in: utterance.speechString)
        let end = String.Index(utf16Offset: characterRange.location+characterRange.length, in: utterance.speechString)
        let substring = String(utterance.speechString[start..<end])
        self.label.text = substring
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        animateSpeach()
        appleComputerImageView.startAnimating()
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.label.text = utterance.speechString
        appleComputerImageView.stopAnimating()
        appleComputerImageView.image = UIImage(named: "appleComputer.png")
        delegate?.speechDidFinish(self)
    }
}
