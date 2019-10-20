import UIKit
import RevoFoundation

class PinViewController : UIViewController {
    
    var length:Int = 4
    var stack:UIStackView!
    
    let dotSize:CGFloat = 12.0
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.gray
        addTitle()
        addDots()
        addButtons()
        stack.addArrangedSubview(UIView())
    }
    
    func addTitle(){
        stack              = UIStackView(frame: view.bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        stack.distribution = .fillProportionally
        let titleLabel     = UILabel()
        titleLabel.text    = self.title ?? "PIN"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        stack.addArrangedSubview(titleLabel)
        view.addSubview(stack)
    }
    
    func addDots(){
        let dotsStackView           = UIStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50))
        dotsStackView.axis          = .horizontal
        dotsStackView.distribution  = .fillEqually
        dotsStackView.spacing       = 10
        
        Array((0..<length - 1)).each { count in
            let dot = UIView(widthConstraint: CGFloat(dotSize), heightConstraint: dotSize)
            dot.round(dotSize/2)
            dot.backgroundColor     = UIColor.white
            dot.layer.borderWidth   = 1
            dot.layer.borderColor   = UIColor.white.cgColor
            dotsStackView.addArrangedSubview(dot)
        }
        stack.addArrangedSubview(dotsStackView)
    }
    
    func addButtons(){
        
        let buttonsVerticalStack = UIStackView()
        buttonsVerticalStack.axis = .vertical
        buttonsVerticalStack.alignment = .center
        buttonsVerticalStack.distribution = .fillEqually
        
        Array(0..<4).each { count in
            let row = UIStackView()
            row.axis = .horizontal
            row.alignment = .center
            row.distribution = .fillEqually
            Array(0..<3).each { count2 in
                let button = UIButton()
                button.setTitle(str("%d",count * 3 + count2 + 1), for: .normal)
                button.setTitleColor(.white, for: .normal)
                row.addArrangedSubview(button)
            }
            buttonsVerticalStack.addArrangedSubview(row)
        }
        stack.addArrangedSubview(buttonsVerticalStack)
    }
    
}


