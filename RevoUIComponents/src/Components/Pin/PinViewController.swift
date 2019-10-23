import UIKit
import RevoFoundation

class PinViewController : UIViewController {
    
    var stack:UIStackView!
    var dotsStackView:UIStackView!
    
    let pinView = PinView()
    
    var isPinValid: ((_ pin:String)->Bool)! {
        didSet {
            pinView.isPinValid = { [unowned self] in 
                let result = self.isPinValid($0)
                if (self.isPinValid($0)) {
                    self.dismiss(animated: true)
                }
                return result
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.gray
        createMainStackView()
        //stack.addArrangedSubview(UIView(widthConstraint: 10, heightConstraint: 10))
        addTitle()
        stack.addArrangedSubview(UIView(widthConstraint: 10, heightConstraint: 10))
        addPinView()
        stack.addArrangedSubview(UIView(widthConstraint: 10, heightConstraint: 10))
    }
    
    private func createMainStackView(){
        stack              = UIStackView(frame: view.bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.equalSizeAs(view)        
    }
    
    private func addTitle(){
        let titleLabel     = UILabel()
        titleLabel.text    = self.title ?? "PIN"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        stack.addArrangedSubview(titleLabel)
    }
    
    private func addPinView(){
        stack.addArrangedSubview(pinView)
    }
    
    
    /*private func addLastRowButtons(_ buttonsVerticalStack:UIStackView){
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
    }*/
    
    @objc private func onCancelPressed(_ sender:UIButton){
        
    }
    
    @objc private func onDeletePressed(_ sender:UIButton){
        pinView.clear()
    }
    
    
    
}


