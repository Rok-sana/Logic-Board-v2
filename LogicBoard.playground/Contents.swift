import PlaygroundSupport
import UIKit
import SpriteKit
import AVKit

let rootViewController = EscapeViewController()

let navigation = UINavigationController(rootViewController: rootViewController)

navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
navigation.navigationBar.shadowImage = UIImage()
navigation.navigationBar.isTranslucent = true
navigation.view.backgroundColor = .clear

// Create the SpriteKit View
// Show in assistant editor
PlaygroundPage.current.liveView = navigation
PlaygroundPage.current.needsIndefiniteExecution = true
