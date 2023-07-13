import UIKit

public protocol PinViewAppearanceDelegate {
    func pinView(configureButton:UIButton, size:CGFloat)
    func pinView(shouldBlink:UIButton) -> Bool
}

public extension PinViewAppearanceDelegate {
    func pinView(shouldBlink:UIButton) -> Bool { true }
}

public class PinView : UIView {
    var length:Int = 4
    let dotSize:CGFloat     = 12.0
    let buttonSize:CGFloat  = 85
    
    var isPinValid: ((_ pin:String)->Bool)!
    
    var appearanceDelegate:PinViewAppearanceDelegate?
    
    private var stack:UIStackView!
    private var dotsStackView:PinDotsView!
    
    var enteredPin = "" {
        didSet {
            dotsStackView.update(pin: enteredPin)
            if enteredPin.count == length {
                onPinComplete()
            }
        }
    }
        
    public func clear(){
        if (enteredPin.count == 0) { return }
        enteredPin = String(enteredPin.suffix(enteredPin.count - 1))
    }
    
    func setup(_ pinLength:Int = 4){
        length = pinLength
        createMainStack()
        addDots()
        stack.addArrangedSubview(UIView().height(constant: 40))
        addButtons()
    }
    
    private func createMainStack(){
        stack              = UIStackView(frame: bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        stack.distribution = .fillProportionally
        addSubview(stack)
        stack.equalSizeAs(self)
    }
    
    private func addDots(){
        dotsStackView = PinDotsView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 50))
        stack.addArrangedSubview(dotsStackView)
        dotsStackView.setup(length: length, size: dotSize)
    }
        
    private func addButtons(){
        let buttonsVerticalStack            = UIStackView()
        buttonsVerticalStack.axis           = .vertical
        buttonsVerticalStack.alignment      = .center
        buttonsVerticalStack.distribution   = .fillEqually
        buttonsVerticalStack.spacing        = 15
        
        Array(0..<4).each { count in
            let row         = UIStackView()
            row.axis        = .horizontal
            row.alignment   = .center
            row.distribution = .fillEqually
            row.spacing     = 30
            if (count < 3) {
                Array(0..<3).each { count2 in
                    row.addArrangedSubview(createNumberButton(count * 3 + count2 + 1))
                }
            } else {
                row.addArrangedSubview(createNumberButton(0))
            }
            buttonsVerticalStack.addArrangedSubview(row)
        }
        stack.addArrangedSubview(buttonsVerticalStack)
    }
        
    private func createNumberButton(_ number:Int) -> UIButton {
        let button = UIButton(widthConstraint: buttonSize, heightConstraint: buttonSize)
        button.setTitle("\(number)", for: .normal)
        button.tag = number
        button.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        appearanceDelegate?.pinView(configureButton: button, size:buttonSize)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        return button
    }
    
    @objc private func onButtonPressed(_ sender:UIButton){
        enteredPin.append("\(sender.tag)")
        if (appearanceDelegate?.pinView(shouldBlink: sender) ?? true){
            animateButton(sender)
        }
    }
    
    private func onPinComplete(){
        guard let isPinValid = isPinValid else {
            return onWrongPin()
        }
        if (isPinValid(enteredPin)){
            return onRightPin()
        }
        onWrongPin()
    }
    
    private func animateButton(_ sender:UIButton){
        let colorAnimation          = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue    = tintColor.cgColor
        colorAnimation.duration     = 0.3  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
    }
    
    private func onRightPin(){
        //dismiss(animated: true)
    }
    
    private func onWrongPin(){
        dotsStackView.shake()
        enteredPin = ""
    }
    
}
