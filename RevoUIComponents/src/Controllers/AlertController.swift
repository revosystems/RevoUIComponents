import UIKit
import RevoFoundation

public enum AlertResult {
    case ok
    case cancel
    case destroy
    case action(index:Int)
    case text(inputText:String)
}

public class Alert : UIAlertController {
    var then:((_ result:AlertResult)->Void)?
    
    public convenience init(_ alert:String, message:String = "", okText:String? = "Ok", cancelText:String? = nil, destroyText:String? = nil){
                
        self.init(title: alert, message: message, preferredStyle: .alert)
        
        if okText != nil {
            addAction(.init(title: okText, style: .default) { action in self.then?(AlertResult.ok) })
        }
        
        if cancelText != nil {
            addAction(.init(title: cancelText,  style: .cancel) { action in self.then?(AlertResult.cancel) })
        }
        
        if destroyText != nil {
            addAction(.init(title: destroyText, style: .destructive) { action in self.then?(AlertResult.destroy) })
        }
    }
    
    public convenience init(action:String, message:String = "", actions:[String] = [], cancelText:String? = nil, destroyText:String? = nil){
        
        self.init(title: action, message: message, preferredStyle: .actionSheet)
                
        actions.eachWithIndex { title, index in
            addAction(.init(title: title, style: .default) { action in self.then?(.action(index: index)) })
        }
        
        if cancelText != nil {
            addAction(.init(title: cancelText,  style: .cancel) { action in self.then?(AlertResult.cancel) })
        }
        
        if destroyText != nil {
            addAction(.init(title: destroyText, style: .destructive) { action in self.then?(AlertResult.destroy) })
        }
    }
    
    public func addAction(_ title:String, value:Int){
        addAction(.init(title: title, style: .default) {
            action in self.then?(.action(index: value))
        })
    }

    public func show(_ parentVc:UIViewController? = nil, sender:UIView? = nil, animated:Bool = true, then:@escaping(_ result:AlertResult)->Void) {
        if let fakeResult = getNextFakeResult(){
            return then(fakeResult)
        }
        self.then = then
        if preferredStyle == .actionSheet, let sender = sender {
            popoverPresentationController?.sourceRect = sender.bounds
            popoverPresentationController?.sourceView = sender
            popoverPresentationController?.permittedArrowDirections = .any
        }
        (parentVc ?? topVc())?.present(self, animated: animated)
    }
    
    public func show(_ parentVc:UIViewController? = nil, sender:UIView? = nil, animated:Bool = true) async -> AlertResult {
        await withCheckedContinuation { continuation in
            show(parentVc, sender:sender, animated:animated) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    public func showWithTextInput(_ parentVc:UIViewController? = nil, sender:UIView? = nil, animated:Bool = true, placeholder:String = "", then:@escaping(_ result:AlertResult)->Void) {
        self.addTextField() { (textField) in
            textField.placeholder = placeholder
        }
        show(parentVc, sender: sender, animated: animated, then: then)
    }
    
    public func showWithTextInput(_ parentVc:UIViewController? = nil, sender:UIView? = nil, animated:Bool = true, placeholder:String = "") async -> AlertResult {
        await withCheckedContinuation { continuation in
            showWithTextInput(parentVc, sender:sender, animated:animated, placeholder:placeholder) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    // ======================================================
    // MARK: - Fake
    // ======================================================
    static var fakeResults : [AlertResult]?
    
    //[WARNING] This cannot be called within the tests, a wraper needs to be addeed in the main target so the static variable is the same
    public static func fake(_ results:[AlertResult]) {
        Self.fakeResults = results
    }
    
    public static func disableFake() {
        Self.fakeResults = nil
    }
    
    private func getNextFakeResult() -> AlertResult?{
        Self.fakeResults?.pop()
    }
}
