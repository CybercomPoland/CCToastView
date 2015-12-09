//
//  CCToastView.swift
//  SwiftToastView
//
//  Created by Adrian Ziemecki on 09/03/15.
//  Copyright (c) 2015 Cybercom Poland.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

/// The toast UIView that can be configured and shown in a selected view.
class CCToastView: UIView {
    
    /// Possible vertical aligment methods of the toast.
    enum ToastViewVerticalAlignment: Int {
        case Top, Center, Bottom
    }
    
    ///  Possible horizontal aligment methods of the toast.
    enum ToastViewHorizontalAlignment: Int {
        case Left, Center, Right
    }
    
    /// Types of available (predefined) toasts.
    ///
    /// - Blank: creates an empty toastContentView - the standard label and imageView are not created.
    /// Use this if you want a custom toast. Add new elements to toastContentView.
    /// - Standard: basic toast, creates the toastContentView along with standard label and imageView.
    enum ToastViewType: Int {
        case Blank, Standard
    }
    
    /// Possible horizontal aligment methods of the standard imageView with respect to the parent toast.
    enum ToastViewImageHorizontalAlignment: Int {
        case Left, Right
    }
    
    // MARK: - Default settings
    
    /// Default settings used when creating a new toast. Change these if you want a different default toast.
    struct Defaults {
        // General toast parameters
        static var toastBackgroundColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        static var toastCornerRadius: CGFloat = 0.0
        static var toastVerticalAlignment: ToastViewVerticalAlignment = .Bottom
        static var toastHorizontalAlignment: ToastViewHorizontalAlignment = .Center
        static var toastVerticalMargin: CGFloat = 20.0
        static var toastHorizontalMargin: CGFloat = 20.0
        static var toastDuration: Double = 3.0
        // Standard toast parameters
        static var standardLabelTextColor: UIColor = UIColor.whiteColor()
        static var standardLabelFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        static var standardLabelNumberOfLines: Int = 0
        static var standardLabelLineBreakMode: NSLineBreakMode = .ByWordWrapping
        static var standardImage: UIImage? = nil
        static var standardImageContentMode: UIViewContentMode = .ScaleToFill
        static var standardImageHorizontalAlignment: ToastViewImageHorizontalAlignment = .Left
    }
    
    // MARK: - Queue of the toasts
    
    /// The toast queue structure.
    /// Struct workaround is in use, since class vars are not yet supported.
    private struct StaticToastQueue {
        static var toastQueue: [CCToastView] = []
    }
    
    /// The toast queue. Used to group multiple queues and show only one at a time.
    private class var toastQueue: [CCToastView] {
        get { return StaticToastQueue.toastQueue }
        set { StaticToastQueue.toastQueue = newValue }
    }
    
    // MARK: - Instance parameters
    // MARK: General toast parameters
    
    /// The radius to use when drawing rounded corners for the toast's layer’s background.
    /// Value is passed to self.layer.cornerRadius, check docs for QuartzCore.CALayer.cornerRadius for more info.
    var toastCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    /// Vertical alignment of the toast.
    var toastVerticalAlignment: ToastViewVerticalAlignment
    
    /// Horizontal aligment of the toast.
    var toastHorizontalAlignment: ToastViewHorizontalAlignment
    
    /// Vertical margin (distance from the superview) of the toast.
    var toastVerticalMargin: CGFloat
    
    /// Horizontal margin (distance from the superview) of the toast.
    var toastHorizontalMargin: CGFloat
    
    /// Duration (in seconds) of the toast.
    var toastDuration: Double
    
    /// Type of the created toast.
    /// Used when determining whether to draw additional elements.
    private (set) var toastType: ToastViewType
    
    /// Main content view of the toast.
    /// If you want to make a custom toast, add new elements here.
    private (set) var toastContentView: UIView
    
    /// The superview the toast is to be shown in.
    /// Weakly referenced, if nil then the toast will not attempt to be displayed.
    private weak var parentView: UIView?;
    
    // MARK: Standard toast: label parameters
    
    /// The text in the standard label
    var standardLabelText: String? {
        set {
            if let lbl = label {
                lbl.text = newValue
            }
        }
        get {
            if let lbl = label {
                return lbl.text
            }
            else {
                return nil
            }
        }
    }
    
    /// The color of the text in the standard label.
    var standardLabelTextColor: UIColor? {
        set {
            if let lbl = label {
                lbl.textColor = newValue
            }
        }
        get {
            if let lbl = label {
                return lbl.textColor
            }
            else {
                return nil
            }
        }
    }
    
    /// The font of the text in the standard label.
    var standardLabelFont: UIFont? {
        set {
            if let lbl = label {
                if let newVal = newValue {
                    lbl.font = newVal
                }
            }
        }
        get {
            if let lbl = label {
                return lbl.font
            }
            else {
                return nil
            }
        }
    }
    
