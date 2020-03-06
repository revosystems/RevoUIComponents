import UIKit
import RevoFoundation

extension UIImageView {
    public func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, then:((_ data:Data)->Void)?) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            then?(data)
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    public func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        if let cached = loadFromCache(link: link) {
            return self.image = cached
        }
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode) { [weak self] in
            self?.saveToCache(link: link, imageData: $0)
        }
    }
    

    public func loadFromCache(link: String) -> UIImage? {
        let imagePath = link /*link.sha256 + ".png"*/
        let paths     = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath  = (paths.first! as NSString).appendingPathComponent(imagePath)
        return UIImage(contentsOfFile: filePath)
    }
    
    public func saveToCache(link:String, imageData:Data){
        let paths     = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath  = (paths.first! as NSString).appendingPathComponent(link)
        guard let url = URL(string: filePath) else { return }
        try? UIImage(data: imageData)?.pngData()?.write(to: url)
    }

}
