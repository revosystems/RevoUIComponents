import UIKit

public enum AlertResult: Int {
    case ok      = 0
    case cancel  = -1
    case destroy = -2
}

public class Alert : UIAlertController {
    var then:((_ result:Int)->Void)?
    
    public convenience init(alert:String, message:String = "", okText:String = "Ok", cancelText:String? = nil, destroyText:String? = nil){
                
        self.init(title: alert, message: message, preferredStyle: .alert)
        
        addAction(UIAlertAction(title: okText,      style: .default) { action in self.then?(AlertResult.ok.rawValue) })
        
        if cancelText != nil {
            addAction(UIAlertAction(title: cancelText,  style: .cancel) { action in self.then?(AlertResult.cancel.rawValue) })
        }
        
        if destroyText != nil {
            addAction(UIAlertAction(title: destroyText, style: .destructive) { action in self.then?(AlertResult.destroy.rawValue) })
        }
    }
    
    public convenience init(action:String, message:String = "", actions:[String], cancelText:String? = nil, destroyText:String? = nil){
        
        self.init(title: action, message: message, preferredStyle: .actionSheet)
                
        actions.eachWithIndex { title, index in
            addAction(UIAlertAction(title: title, style: .default) { action in self.then?(index) })
        }
        
        if cancelText != nil {
            addAction(UIAlertAction(title: cancelText,  style: .cancel) { action in self.then?(AlertResult.cancel.rawValue) })
        }
        
        if destroyText != nil {
            addAction(UIAlertAction(title: destroyText, style: .destructive) { action in self.then?(AlertResult.destroy.rawValue) })
        }
    }

    public func show(_ parentVc:UIViewController, sender:UIView? = nil, animated:Bool = true, then:@escaping(_ result:Int)->Void) {
        if let fakeResult = getNextFakeResult(){
            return then(fakeResult)
        }
        self.then = then
        if preferredStyle == .actionSheet, let sender = sender {
            popoverPresentationController?.sourceRect = sender.bounds
            popoverPresentationController?.sourceView = sender
            popoverPresentationController?.permittedArrowDirections = .any
        }
        parentVc.present(self, animated: animated)
    }
    
    
    // ======================================================
    // MARK: Fake
    // ======================================================
    static var fakeResults : [Int]?
    
    static func enableFake(_ results:[Int]) {
        Self.fakeResults = results
    }
    
    static func disableFake() {
        Self.fakeResults = []
    }
    
    private func getNextFakeResult() -> Int?{
        guard let results = Self.fakeResults, results.count > 0 else { return nil }
        let result = results.first ?? 0
        Self.fakeResults!.removeFirst()
        return result
    }
}
