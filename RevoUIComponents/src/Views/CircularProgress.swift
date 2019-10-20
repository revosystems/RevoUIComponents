import Foundation
import UIKit

public class CircularProgress : UIView {
    
    var startAngle:CGFloat   = 0
    var endAngle:CGFloat     = 0
    var percent:CGFloat      = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    let ANIMATION_KEY = "transform.rotation.z"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        self.backgroundColor = UIColor.clear
        //self.tintColor       = UIColor.white
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle                  = CGFloat(Double.pi * 1.5);
        endAngle                    = startAngle + CGFloat((Double.pi * 2));
        self.isUserInteractionEnabled = false;
    }
    
    override public func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        bezierPath.addArc(withCenter: CGPoint(x: rect.size.width/2, y: rect.size.height/2), radius: rect.size.height/2 - 5, startAngle: startAngle, endAngle: (endAngle - startAngle) * (percent / 100.0)
        + startAngle, clockwise: true)
    
        
        // Set the display for the path, and stroke it
        bezierPath.lineWidth = 2;
        tintColor.setStroke()
        bezierPath.stroke()
    }
    

    public func start(){
        percent = 45;
        
        if (layer.animation(forKey: ANIMATION_KEY) != nil) {
            return
        }
        
        let animation           = CABasicAnimation(keyPath: ANIMATION_KEY)
        animation.toValue       = Double.pi * 2
        animation.duration      = 0.5
        animation.isCumulative  = true
        animation.repeatCount   = 1000
        layer.add(animation, forKey:ANIMATION_KEY)
    }
    
    func stop(){
        percent = 0
        layer.removeAnimation(forKey: ANIMATION_KEY)
    }
    
}
