import UIKit

/**
 * Copied from:
 * https://github.com/gontovnik/DGActivityIndicatorView
 * https://github.com/gontovnik/DGActivityIndicatorView/blob/master/DGActivityIndicatorView/Animations/DGActivityIndicatorAnimation.m
 */
public class LoadingAnimation : UIView {
    
    var animationLayer: CALayer!
    var animating   = false
    var tint        = UIColor.black
    var size        = CGSize(width: 40.0, height: 40.0)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @discardableResult
    public func set(size:CGSize = CGSize(width: 40.0, height: 40.0), color:UIColor = UIColor.black) -> LoadingAnimation{
        self.size = size
        self.tint = color
        layoutSubviews()
        return self
    }
    
    func setup(){
        backgroundColor = UIColor.red
        isUserInteractionEnabled = false
        isHidden = true
        animationLayer = CALayer()
        
        layer.addSublayer(animationLayer)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
    }
        
    public func startAnimating(){
        if animationLayer.sublayers == nil {
            setupAnimation()
        }
        isHidden             = false
        animationLayer.speed = 1.0
        animating            = true
    }

    public func stopAnimating(){
        animationLayer.speed = 0.0
        animating            = false
        isHidden             = true
    }
    
    func setupAnimation(){
        animationLayer.sublayers = nil
        setupAnimationInLayer()
        animationLayer.speed = 0.0
    }
    
    func setupAnimationInLayer() {
        let circlePadding:CGFloat = 5.0
        let circleSize            = (size.width - CGFloat(2.0) * circlePadding) / 3;
        let x                     = (layer.bounds.size.width - size.width) / 2;
        let y                     = (layer.bounds.size.height - circleSize) / 2;
        let duration              = 0.75
        let timeBegins            = [0.12, 0.24, 0.36]
        let timingFunction        = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        let animation             = createKeyframeAnimation(keyPath: "transform")
                
        animation.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 0.3)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
        ]
        
        animation.keyTimes          = [0.0, 0.3, 1.0];
        animation.timingFunctions   = [timingFunction, timingFunction]
        animation.duration          = duration;
        animation.repeatCount       = .infinity;
        
        for i in 0...2 {
            let circle              = CALayer()
            circle.frame            = CGRect(x: x + CGFloat(i) * circleSize + CGFloat(i) * circlePadding, y: y, width: circleSize, height: circleSize)
            circle.backgroundColor  = tint.cgColor
            circle.cornerRadius     = circle.bounds.size.width / 2;
            animation.beginTime     = timeBegins[i]
            circle.add(animation, forKey:"animation")
            animationLayer.addSublayer(circle)
        }
    }
    
    func createKeyframeAnimation(keyPath:String) -> CAKeyframeAnimation{
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    override public func layoutSubviews(){
        super.layoutSubviews()
        
        animationLayer.frame = self.bounds
        let tmpAnimating = animating

        if tmpAnimating { stopAnimating() }
        setupAnimation()
        if tmpAnimating { startAnimating() }
    }
}
