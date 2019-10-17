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
        }else {
            reset()
        }
    }
    
    // MARK: Private methods
    
    func setup(){
        originalTitle = title(for: .normal)
        originalImage = image(for: .normal)
        progress = CircularProgress(frame: bounds)
        progress.tintColor = self.tintColor
        addSubview(progress)
    }
    
    func resetAfterDelay(){
        progress.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            DispatchQueue.main.async{
                self.reset()
            }
        }
    }
    
    func reset(){
        progress.stop()
        isEnabled = true
        setTitle(originalTitle, for: .normal)
        setImage(originalImage, for: .normal)
        setTitle(originalTitle, for: .disabled)
        setImage(originalImage, for: .disabled)
        removeCompletionImage()
    }
    
    func addCompletionImage(_ imageName:String, _ color:UIColor){
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
