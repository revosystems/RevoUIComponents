import UIKit

class PinView : UIView {
    
    var length:Int = 4
    let dotSize:CGFloat     = 12.0
    let buttonSize:CGFloat  = 80
    
    var isPinValid: ((_ pin:String)->Bool)!
    
    private var stack:UIStackView!
    private var dotsStackView:UIStackView!
    
    var enteredPin = "" {
        didSet {
            updateDots()
            if enteredPin.count == length {
                onPinComplete()
            }
        }
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }
    
    public func clear(){
        if (enteredPin.count == 0) { return }
        enteredPin = String(enteredPin.suffix(enteredPin.count - 1))
    }
    
    private func setup(){
        createMainStack()
        addDots()
        stack.addArrangedSubview(UIView(widthConstraint: 50, heightConstraint: 20))
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
        dotsStackView               = UIStackView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 50))
        dotsStackView.axis          = .horizontal
        dotsStackView.distribution  = .fillEqually
        dotsStackView.spacing       = 20
        
        Array((0..<length)).each { count in
            let dot = UIView(widthConstraint: CGFloat(dotSize), heightConstraint: dotSize)
            dot.round(dotSize/2)    //TODO: Change for .circle() when RevoFoundation updated
            dot.backgroundColor     = UIColor.clear //TODO: Use .border() when RevoFoundation updated
            dot.layer.borderWidth   = 1
            dot.layer.borderColor   = UIColor.white.cgColor
            dotsStackView.addArrangedSubview(dot)
        }
        stack.addArrangedSubview(dotsStackView)
    }
    
    private func updateDots(){
        DispatchQueue.main.async{ [unowned self] in
            let dots = self.dotsStackView.subviews
            dots.each { $0.backgroundColor = UIColor.clear }
            Array(0..<self.enteredPin.count).each { dotIndex in
                dots[dotIndex].backgroundColor = UIColor.white
            }
        }
    }
    
    private func addButtons(){
        
        let buttonsVerticalStack            = UIStackView()
        buttonsVerticalStack.axis           = .vertical
        buttonsVerticalStack.alignment      = .center
        buttonsVerticalStack.distribution   = .fillEqually
        
        Array(0..<3).each { count in
            let row         = UIStackView()
            row.axis        = .horizontal
            row.alignment   = .center
            row.distribution = .fillEqually
            row.spacing     = 30
            Array(0..<3).each { count2 in
                row.addArrangedSubview(createNumberButton(count * 3 + count2 + 1))
            }
            buttonsVerticalStack.addArrangedSubview(row)
        }
        stack.addArrangedSubview(buttonsVerticalStack)
        addLastRowButtons(buttonsVerticalStack)
    }
    
    private func addLastRowButtons(_ buttonsVerticalStack:UIStackView){
        let row         = UIStackView()
        row.axis        = .horizontal
        row.alignment   = .center
        row.distribution = .fillEqually
        row.spacing     = 30

        row.addArrangedSubview(createNumberButton(0))
        
        buttonsVerticalStack.addArrangedSubview(row)
    }
    
    private func createNumberButton(_ number:Int) -> UIButton {
        let button                 = UIButton(widthConstraint: buttonSize, heightConstraint: buttonSize)
        button.layer.borderWidth   = 1  //TODO: Use .border() when RevoFoundation updated
        button.layer.borderColor   = UIColor.white.cgColor
        button.round(buttonSize/2) //TODO: Change for .circle() when RevoFoundation updated
        button.setTitle("\(number)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.tag = number
        button.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        return button
    }
    
    @objc private func onButtonPressed(_ sender:UIButton){
        enteredPin.append("\(sender.tag)")
        animateButton(sender)
    }
    
    private func onPinComplete(){
        guard let isPinValid = isPinValid else {
            return onWrongPin()
        }
        if (isPinValid(enteredPin)){
            onRightPin()
        }
        onWrongPin()
    }
    
    private func animateButton(_ sender:UIButton){
        let colorAnimation          = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue    = UIColor.white.cgColor
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
