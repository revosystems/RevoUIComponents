import UIKit
import RevoFoundation

extension UIImageView {
    
    public func downloaded(from link: String, shouldCache:Bool = true, contentMode mode: UIView.ContentMode = .scaleAspectFit, then:(()->Void)? = nil) {
        
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
    
    public func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, then:((_ data:Data)->Void)?) {
        contentMode = mode

        let loading = addLoading()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType        = response?.mimeType, mimeType.hasPrefix("image"),
                let data            = data, error == nil,
                let image           = UIImage(data: data)
                else {
                    self?.removeLoading(loading)
                    return
                }
            then?(data)
            self?.onImageDownloaded(image, loading:loading)
        }.resume()
    }
    
    
    //MARK:- Cache
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
    
    //MARK:- UI Helpers
    private func onImageDownloaded(_ image:UIImage, loading:UIActivityIndicatorView){
        DispatchQueue.main.async() {
            self.removeLoading(loading)
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.image = image
            })
        }
    }
    
    private func addLoading() -> UIActivityIndicatorView{
        let loading = UIActivityIndicatorView(frame: bounds)
        addSubview(loading)
        loading.start()
        return loading
    }
    
    private func removeLoading(_ loading:UIActivityIndicatorView){
        DispatchQueue.main.async() {
            UIView.animate(withDuration: 0.3, animations: {
                loading.alpha = 0
            }, completion: { completed in
                loading.stop()
                loading.removeFromSuperview()
            })
        }
    }

    

}
