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
  
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint = NSLayoutConstraint(item: self,
                         attribute: attribute,
                         relatedBy: NSLayoutConstraint.Relation.equal,
                         toItem: nil,
                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                         multiplier: 1,
                         constant: value)
        self.addConstraint(constraint)
    }
}
