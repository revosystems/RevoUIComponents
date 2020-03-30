import UIKit
import RevoFoundation

class ViewController: UIViewController, ContentStatusActionDelegate {

    @IBOutlet weak var asyncButton: AsyncButton!
    @IBOutlet weak var stateTableView: ContentStatusTableView!
    @IBOutlet weak var stateView: ContentStatusView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
    }
        
    @IBAction func onAsyncButtonPressed(_ sender: Any) {
        asyncButton.animateProgress()
        loadImage()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.asyncButton.animateFailed()
            //self.asyncButton.animateSuccess()
            self.stateTableView.state = .empty(image:nil, title:"Empty", description:"Add Something", actionTitle:"Do Something", delegate:self)
            self.stateView.state      = .content
        }
        
        stateTableView.state = .loading(text: "Loading...")
        stateView.state      = .loading(text: "Loading2...")
    }
    
    func loadImage(){
        if Int.random(in: 0...2) == 2 {
            imageView.downloaded(from: "https://revo.works/images/logo.png", shouldCache:false)
        } else {
            imageView.downloaded(from: "https://image.shutterstock.com/image-photo/beautiful-water-drop-on-dandelion-260nw-789676552.jpg", shouldCache:false)
            
        }
    }
    
    func onContentStatusAction(_ sender:UIButton){
        onAsyncButtonPressed(sender)
    }
    
    @IBAction func onAlertPressed(_ sender: Any) {
        Alert(alert: "hola", message: "que tal", okText: "Ok", cancelText: "No").show(self) { result in
            print(result)
        }
    }
    
    @IBAction func onShowPinPressed(_ sender: Any) {
        let pin = PinViewController()
        pin.isPinValid = { $0 == "0000" }
        self.present(pin, animated: true, completion: nil)
    }
    
    func setupLoading(){
        let animation = LoadingAnimation(frame: loading.bounds)
        loading.addSubview(animation.set(color:UIColor.white))
        animation.startAnimating()
    }
}

