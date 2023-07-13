import Foundation
import UIKit

public class PinDotsView : UIStackView {
    
    @objc public func setup(length:Int, size:CGFloat){
        axis          = .horizontal
        distribution  = .fillEqually
        spacing       = 20
        
        Array(0..<length).each { count in
            let dot = UIView(widthConstraint: CGFloat(size), heightConstraint: size)
            dot.round(size/2)
            dot.backgroundColor     = .clear
            dot.layer.borderWidth   = 1
            dot.layer.borderColor   = tintColor.cgColor
            addArrangedSubview(dot)
        }
    }
    
    @objc public func update(pin:String){
        UIView.animate(withDuration: 0.2) { [unowned self] in
            subviews.eachWithIndex { (dot, index) in
                dot.backgroundColor = index < pin.count ? tintColor : .clear
            }
        }
    }
}
