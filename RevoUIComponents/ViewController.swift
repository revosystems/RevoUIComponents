import UIKit
import RevoFoundation

class ViewController: UIViewController {

    @IBOutlet weak var asyncButton: AsyncButton!
    @IBOutlet weak var stateTableView: StateUITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onAsyncButtonPressed(_ sender: Any) {
        asyncButton.animateProgress()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.asyncButton.animateFailed()
            //self.asyncButton.animateSuccess()
            self.stateTableView.state = .empty
        }
        
        stateTableView.state = .loading
    }
    
    @IBAction func onShowPinPressed(_ sender: Any) {
        let pin = PinViewController()
        pin.isPinValid = { $0 == "0000" }
        self.present(pin, animated: true, completion: nil)
    }
}

