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
    
    public func downloaded(from link: String, shouldCache:Bool = true, contentMode mode: UIView.ContentMode = .scaleAspectFit, then:(()->Void)?) {
        
        if shouldCache, let cached = loadFromCache(link: link) {
            self.image = cached
            then?()
            return
        }
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode) { [weak self] in
            if shouldCache {
                self?.saveToCache(link: link, imageData: $0)
            }
            then?()
        }
    }
    

    public func loadFromCache(link: String) -> UIImage? {
        let imagePath = link.sha256 + ".png"
        let paths     = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath  = (paths.first! as NSString).appendingPathComponent(imagePath)
        return UIImage(contentsOfFile: filePath)
    }
    
    public func saveToCache(link:String, imageData:Data){
        let imagePath = link.sha256 + ".png"
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        do {
            try UIImage(data: imageData)?.pngData()?.write(to: directory.appendingPathComponent(imagePath)!)
        }catch{
            print(error)
        }
    }

}
