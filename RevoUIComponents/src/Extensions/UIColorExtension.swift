import UIKit

extension UIColor {
    static var tintColor: UIColor {
        get { UIApplication.shared.keyWindow?.rootViewController?.view.tintColor ?? .systemBlue }
    }
}
