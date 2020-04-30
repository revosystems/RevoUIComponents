import UIKit

@objc public class Toast : NSObject{
    static var shared:Toast = Toast()

    let notificationView = UIView()
    let textView        = UILabel()
    var height:CGFloat  = 95

    var activeWindow: UIWindow? {
        //UIApplication.shared.keyWindow //<iOS 13
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first    //iOS 13
    }

    private override init() {
        notificationView.backgroundColor = UIColor.darkGray
        textView.textAlignment          = .center
        textView.textColor              = UIColor.white
        notificationView.addSubview(textView)
    }

    @objc public class func show(_ text:String, bgColor:UIColor = UIColor.white, height:CGFloat, duration:Double = 0, font:UIFont?){
        guard let activeWindow = Self.shared.activeWindow else { return }
        Self.shared.height          = height
        let notification            = Self.shared.notificationView
        if (!notification.isDescendant(of: activeWindow)) {
            activeWindow.addSubview(Self.shared.notificationView)
        }
        notification.backgroundColor = bgColor
        Self.animateIn(notification)
        Self.shared.setText(text, font:font)
        if (duration == 0) { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { Self.dismiss() }
    }

    @objc public class func dismiss(){
        Self.animateOut(Self.shared.notificationView)
    }

    class private func animateIn(_ notification:UIView){
        notification.frame          = CGRect(x:0, y:-Self.shared.height, width:UIScreen.main.bounds.size.width, height:Self.shared.height)
        notification.alpha          = 0
        UIView.animate(withDuration: 0.2) {
            notification.frame  = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:Self.shared.height)
            notification.alpha = 1
        }
    }

    class private func animateOut(_ notification:UIView){
        UIView.animate(withDuration: 0.2, animations: {
            notification.frame  = CGRect(x:0, y:-Self.shared.height, width:UIScreen.main.bounds.size.width, height:Self.shared.height)
            notification.alpha = 0
        }, completion: { completed in
            notification.removeFromSuperview()
        })
    }

    private func setText(_ text:String, font:UIFont? = nil){
        textView.text = text
        if let font = font { textView.font = font }
        textView.frame = notificationView.bounds
    }

}
