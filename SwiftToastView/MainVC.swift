//
//  MainVC.swift
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

import UIKit

class MainVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var toastTypeControl: UISegmentedControl!
    
    @IBOutlet weak var bgRedSlider: UISlider!
    @IBOutlet weak var bgGreenSlider: UISlider!
    @IBOutlet weak var bgBlueSlider: UISlider!
    @IBOutlet weak var bgAlphaSlider: UISlider!
    
    @IBOutlet weak var cornerRadiusTextField: UITextField!
    
    @IBOutlet weak var verticalAlignmentControl: UISegmentedControl!
    @IBOutlet weak var horizontalAlignmentControl: UISegmentedControl!
    @IBOutlet weak var verticalMarginTextField: UITextField!
    @IBOutlet weak var horizontalMarginTextField: UITextField!
    
    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var lRedSlider: UISlider!
    @IBOutlet weak var lGreenSlider: UISlider!
    @IBOutlet weak var lBlueSlider: UISlider!
    @IBOutlet weak var lAlphaSlider: UISlider!
    
    @IBOutlet weak var lFontControl: UISegmentedControl!
    @IBOutlet weak var lNumberOfLinesTextField: UITextField!
    @IBOutlet weak var lLineBreakModeControl: UISegmentedControl!
    
    @IBOutlet weak var imageSwitch: UISwitch!
    @IBOutlet weak var imageContentModeControl: UISegmentedControl!
    @IBOutlet weak var imageHorizontalAligmnetControl: UISegmentedControl!
    
    var currentlyEditedTextField : AnyObject? {
        willSet {
            currentlyEditedTextField?.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Put done button in accessory view
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 44))
        let barButtonDone = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "closeKeyboard")
        toolbar.items = [barButtonDone]
        textView.inputAccessoryView = toolbar
        cornerRadiusTextField.inputAccessoryView = toolbar
        verticalMarginTextField.inputAccessoryView = toolbar
        horizontalMarginTextField.inputAccessoryView = toolbar
        durationTextField.inputAccessoryView = toolbar
        lNumberOfLinesTextField.inputAccessoryView = toolbar
        
        // Make the textView prettier
        textView.layer.borderColor = UIColor.blackColor().CGColor
        textView.layer.borderWidth = 1.0
        
        // Set the selected toast type to standard
        toastTypeControl.selectedSegmentIndex = 0
        
        // Get the default background color and alpha and set the sliders
        var bgColorRed: CGFloat = 0
        var bgColorGreen: CGFloat = 0
        var bgColorBlue: CGFloat = 0
        var bgColorAlpha: CGFloat = 0
        
        CCToastView.Defaults.toastBackgroundColor.getRed(&bgColorRed, green: &bgColorGreen, blue: &bgColorBlue, alpha: &bgColorAlpha)
        
        bgRedSlider.setValue(Float(bgColorRed), animated: true)
        bgGreenSlider.setValue(Float(bgColorGreen), animated: true)
        bgBlueSlider.setValue(Float(bgColorBlue), animated: true)
        bgAlphaSlider.setValue(Float(bgColorAlpha), animated: true)
        
        // Get the default toast corner radius
        cornerRadiusTextField.text = CCToastView.Defaults.toastCornerRadius.description
        
        // Get the default toast aligments and margins
        switch CCToastView.Defaults.toastVerticalAlignment {
        case .Top:
            verticalAlignmentControl.selectedSegmentIndex = 0
        case .Center:
            verticalAlignmentControl.selectedSegmentIndex = 1
        case .Bottom:
            verticalAlignmentControl.selectedSegmentIndex = 2
        }
        
        switch CCToastView.Defaults.toastHorizontalAlignment {
        case .Left:
            horizontalAlignmentControl.selectedSegmentIndex = 0
        case .Center:
            horizontalAlignmentControl.selectedSegmentIndex = 1
        case .Right:
            horizontalAlignmentControl.selectedSegmentIndex = 2
        }
        
        verticalMarginTextField.text = CCToastView.Defaults.toastVerticalMargin.description
        horizontalMarginTextField.text = CCToastView.Defaults.toastHorizontalMargin.description
        
        // Get the default toast duration
        durationTextField.text = CCToastView.Defaults.toastDuration.description
        
        // Get the default text color and alpha and set the sliders
        var lColorRed: CGFloat = 0
        var lColorGreen: CGFloat = 0
        var lColorBlue: CGFloat = 0
        var lColorAlpha: CGFloat = 0
        
        CCToastView.Defaults.standardLabelTextColor.getRed(&lColorRed, green: &lColorGreen, blue: &lColorBlue, alpha: &lColorAlpha)
        
        lRedSlider.setValue(Float(lColorRed), animated: true)
        lGreenSlider.setValue(Float(lColorGreen), animated: true)
        lBlueSlider.setValue(Float(lColorBlue), animated: true)
        lAlphaSlider.setValue(Float(lColorAlpha), animated: true)
        
        // Get the default label font
        if (CCToastView.Defaults.standardLabelFont.fontName == UIFont.boldSystemFontOfSize(UIFont.systemFontSize()).fontName) {
            lFontControl.selectedSegmentIndex = 1
        }
        else if (CCToastView.Defaults.standardLabelFont.fontName == UIFont.italicSystemFontOfSize(UIFont.systemFontSize()).fontName) {
            lFontControl.selectedSegmentIndex = 2
        }
        else {
            lFontControl.selectedSegmentIndex = 0
        }
        // Get the default label number of lines
        lNumberOfLinesTextField.text = CCToastView.Defaults.standardLabelNumberOfLines.description
        
        // Get the default label line break mode
        switch CCToastView.Defaults.standardLabelLineBreakMode {
        case .ByWordWrapping:
            lLineBreakModeControl.selectedSegmentIndex = 0
        case .ByCharWrapping:
            lLineBreakModeControl.selectedSegmentIndex = 1
        case .ByTruncatingTail:
            lLineBreakModeControl.selectedSegmentIndex = 2
        default:
            lLineBreakModeControl.selectedSegmentIndex = 0
        }
        
        // Get check if there is an image to be shown
        if (CCToastView.Defaults.standardImage != nil) {
            imageSwitch.setOn(true, animated: true)
        }
        else {
            imageSwitch.setOn(false, animated: true)
        }
        
        // Get the default image content mode
        switch CCToastView.Defaults.standardImageContentMode {
        case .ScaleToFill:
            imageContentModeControl.selectedSegmentIndex = 0
        case .Center:
            imageContentModeControl.selectedSegmentIndex = 1
        default:
            imageContentModeControl.selectedSegmentIndex = 0
        }
        
        // Get the default image horizontal aligment with respect to the toast
        switch CCToastView.Defaults.standardImageHorizontalAlignment {
        case .Left:
            imageHorizontalAligmnetControl.selectedSegmentIndex = 0
        case .Right:
            imageHorizontalAligmnetControl.selectedSegmentIndex = 1
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        currentlyEditedTextField = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showToast(sender: UIButton) {
        var image: UIImage?
        var toastType: CCToastView.ToastViewType
        
        // Check which type of toast to use
        if (toastTypeControl.selectedSegmentIndex == 1) {
            toastType = .Blank
        }
        else {
            toastType = .Standard
        }
        // Check to see if there is an image to be present
        // If so, get the image from the resources of this project
        if imageSwitch.on == true {
            image = UIImage(named: "example")
        }
        
        // Instantiate the toast
        let toast = CCToastView(toastType: toastType, text: textView.text, image: image)
        
        // Set background color
        let bgColor: UIColor = UIColor(red: CGFloat(bgRedSlider.value), green: CGFloat(bgGreenSlider.value), blue: CGFloat(bgBlueSlider.value), alpha: CGFloat(bgAlphaSlider.value))
        toast.backgroundColor = bgColor
        
        // Set the corner radius
        toast.toastCornerRadius = CGFloat((cornerRadiusTextField.text! as NSString).floatValue)
        
        // Set the aligments and margins
        switch verticalAlignmentControl.selectedSegmentIndex {
        case 0:
            toast.toastVerticalAlignment = .Top
        case 1:
            toast.toastVerticalAlignment = .Center
        case 2:
            toast.toastVerticalAlignment = .Bottom
        default:
            toast.toastVerticalAlignment = .Bottom
        }
        
        switch horizontalAlignmentControl.selectedSegmentIndex {
        case 0:
            toast.toastHorizontalAlignment = .Left
        case 1:
            toast.toastHorizontalAlignment = .Center
        case 2:
            toast.toastHorizontalAlignment = .Right
        default:
            toast.toastHorizontalAlignment = .Center
        }
        
        toast.toastHorizontalMargin = CGFloat((verticalMarginTextField.text! as NSString).floatValue)
        toast.toastVerticalMargin = CGFloat((horizontalMarginTextField.text! as NSString).floatValue)
        
        // Set the duration
        toast.toastDuration = (durationTextField.text! as NSString).doubleValue
        
        // Set label color
        let lblColor: UIColor = UIColor(red: CGFloat(lRedSlider.value), green: CGFloat(lGreenSlider.value), blue: CGFloat(lBlueSlider.value), alpha: CGFloat(lAlphaSlider.value))
        toast.standardLabelTextColor = lblColor
        
        // Set the label font
        switch lFontControl.selectedSegmentIndex {
        case 0:
            toast.standardLabelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        case 1:
            toast.standardLabelFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        case 2:
            toast.standardLabelFont = UIFont.italicSystemFontOfSize(UIFont.systemFontSize())
        default:
            toast.standardLabelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        }
        
        // Set the label number of lines
        toast.standardLabelNumberOfLines = Int(lNumberOfLinesTextField.text!)
        
        //Set the label line break mode
        switch lLineBreakModeControl.selectedSegmentIndex {
        case 0:
            toast.standardLabelLineBreakMode = NSLineBreakMode.ByWordWrapping
        case 1:
            toast.standardLabelLineBreakMode = NSLineBreakMode.ByCharWrapping
        case 2:
            toast.standardLabelLineBreakMode = NSLineBreakMode.ByTruncatingTail
        default:
            toast.standardLabelLineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        
        // Set the image content mode
        if (imageContentModeControl.selectedSegmentIndex == 0) {
            toast.standardImageContentMode = UIViewContentMode.ScaleToFill
        }
        else {
            toast.standardImageContentMode = UIViewContentMode.Center
        }
        
        // Set the image horizontal alignment with respect to the toast
        if (imageHorizontalAligmnetControl.selectedSegmentIndex == 0) {
            toast.standardImageHorizontalAlignment = CCToastView.ToastViewImageHorizontalAlignment.Left
        }
        else {
            toast.standardImageHorizontalAlignment = CCToastView.ToastViewImageHorizontalAlignment.Right
        }
        
        // Show the toast
        toast.showToast(self.view)
    }
    
    @IBAction func showDefaultToast(sender: UIButton) {
        CCToastView.showDefaultToast(textView.text, inView: self.view)
    }
    
    @IBAction func textFieldEditDidBegin(sender: UITextField) {
        currentlyEditedTextField = sender
    }
    
    @IBAction func textFieldEditDidEnd(sender: UITextField) {
        if(sender.text == "") {
            switch LabelTags(rawValue: sender.tag)! {
            case LabelTags.CornerRadius:
                sender.text = String(CCToastView.Defaults.toastCornerRadius)
            case LabelTags.VerticalMargin:
                sender.text = String(CCToastView.Defaults.toastVerticalMargin)
            case LabelTags.HorizontalMargin:
                sender.text = String(CCToastView.Defaults.toastDuration)
            case LabelTags.Duration:
                sender.text = String(CCToastView.Defaults.toastDuration)
            case LabelTags.NumberOfLines:
                sender.text = String(CCToastView.Defaults.standardLabelNumberOfLines)
            }
        }

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        currentlyEditedTextField = textView
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        //currentlyEditedTextField = nil
    }
    
    func closeKeyboard() {
        currentlyEditedTextField = nil
    }
    
    enum LabelTags : Int {
        case CornerRadius = 0
        case VerticalMargin
        case HorizontalMargin
        case Duration
        case NumberOfLines
    }

}