    /// The number of lines in the standard label.
    var standardLabelNumberOfLines: Int? {
        set {
            if let lbl = label {
                if let newVal = newValue {
                    lbl.numberOfLines = newVal
                }
            }
        }
        get {
            if let lbl = label {
                return lbl.numberOfLines
            }
            else {
                return nil
            }
        }
    }
    
    /// The type of line break mode to be used in standard label.
    var standardLabelLineBreakMode: NSLineBreakMode? {
        set {
            if let lbl = label {
                if let newVal = newValue {
                    lbl.lineBreakMode = newVal
                }
            }
        }
        get {
            if let lbl = label {
                return lbl.lineBreakMode
            }
            else {
                return nil
            }
        }
    }
    // MARK: Standard toast: imageView parameters
    
    /// The image used in the standard imageView
    var standardImage: UIImage? {
        set {
            if let iV = imageView {
                if let newVal = newValue {
                    iV.image = newVal
                }
            }
        }
        get {
            if let iV = imageView {
                return iV.image
            }
            else {
                return nil
            }
        }
    }
    
    /// The UIViewContentMode to be used in standard imageView.
    var standardImageContentMode: UIViewContentMode? {
        set {
            if let iV = imageView {
                if let newVal = newValue {
                    iV.contentMode = newVal
                }
            }
        }
        get {
            if let iV = imageView {
                return iV.contentMode
            }
            else {
                return nil
            }
        }
    }
    
    /// The horizontal aligment of the standard imageView (with respect to the toast).
    var standardImageHorizontalAlignment: ToastViewImageHorizontalAlignment
    
    // MARK: Standard toast: containers
    
    /// The standard label.
    private var label: UILabel?
    /// The standard imageView.
    private var imageView: UIImageView?
    
    // MARK: - Initializers
    
    // MARK: Required init, not supported
    /// Required init.
    /// Not supported.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Designated initializer
    /// Designated initializer.
    /// Creates the toast, using the default settings present in CCToastView.Defaults and the specified text (and image if present).
    /// 
    /// - parameter toastType: Use .Standard for a typical toast. Use .Blank when you want to make a custom toast
    /// (the standard label and imageView will not be created).
    /// - parameter text: The text to be shown in the toast.
    /// - parameter image(optional): The image to be shown in the toast.
    init(toastType: ToastViewType = .Standard, text: String = "", image: UIImage? = Defaults.standardImage) {
        toastVerticalAlignment = Defaults.toastVerticalAlignment
        toastHorizontalAlignment = Defaults.toastHorizontalAlignment
        toastVerticalMargin = Defaults.toastVerticalMargin
        toastHorizontalMargin = Defaults.toastHorizontalMargin
        toastDuration = Defaults.toastDuration
        standardImageHorizontalAlignment = Defaults.standardImageHorizontalAlignment
        self.toastType = toastType
        
        toastContentView = UIView(frame: CGRectZero)
        toastContentView.autoresizingMask = UIViewAutoresizing.None
        toastContentView.autoresizesSubviews = false
        toastContentView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: CGRectZero)
        
        self.backgroundColor = Defaults.toastBackgroundColor
        self.layer.cornerRadius = Defaults.toastCornerRadius
        self.autoresizingMask = UIViewAutoresizing.None
        self.autoresizesSubviews = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if (self.toastType == .Standard) {
            
            label = UILabel(frame: CGRectZero)
            label!.text = text
            label!.font = Defaults.standardLabelFont
            label!.textColor = Defaults.standardLabelTextColor
            label!.numberOfLines = Defaults.standardLabelNumberOfLines
            label!.lineBreakMode = Defaults.standardLabelLineBreakMode
            
            label!.adjustsFontSizeToFitWidth = false
            label!.translatesAutoresizingMaskIntoConstraints = false
            
            imageView = UIImageView(frame: CGRectZero)
            imageView!.contentMode = Defaults.standardImageContentMode
            imageView!.image = image
            imageView!.setContentCompressionResistancePriority(1000, forAxis: UILayoutConstraintAxis.Horizontal)
            
            imageView!.translatesAutoresizingMaskIntoConstraints = false
        }

        self.addSubview(toastContentView)
        
        let contentViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-1-[view]-1-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":self.toastContentView])
        let contentViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-1-[view]-1-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":self.toastContentView])
        
