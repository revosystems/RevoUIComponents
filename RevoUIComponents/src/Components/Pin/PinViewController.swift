import UIKit
import RevoFoundation

public class PinViewController : UIViewController, PinViewAppearanceDelegate {
    
    var canCancel = false
    
    private var stack:UIStackView!
    private var innerStackView:UIStackView!
    
    public let pinView = PinView()
    
    let pinHeight = 400
    
    public var isPinValid: ((_ pin:String)->Bool)! {
        didSet { pinValidProxy() }
    }
    
    override public func viewDidLoad() {
        
    }
    
    @discardableResult
    public func setup(_ bg:UIColor = .gray, tint:UIColor = .white) -> Self {
        view.backgroundColor = bg
        view.tintColor = tint
        
        createMainStackView()
        addSpacing((UIScreen.main.bounds.height - CGFloat(pinHeight + 120)) / 2 )
        stack.addArrangedSubview(innerStackView)
        addTitle()
        
        addPinView()
        //addSpacing(100)
        addActionButtons()
        stack.addArrangedSubview(UIView())
        //addSpacing(200)
        return self
    }
    
    private func addSpacing(_ size:CGFloat){
        stack.addArrangedSubview(UIView().height(constant: size))
    }
    
    private func createMainStackView(){
        stack              = UIStackView(frame: view.bounds)
        stack.axis         = .vertical
        stack.alignment    = .center
        view.addSubview(stack)
        stack.equalSizeAs(view)
        
        innerStackView              = UIStackView(frame: CGRect(x: 0, y: 0, width: 300, height: pinHeight))
        innerStackView.axis         = .vertical
        innerStackView.alignment    = .center
    }
    
    private func addTitle(){
        let titleLabel     = UILabel().height(constant: 40)
        titleLabel.text    = title ?? "PIN"
        titleLabel.textColor = view.tintColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        innerStackView.addArrangedSubview(titleLabel)
    }
    
    private func addPinView(){
        pinView.appearanceDelegate = self
        innerStackView.addArrangedSubview(pinView)
        pinView.setup()
    }
    
    public func pinView(configureButton:UIButton, size:CGFloat) {
        configureButton.layer.borderWidth   = 1  //TODO: Use .border() when RevoFoundation updated
        configureButton.layer.borderColor   = view.tintColor.cgColor
        configureButton.round(size/2) //TODO: Change for .circle() when RevoFoundation updated
        configureButton.titleLabel?.font = .systemFont(ofSize: 25)
        configureButton.setTitleColor(view.tintColor, for: .normal)
    }
    
    
    private func addActionButtons(){
        let row         = UIStackView()
        row.axis        = .horizontal
        row.spacing     = 200

        let cancelButton = UIButton()
        cancelButton.setTitle(canCancel ? "Cancel" : "", for: .normal)
        cancelButton.setTitleColor(view.tintColor, for:.normal)
        if (canCancel) {
            cancelButton.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
            cancelButton.setTitleColor(.lightGray, for:.highlighted)
        }
        row.addArrangedSubview(cancelButton)

        let deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(onDeletePressed), for: .touchUpInside)
        deleteButton.setTitleColor(view.tintColor, for:.normal)
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


