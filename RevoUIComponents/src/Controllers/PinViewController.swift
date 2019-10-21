import UIKit
import RevoFoundation

class PinViewController : UIViewController {
    
    var length:Int = 4
    var stack:UIStackView!
    var dotsStackView:UIStackView!
    
    let dotSize:CGFloat = 12.0
    let buttonSize:CGFloat = 80
    
    var completion: ((_ pin:String)->Bool)!
    
    var enteredPin = "" {
        didSet {
            updateDots()
            if enteredPin.count == length {
                onPinComplete()
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.gray
        createMainStackView()
        stack.addArrangedSubview(UIView(widthConstraint: 50, heightConstraint: 80))
        addTitle()
        stack.addArrangedSubview(UIView(widthConstraint: 50, heightConstraint: 20))
        addDots()
        stack.addArrangedSubview(UIView(widthConstraint: 50, heightConstraint: 20))
        addButtons()
        stack.addArrangedSubview(UIView(widthConstraint: 50, heightConstraint: 150))
    }
    
    private func createMainStackView(){
        stack              = UIStackView(frame: view.bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        stack.distribution = .fillProportionally
    }
    
    private func addTitle(){
        let titleLabel     = UILabel()
        titleLabel.text    = self.title ?? "PIN"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        stack.addArrangedSubview(titleLabel)
        view.addSubview(stack)
    }
    
    private func addDots(){
        dotsStackView               = UIStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50))
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
        
        let buttonsVerticalStack = UIStackView()
        buttonsVerticalStack.axis = .vertical
        buttonsVerticalStack.alignment = .center
        buttonsVerticalStack.distribution = .fillEqually
        
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
    
    private func createNumberButton(_ number:Int) -> UIButton {
        let button                 = UIButton(widthConstraint: buttonSize, heightConstraint: buttonSize)
        button.layer.borderWidth   = 1  //TODO: Use .border() when RevoFoundation updated
        button.layer.borderColor   = UIColor.white.cgColor
        button.round(buttonSize/2) //TODO: Change for .circle() when RevoFoundation updated
        button.setTitle(str("%d",number), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.tag = number
        button.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        return button
    }
    
    private func addLastRowButtons(_ buttonsVerticalStack:UIStackView){
        let row         = UIStackView()
        row.axis        = .horizontal
        row.alignment   = .center
        row.distribution = .fillEqually
        row.spacing     = 30
        Array(0..<3).each { count in
            if(count == 0){
                let button                 = UIButton(widthConstraint: buttonSize, heightConstraint: buttonSize)
                button.setTitle("Cancel", for: .normal)
                button.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
                row.addArrangedSubview(button)
            }else if(count == 1){
                row.addArrangedSubview(createNumberButton(0))
            }else if(count == 2){
                let button                 = UIButton(widthConstraint: buttonSize, heightConstraint: buttonSize)
                button.setTitle("Delete", for: .normal)
                button.addTarget(self, action: #selector(onDeletePressed), for: .touchUpInside)
                row.addArrangedSubview(button)
            }
        }
        buttonsVerticalStack.addArrangedSubview(row)
    }
    
    @objc private func onCancelPressed(_ sender:UIButton){
        
    }
    
    @objc private func onDeletePressed(_ sender:UIButton){
        if (enteredPin.count == 0) { return }
        enteredPin = String(enteredPin.suffix(enteredPin.count - 1))
    }
    
    @objc private func onButtonPressed(_ sender:UIButton){
        enteredPin.append("\(sender.tag)")
        animateButton(sender)
    }
    
    private func onPinComplete(){
        guard let completion = completion else {
            return onWrongPin()
        }
        if (completion(enteredPin)){
            
        }
        onWrongPin()
    }
    
    private func animateButton(_ sender:UIButton){
        let colorAnimation          = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue    = UIColor.white.cgColor
        colorAnimation.duration     = 0.3  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
    }
    
    private func onWrongPin(){
        dotsStackView.shake()
        enteredPin = ""
    }
    
}


