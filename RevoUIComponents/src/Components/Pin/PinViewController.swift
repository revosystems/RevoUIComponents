import UIKit
import RevoFoundation

public class PinViewController : UIViewController, PinViewAppearanceDelegate {
    
    var canCancel = false
    
    private var stack:UIStackView!
    private var innerStackView:UIStackView!
    
    public let pinView = PinView()
    
    public var isPinValid: ((_ pin:String)->Bool)! {
        didSet { pinValidProxy() }
    }
    
    override public func viewDidLoad() {
        view.backgroundColor = UIColor.gray
        createMainStackView()
        addSpacing(200)
        //stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(innerStackView)
        addTitle()
        addPinView()
        addActionButtons()
        stack.addArrangedSubview(UIView())
        //addSpacing(200)
    }
    
    private func addSpacing(_ size:CGFloat){
        stack.addArrangedSubview(UIView().height(constant: size))
    }
    
    private func createMainStackView(){
        stack              = UIStackView(frame: view.bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        //stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.equalSizeAs(view)
        
        innerStackView              = UIStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        //innerStackView.height(constant: 400)
        innerStackView.axis         = .vertical
        innerStackView.alignment    = .center
        //innerStackView.distribution = .fill
    }
    
    private func addTitle(){
        let titleLabel     = UILabel().height(constant: 40)
        titleLabel.text    = title ?? "PIN"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        innerStackView.addArrangedSubview(titleLabel)
    }
    
    private func addPinView(){
        pinView.appearanceDelegate = self
        innerStackView.addArrangedSubview(pinView)
        pinView.setup()
    }
    
    public func pinView(configureButton:UIButton, size:CGFloat) {
        configureButton.layer.borderWidth   = 1  //TODO: Use .border() when RevoFoundation updated
        configureButton.layer.borderColor   = UIColor.white.cgColor
        configureButton.round(size/2) //TODO: Change for .circle() when RevoFoundation updated
        configureButton.titleLabel?.font = .systemFont(ofSize: 25)
        configureButton.setTitleColor(.white, for: .normal)
    }
    
    
    private func addActionButtons(){
        let row         = UIStackView().height(constant: 0)
        row.axis        = .horizontal
        row.spacing     = 200

        let cancelButton = UIButton()
        cancelButton.setTitle(canCancel ? "Cancel" : "", for: .normal)
        cancelButton.setTitleColor(.lightGray, for:.highlighted)
        if (canCancel) {
            cancelButton.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
        }
        row.addArrangedSubview(cancelButton)

        let deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(onDeletePressed), for: .touchUpInside)
        deleteButton.setTitleColor(.lightGray, for:.highlighted)
        row.addArrangedSubview(deleteButton)
    

        innerStackView.addArrangedSubview(row)
    }
    
    @objc private func onCancelPressed(_ sender:UIButton){
        dismiss(animated: true)
    }
    
    @objc private func onDeletePressed(_ sender:UIButton){
        pinView.clear()
    }
    
    private func pinValidProxy(){
        pinView.isPinValid = { [unowned self] in
            tap(isPinValid($0)) {
                if ($0) { dismiss(animated: true) }
            }
        }
    }
}


