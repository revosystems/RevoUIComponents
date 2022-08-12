import UIKit
import RevoFoundation
import CryptoKit


extension UIImageView {
 
    func gravatar(email: String, size:Int? = nil, defaultImage:String? = nil){
        
        var params:[String] = []
        
        if let size = size {
            params.append("s=\(size)")
        }
        
        if let defaultImage = defaultImage {
            params.append("d=\(defaultImage)")
        }
                
        let hash = email.trim().lowercased().md5()
        let url = "https://www.gravatar.com/avatar/\(hash)?\(params.implode("&"))"
        
        downloaded(from: url)
    }
}


extension String {
    func md5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}
