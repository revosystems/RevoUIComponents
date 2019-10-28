import UIKit

enum ContentStatus{
    case loading, empty, content, error
        
    var statusView : UIView? {
        switch self{
            case .loading:  return loadingView()
            case .empty:    return emptyView()
            case .error:    return errorView()
            default:        return nil
        }
    }
    
    func titleLabel(_ text:String) -> UILabel {
        let label           = UILabel()
        label.font          = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor     = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    func descriptionLabel(_ text:String) -> UILabel {
        let label           = UILabel()
        label.font          = UIFont.preferredFont(forTextStyle: .caption1)
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
        stack.spacing       = 10
        return stack
    }
        
    func loadingView() -> UIView{
        tap(UIView()) {
            let loading = UIActivityIndicatorView()
            loading.startAnimating()
                        
            let vStack           = VStack()
            vStack.addArrangedSubview(loading)
            vStack.addArrangedSubview(descriptionLabel("Loading..."))
            $0.addSubview(vStack)
            vStack.centerToSuperview()
        }
    }
    
    func emptyView() -> UIView {
        tap(UIView()) {
            let button          = UIButton()
            button.setTitle("Do something", for: .normal)
            
            let vStack           = VStack()
            vStack.addArrangedSubview(descriptionLabel("No records"))
            vStack.addArrangedSubview(button)
            $0.addSubview(vStack)
            vStack.centerToSuperview()
        }
    }
    
    func errorView() -> UIView{
        tap(UIView()) {
            let label           = descriptionLabel("Error")
            label.text          = "Error"
            
            let button          = UIButton()
            button.setTitle("Do something", for: .normal)
            
            let vStack           = VStack()
            
            vStack.addArrangedSubview(label)
            vStack.addArrangedSubview(button)
            $0.addSubview(vStack)
            vStack.centerToSuperview()
        }
    }
}

open class ContentStatusView: UIView {
    var state:ContentStatus = .content {
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
        
    var state:ContentStatus = .content {
        didSet {
            reloadData()
        }
    }
    
    public override func reloadData() {
        super.reloadData()
        self.backgroundView     = state.statusView
        self.backgroundView?.backgroundColor = backgroundColor
        self.backgroundView?.backgroundColor = .red
        self.tableFooterView    = UIView()
    }
    
}
