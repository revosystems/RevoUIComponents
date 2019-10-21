import UIKit

extension UIView {
    
    convenience init(widthConstraint:CGFloat, heightConstraint:CGFloat){
        self.init()
        self.width(constant:widthConstraint).height(constant:heightConstraint)
    }
    
    @discardableResult public func height(constant: CGFloat) -> Self {
        setConstraint(value: constant, attribute: .height)
        return self
    }
  
    @discardableResult public func width(constant: CGFloat) -> Self {
        setConstraint(value: constant, attribute: .width)
        return self
    }
  
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    @discardableResult public func equalSizeAs(_ view:UIView) -> UIView{
        self.translatesAutoresizingMaskIntoConstraints = false
        let horitzontal = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0.0)
        let vertical    = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0.0)
        let width       = NSLayoutConstraint(item: self, attribute: .width,   relatedBy: .equal, toItem: view, attribute: .width,   multiplier: 1, constant: 0.0)
        let height      = NSLayoutConstraint(item: self, attribute: .height,  relatedBy: .equal, toItem: view, attribute: .height,  multiplier: 1, constant: 0.0)
        NSLayoutConstraint.activate([horitzontal, vertical, width, height])
        return self
    }
  
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint = NSLayoutConstraint(item: self,
                         attribute: attribute,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         multiplier: 1,
                         constant: value)
        self.addConstraint(constraint)
    }
}