        self.addConstraints(contentViewHorizontalConstraints)
        self.addConstraints(contentViewVerticalConstraints)
    }
    
    // MARK: - Public methods
    
    /// Create and show a standard toast with default settings (stored in CCToastView.Defaults).
    ///
    /// NOTE: If there are other toasts to be shown, the toast will be added to the end of the toast queue and wait for its turn.
    /// Also, if the view is nil by the time the toast is first in queue, then the toast will be dropped.
    /// 
    /// - parameter text: The text to be shown in the toast.
    /// - parameter image(optional): The image to be shown in the toast.
    /// - parameter inView: The view where the toast is to be shown in.
    class func showDefaultToast(text: String = "", image: UIImage? = Defaults.standardImage, inView: UIView) {
        let defaultToast = CCToastView(text: text, image: image)
        defaultToast.showToast(inView)
    }
    
    /// Show the toast
    ///
    /// NOTE: If there are other toasts to be shown, the toast will be added to the end of the toast queue and wait for its turn.
    /// Also, if the view is nil by the time the toast is first in queue, then the toast will be dropped.
    func showToast(inView: UIView) {
        self.alpha = 0.0
        self.parentView = inView;
        
        if StaticToastQueue.toastQueue.count == 0 {
            StaticToastQueue.toastQueue.append(self)
            CCToastView.nextToastInQueue()
        }
        else {
            StaticToastQueue.toastQueue.append(self)
        }
    }
    
    // MARK: Private methods
    
    /// Show the next toast in the toastQueue.
    private class func nextToastInQueue() {
        if CCToastView.toastQueue.count > 0 {
            let nextToast = CCToastView.toastQueue[0]
            var parentViewOnScreen = false
            
            if let inView = nextToast.parentView {
                if inView.window != nil {
                    parentViewOnScreen = true
                    if (nextToast.toastType == .Standard) {
                        nextToast.toastContentView.addSubview(nextToast.label!)
                        nextToast.toastContentView.addSubview(nextToast.imageView!)
                        
                        var labelHorizontalConstraints: [NSLayoutConstraint]
                        
                        switch nextToast.standardImageHorizontalAlignment {
                        case ToastViewImageHorizontalAlignment.Left:
                            labelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-3-[image]-3-[label]-3-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":nextToast.label!,"image":nextToast.imageView!])
                        case ToastViewImageHorizontalAlignment.Right:
                            labelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-3-[label]-3-[image]-3-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":nextToast.label!,"image":nextToast.imageView!])
                        }
                        
                        let labelVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[label]-3-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":nextToast.label!])
                        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[image]-3-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["image":nextToast.imageView!])
                        
                        nextToast.toastContentView.addConstraints(labelHorizontalConstraints)
                        nextToast.toastContentView.addConstraints(labelVerticalConstraints)
                        nextToast.toastContentView.addConstraints(imageVerticalConstraints)
                    }
                    
                    inView.addSubview(nextToast)
                    
                    var horizontalConstraints: [NSLayoutConstraint]
                    var verticalConstraints: [NSLayoutConstraint]
                    
                    switch nextToast.toastHorizontalAlignment {
                    case .Left:
                        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-spacing-[view]-(>=spacing)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastHorizontalMargin], views: ["view":nextToast])
                    case .Right:
                        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(>=spacing)-[view]-spacing-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastHorizontalMargin], views: ["view":nextToast])
                    case .Center:
                        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(>=spacing)-[view]-(>=spacing)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastHorizontalMargin], views: ["view":nextToast])
                        horizontalConstraints.append(NSLayoutConstraint(item: nextToast, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: nextToast.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
                    }
                    
                    switch nextToast.toastVerticalAlignment {
                    case .Top:
                        verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-spacing-[view]-(>=spacing)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastVerticalMargin], views: ["view":nextToast])
                    case .Bottom:
                        verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=spacing)-[view]-spacing-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastVerticalMargin], views: ["view":nextToast])
                    case .Center:
                        verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=spacing)-[view]-(>=spacing)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacing":nextToast.toastVerticalMargin], views: ["view":nextToast])
                        verticalConstraints.append(NSLayoutConstraint(item: nextToast, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: nextToast.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
                    }
                    
                    inView.addConstraints(horizontalConstraints)
                    inView.addConstraints(verticalConstraints)
                    
                    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                        nextToast.alpha = 1.0
                        }, completion: { (finished: Bool) -> Void in
                            let delay = nextToast.toastDuration * Double(NSEC_PER_SEC)
                            let timeDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(timeDelay, dispatch_get_main_queue(), { () -> Void in
                                nextToast.toastFadeOut()
                            })
                    })
                }
            }
            if (parentViewOnScreen == false) {
                CCToastView.toastQueue.removeAtIndex(0)
                dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                    CCToastView.nextToastInQueue()
                })
            }
        }
    }
    
    /// Fade out the current toast and prepare to show the next toast in the queue.
    private func toastFadeOut() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (finished: Bool) -> Void in
                if let parentView = self.superview {
                    self.removeFromSuperview()
                }
                CCToastView.toastQueue.removeAtIndex(0)
                if CCToastView.toastQueue.count > 0 {
                    CCToastView.nextToastInQueue()
                }
        })
    }
}