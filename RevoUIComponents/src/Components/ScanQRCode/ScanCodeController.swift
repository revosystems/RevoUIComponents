import UIKit
import AVFoundation


public protocol ScanCodeControllerDelegate : AnyObject {
    func scanController(onScanned code:String)
}

public class ScanCodeController : UIViewController, ScanQRCodeViewDelegate {
    
    @IBOutlet weak private var scanView:ScanQRCodeView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak public var infoLabel: UILabel!
    public var delegate:ScanCodeControllerDelegate?

    
    public override func viewDidLoad() {
        titleLabel.text = self.title
        infoLabel.isHidden = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanView.setupCaptureSession(delegate:self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanView.start()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView.stop()
    }
    
    func scanQrCode(found code:String){
        delegate?.scanController(onScanned: code)
    }
}
