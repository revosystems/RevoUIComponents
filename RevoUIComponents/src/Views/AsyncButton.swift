import UIKit
import RevoFoundation

public class AsyncButton : UIButton {
        
    /**
     * Set this to false if you want to show the original button at the moment failed is called
     */
    var showWarningIconWhenFailed = true
    
    var progress:CircularProgress!
    private var originalTitle:String?
    private var originalImage:UIImage?
    private var completionImage: UIImageView?
    
    // MARK: Public methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    public func animateProgress(){
        isEnabled = false
        removeCompletionImage()
        setTitle("",  for: .normal)
        setImage(nil, for: .normal)
        setTitle("",  for: .disabled)
        setImage(nil, for: .disabled)
        progress.start()
    }
    
    public func animateSuccess(){
        addCompletionImage("checkmark", UIColor.green)
        resetAfterDelay()
    }
    
    public func animateFailed(){
        shake()
        if (showWarningIconWhenFailed) {
            addCompletionImage("exclamationmark.triangle", UIColor.red)
            resetAfterDelay()
        } else {
            reset()
        }
    }
    
    // MARK: Private methods
    
    func setup(){
        originalTitle = title(for: .normal)
        originalImage = image(for: .normal)
        
        progress      = CircularProgress(frame: progressFrame )
        progress.tintColor = self.tintColor

        addSubview(progress)
        progress.centerTo(self)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        progress.frame = progressFrame
    }
    
    var progressFrame : CGRect {
        let size      = min(30, bounds.size.height)
        return CGRect(x: bounds.size.width/2 - size/2, y: bounds.size.height/2 - size/2, width: size, height: size)
    }
    
    func resetAfterDelay(){
        progress.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            DispatchQueue.main.async{
                self?.reset()
            }
        }
    }
    
    public func reset(){
        progress.stop()
        isEnabled = true
        setTitle(originalTitle, for: .normal)
        setImage(originalImage, for: .normal)
        setTitle(originalTitle, for: .disabled)
        setImage(originalImage, for: .disabled)
        removeCompletionImage()
    }
    
    func addCompletionImage(_ imageName:String, _ color:UIColor){
        guard #available(iOS 13, *) else {
            return
        }
        completionImage                = UIImageView(image: UIImage(systemName: imageName))
        completionImage!.contentMode   = .scaleAspectFit
        completionImage!.frame         = self.bounds.insetBy(dx: 3, dy: 3)
        completionImage?.tintColor     = color
        self.addSubview(completionImage!)
    }
    
    func removeCompletionImage() {
        completionImage?.removeFromSuperview()
    }
    
    
}
