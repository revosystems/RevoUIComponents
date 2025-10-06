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
    
    public convenience init(_ alert:String, message:String? = nil, okText:String? = "Ok", cancelText:String? = nil, destroyText:String? = nil) {
        self.init(alert, message: message, okText: okText, cancelText: cancelText, destroyText: destroyText, preferredStyle: .alert)
    }
    
    public convenience init(action:String, message:String? = nil, actions:[String] = [], cancelText:String? = nil, destroyText:String? = nil) {
        self.init(action, message: message, actions: actions, cancelText: cancelText, destroyText: destroyText, preferredStyle: .actionSheet)
    }
    
    public convenience init(_ title:String, message:String? = nil, actions:[String] = [], okText:String? = nil, cancelText:String? = nil, destroyText:String? = nil, preferredStyle: UIAlertController.Style) {
        
        self.init(title: title, message: message, preferredStyle: preferredStyle)
                
        actions.eachWithIndex { title, index in
            addAction(.init(title: title, style: .default) { [unowned self] action in then?(.action(index: index)) })
        }
        
        if okText != nil {
            addAction(.init(title: okText, style: .default) { [unowned self] action in then?(AlertResult.ok) })
        }
        
        if cancelText != nil {
            addAction(.init(title: cancelText,  style: .cancel) { [unowned self] action in then?(AlertResult.cancel) })
        }
        
        if destroyText != nil {
            addAction(.init(title: destroyText, style: .destructive) { [unowned self] action in then?(AlertResult.destroy) })
        }
    }
    
    public func addAction(_ title:String, value:Int){
        addAction(.init(title: title, style: .default) { [unowned self] _ in
            then?(.action(index: value))
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
        
        addTextField() { $0.placeholder = placeholder }
        
        show(parentVc, sender: sender, animated: animated) { [unowned self] result in
            if case .ok = result, let text = textFields?[0].text {
                return then(.text(inputText: text))
            }
            then(result)
        }
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
