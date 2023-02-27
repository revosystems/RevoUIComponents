import UIKit
import PencilKit

@objc public protocol PencilKitSignatureViewDelegate {
    func onBeginDrawing()
}

//https://github.com/alankarmisra/SwiftSignatureView/blob/master/Pod/Classes/SwiftSignatureView.swift
open class PencilKitSignatureView: UIView, PKCanvasViewDelegate {

    private var viewReady: Bool = false

    private lazy var canvas: PKCanvasView = PKCanvasView(frame: CGRect.zero)

    open var scale: CGFloat = 10.0
    
    @objc public var delegate:PencilKitSignatureViewDelegate?
    
    /// The gesture recognizer that the canvas uses to track touch events.
    open var drawingGestureRecognizer: UIGestureRecognizer? {
        canvas.drawingGestureRecognizer
    }

    /**
    The maximum stroke width.
    */
    open var maximumStrokeWidth: CGFloat = 4 {
        didSet { resetTool() }
    }

    open var minimumStrokeWidth: CGFloat = 1

    open var strokeColor: UIColor = .black {
        didSet { resetTool() }
    }

    open var strokeAlpha: CGFloat = 1

    /**
    The UIImage representation of the signature. Read/write.
    */
    @objc open var signature: UIImage? {
        get {
            canvas.drawing.image(from: bounds, scale: 1.0)
        }

        set {
            guard let data = newValue?.pngData(), let drawing = try? PKDrawing(data: data) else {
                return
            }
            canvas.drawing = drawing
        }
    }

    @objc open func getCroppedSignature() -> UIImage? {
        return autoreleasepool {
            let fullRender = canvas.drawing.image(from: canvas.bounds, scale: scale)
            let bounds = self.scale(
                canvas.drawing.bounds.insetBy(dx: -maximumStrokeWidth/2, dy: -maximumStrokeWidth/2),
                byFactor: fullRender.scale)
            guard let imageRef: CGImage = fullRender.cgImage?.cropping(to: bounds) else { return nil }
            return UIImage(cgImage: imageRef, scale: scale, orientation: fullRender.imageOrientation)
        }
    }

    @objc open var isEmpty: Bool { canvas.drawing.bounds.isEmpty }

    @objc open func clear(cache: Bool) {
        canvas.drawing = PKDrawing()
    }

    open func undo() {
        canvas.undoManager?.undo()
    }

    open func redo() {
        canvas.undoManager?.redo()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    override open func updateConstraintsIfNeeded() {
        super.updateConstraintsIfNeeded()
        if viewReady {
            return
        }
        viewReady = true
        addConstraint(NSLayoutConstraint(item: canvas, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: canvas, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: canvas, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: canvas, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }

    private func initialize() {
        backgroundColor = .black
        canvas.allowsFingerDrawing = true
        //canvas.drawingPolicy = .anyInput
        canvas.delegate = self
        canvas.translatesAutoresizingMaskIntoConstraints = false
        addSubview(canvas)
        resetTool()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }

    private func resetTool() {
        canvas.tool = PKInkingTool(.pen, color: strokeColor.withAlphaComponent(strokeAlpha), width: maximumStrokeWidth)
    }

    fileprivate func scale(_ rect: CGRect, byFactor factor: CGFloat) -> CGRect {
        var scaledRect = rect
        scaledRect.origin.x *= factor
        scaledRect.origin.y *= factor
        scaledRect.size.width *= factor
        scaledRect.size.height *= factor
        return scaledRect
    }
    
    public func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        delegate?.onBeginDrawing()
    }
}

  


