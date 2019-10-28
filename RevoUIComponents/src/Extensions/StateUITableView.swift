import UIKit

open class StateUITableView: UITableView {
    
    enum State{
        case loading, empty, content, error
    }
    
    var state:State = .empty {
        didSet {
            reloadData()
        }
    }
    
    public override func reloadData() {
        super.reloadData()
        switch(state){
            case .loading: do{
                self.backgroundView = self.loadingView()
                self.tableFooterView = UIView()
            }
            case .empty: do {
                self.backgroundView = self.emptyView()
                self.tableFooterView = UIView()
            }
            case .error: do{
                self.backgroundView = self.errorView()
                self.tableFooterView = UIView()
            }
            default: do {
            
            }
        }
        self.backgroundView?.backgroundColor = .red
    }
    
    func loadingView() -> UIView{
        tap(UIView()) {
            let label           = UILabel()
            label.text          = "Loading..."
            label.textAlignment = .center
            $0.addSubview(label)
            label.bindFrameToSuperviewBounds()
        }
    }
    
    func emptyView() -> UIView {
        tap(UIView()) {
            let label           = UILabel()
            label.text          = "No records"
            label.textAlignment = .center
            $0.addSubview(label)
            label.bindFrameToSuperviewBounds()
        }
    }
    
    func errorView() -> UIView{
        tap(UIView()) {
            let label           = UILabel()
            label.text          = "Error"
            label.textAlignment = .center
            $0.addSubview(label)
            label.bindFrameToSuperviewBounds()
        }
    }
    
}
