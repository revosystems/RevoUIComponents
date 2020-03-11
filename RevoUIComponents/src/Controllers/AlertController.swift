import UIKit

public enum AlertResult: Int {
    case ok      = 0
    case cancel  = -1
    case destroy = -2
}

public class Alert : UIAlertController {
    
    var thenAlert:((_ result:AlertResult)->Void)!
    var thenAction:((_ result:Int)->Void)!
    
    public convenience init(alert:String, _ message:String = "", okText:String? = nil, cancelText:String? = nil, destroyText:String? = nil, then:@escaping(_ result:AlertResult) -> Void){
                
        self.init(title: alert, message: message, preferredStyle: .alert)
        
        thenAlert = then
        
        if okText != nil {
            addAction(UIAlertAction(title: okText,      style: .default) { action in self.thenAlert(.ok) })
        }
        
        if cancelText != nil {
            addAction(UIAlertAction(title: cancelText,  style: .cancel) { action in self.thenAlert(.cancel) })
        }
        
        if destroyText != nil {
            addAction(UIAlertAction(title: destroyText, style: .destructive) { action in self.thenAlert(.destroy) })
        }
    }
    
    public convenience init(action:String, _ message:String = "", actions:[String], cancelText:String? = nil, destroyText:String? = nil, then:@escaping(_ result:Int) -> Void){
        
        self.init(title: action, message: message, preferredStyle: .actionSheet)
        
        thenAction = then
        
        actions.eachWithIndex { title, index in
            addAction(UIAlertAction(title: title, style: .default) { action in self.thenAction(index) })
        }
        
        if cancelText != nil {
            addAction(UIAlertAction(title: cancelText,  style: .cancel) { action in self.thenAction(AlertResult.cancel.rawValue) })
        }
        
        if destroyText != nil {
            addAction(UIAlertAction(title: destroyText, style: .destructive) { action in self.thenAction(AlertResult.destroy.rawValue) })
        }
    }
    
    public func show(_ parentVc:UIViewController, animated:Bool = true){
        if let result = Self.fakeResults.pop() {
            thenAlert?(AlertResult(rawValue: result)!)
            thenAction?(result)
            return
        }
        parentVc.present(self, animated: animated)
    }
    
    
    // ======================================================
    // MARK: Fake
    // ======================================================
    static var fakeResults : [Int] = []
    
    func enableFake(_ results:[Int]) {
        Self.fakeResults = results
    }
    
    func disableFake() {
        Self.fakeResults = []
    }
}
