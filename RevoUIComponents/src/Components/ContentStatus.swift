import UIKit

@objc public protocol ContentStatusActionDelegate{
    @objc func onContentStatusAction(_ sender:UIButton)
}

public enum ContentStatus{
    
    case loading(text:String = "Loading")
    case empty(image:String?, title:String?, description:String?, actionTitle:String?, delegate:ContentStatusActionDelegate?)
    case content
    case error(image:String?, title:String?, description:String?, actionTitle:String?, delegate:ContentStatusActionDelegate?)
            
    var statusView : UIView? {
        switch self{
        case let .loading(text):   return loadingView(text)
        case let .empty(image, title, description, actionTitle, delegate):    return emptyView(image:image, title:title, description:description, actionTitle:actionTitle, delegate:delegate)
        case let .error(image, title, description, actionTitle, delegate):    return errorView(image:image, title:title, description:description, actionTitle:actionTitle, delegate:delegate)
        default:        return nil
        }
    }
    
    func titleLabel(_ text:String) -> UILabel {
        let label           = UILabel()
        label.font          = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor     = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    func descriptionLabel(_ text:String) -> UILabel {
        let label           = UILabel()
        label.font          = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor     = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
      
    func VStack() -> UIStackView {
        let stack           = UIStackView()
        stack.axis          = .vertical
        stack.alignment     = .center
        stack.distribution  = .fillProportionally
        stack.spacing       = 16
        return stack
    }
        
    func loadingView(_ text:String) -> UIView{
        tap(UIView()) {
            let loading = UIActivityIndicatorView()
            loading.startAnimating()
                        
            let vStack           = VStack()
            vStack.addArrangedSubview(loading)
            vStack.addArrangedSubview(descriptionLabel(text))
            $0.addSubview(vStack)
            vStack.centerToSuperview()
        }
    }
    
    func richView(image:String?, title:String?, description:String?, actionTitle:String?, delegate:ContentStatusActionDelegate?) -> UIView {
        tap(UIView()) {
            let vStack = VStack()
            $0.addSubview(vStack)
            vStack.centerToSuperview()
            
            if (image != nil){
                vStack.addArrangedSubview(
                    UIImageView(image: UIImage(named:image!))
                )
            }
                        
            if (title != nil) {
                vStack.addArrangedSubview(titleLabel(title!))
            }
            
            if (description != nil) {
                vStack.addArrangedSubview(descriptionLabel(description!))
            }
            
            if (actionTitle != nil) {
                let button = UIButton()
                button.setTitle(actionTitle!, for: .normal)
                button.setTitleColor(.tintColor, for: .normal)
                vStack.addArrangedSubview(button)
                button.addTarget(delegate, action: #selector(ContentStatusActionDelegate.onContentStatusAction), for: .touchUpInside)
            }
        }
    }

    
    func emptyView(image:String?, title:String?, description:String?, actionTitle:String?, delegate:ContentStatusActionDelegate?) -> UIView {
        richView(image:image, title:title, description:description, actionTitle: actionTitle, delegate:delegate)
    }
    
    func errorView(image:String?, title:String?, description:String?, actionTitle:String?, delegate:ContentStatusActionDelegate?) -> UIView {
        richView(image:image, title:title, description:description, actionTitle: actionTitle, delegate:delegate)
    }
}

open class ContentStatusView: UIView {
    public var state:ContentStatus = .content {
        didSet {
            updateContentStatusView()
        }
    }
    
    var statusView:UIView?
    
    func updateContentStatusView(){
        if (statusView != nil) { statusView!.removeFromSuperview() }
        statusView = state.statusView
        if(statusView == nil) { return }
        statusView?.backgroundColor = backgroundColor
        addSubview(statusView!)
        statusView?.bindFrameToSuperviewBounds()
    }
}

open class ContentStatusTableView: UITableView {
        
    public var state:ContentStatus = .content {
        didSet {
            reloadData()
        }
    }
    
    public override func reloadData() {
        super.reloadData()
        self.backgroundView     = state.statusView
        self.backgroundView?.backgroundColor = backgroundColor
        self.tableFooterView    = UIView()
    }
    
}
