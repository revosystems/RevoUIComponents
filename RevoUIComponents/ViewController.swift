import UIKit
import RevoFoundation

class ViewController: UIViewController, ContentStatusActionDelegate {

    @IBOutlet weak var asyncButton: AsyncButton!
    @IBOutlet weak var stateTableView: ContentStatusTableView!
    @IBOutlet weak var stateView: ContentStatusView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loading: UIView!
    @IBOutlet weak var gravatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        gravatarView.gravatar(email: "jordi+a@gloobus.net", defaultImage: "https://thesocietypages.org/socimages/files/2009/05/nopic_192.gif")
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
    
    @IBAction func onShowToast(_ sender: Any) {
        SmallToast.show("Order 67 Paid!", bgColor: .black)
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
        Alert("hola", message: "que tal", okText: "Ok", cancelText:"Cancel", destroyText: "NO").show() { result in
            print(result)
        }
        Task {
            let a = await Alert("buu").show()
            print(a)
        }
    }
    
    @IBAction func onShowPinPressed(_ sender: Any) {
        let pin = PinViewController().setup(.gray, tint: .white)
        pin.modalPresentationStyle = .fullScreen
        pin.isPinValid = { $0 == "0000" }
        present(pin, animated: true, completion: nil)
    }
    
    func setupLoading(){
        let animation = LoadingAnimation(frame: loading.bounds)
        loading.addSubview(animation.set(color:UIColor.white))
        animation.startAnimating()
    }
}

