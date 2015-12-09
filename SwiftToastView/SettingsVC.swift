//
//  SettingsVC.swift
//  SwiftToastView
//
//  Created by Adrian Ziemecki on 30/03/15.
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

class SettingsVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveSettings(sender: UIButton) {
        var image: UIImage?
        // Check to see if there is an image to be present
        // If so, get the image from the resources of this project
        if imageSwitch.on == true {
            image = UIImage(named: "example")
        }
        
        // Set the image
        CCToastView.Defaults.standardImage = image
        
        // Set background color
        let bgColor: UIColor = UIColor(red: CGFloat(bgRedSlider.value), green: CGFloat(bgGreenSlider.value), blue: CGFloat(bgBlueSlider.value), alpha: CGFloat(bgAlphaSlider.value))
        CCToastView.Defaults.toastBackgroundColor = bgColor
        
        // Set the corner radius
        CCToastView.Defaults.toastCornerRadius = CGFloat((cornerRadiusTextField.text! as NSString).floatValue)
        
        // Set the aligments and margins
        switch verticalAlignmentControl.selectedSegmentIndex {
        case 0:
            CCToastView.Defaults.toastVerticalAlignment = .Top
        case 1:
            CCToastView.Defaults.toastVerticalAlignment = .Center
        case 2:
            CCToastView.Defaults.toastVerticalAlignment = .Bottom
        default:
            CCToastView.Defaults.toastVerticalAlignment = .Bottom
        }
        
        switch horizontalAlignmentControl.selectedSegmentIndex {
        case 0:
            CCToastView.Defaults.toastHorizontalAlignment = .Left
        case 1:
            CCToastView.Defaults.toastHorizontalAlignment = .Center
        case 2:
            CCToastView.Defaults.toastHorizontalAlignment = .Right
        default:
            CCToastView.Defaults.toastHorizontalAlignment = .Center
        }
        
        CCToastView.Defaults.toastHorizontalMargin = CGFloat((verticalMarginTextField.text! as NSString).floatValue)
        CCToastView.Defaults.toastVerticalMargin = CGFloat((horizontalMarginTextField.text! as NSString).floatValue)
        
        // Set the duration
        CCToastView.Defaults.toastDuration = (durationTextField.text! as NSString).doubleValue
        
        // Set label color
        let lblColor: UIColor = UIColor(red: CGFloat(lRedSlider.value), green: CGFloat(lGreenSlider.value), blue: CGFloat(lBlueSlider.value), alpha: CGFloat(lAlphaSlider.value))
        CCToastView.Defaults.standardLabelTextColor = lblColor
        
        // Set the label font
        switch lFontControl.selectedSegmentIndex {
        case 0:
            CCToastView.Defaults.standardLabelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        case 1:
            CCToastView.Defaults.standardLabelFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        case 2:
            CCToastView.Defaults.standardLabelFont = UIFont.italicSystemFontOfSize(UIFont.systemFontSize())
        default:
            CCToastView.Defaults.standardLabelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        }
        
        // Set the label number of lines
        if let number = Int(lNumberOfLinesTextField.text!) {
            CCToastView.Defaults.standardLabelNumberOfLines = number
        }
        
        //Set the label line break mode
        switch lLineBreakModeControl.selectedSegmentIndex {
        case 0:
            CCToastView.Defaults.standardLabelLineBreakMode = NSLineBreakMode.ByWordWrapping
        case 1:
            CCToastView.Defaults.standardLabelLineBreakMode = NSLineBreakMode.ByCharWrapping
        case 2:
            CCToastView.Defaults.standardLabelLineBreakMode = NSLineBreakMode.ByTruncatingTail
        default:
            CCToastView.Defaults.standardLabelLineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        
        // Set the image content mode
        if (imageContentModeControl.selectedSegmentIndex == 0) {
            CCToastView.Defaults.standardImageContentMode = UIViewContentMode.ScaleToFill
        }
        else {
            CCToastView.Defaults.standardImageContentMode = UIViewContentMode.Center
        }
        
        // Set the image horizontal alignment with respect to the toast
        if (imageHorizontalAligmnetControl.selectedSegmentIndex == 0) {
            CCToastView.Defaults.standardImageHorizontalAlignment = CCToastView.ToastViewImageHorizontalAlignment.Left
        }
        else {
            CCToastView.Defaults.standardImageHorizontalAlignment = CCToastView.ToastViewImageHorizontalAlignment.Right
        }
        
        // Show toast that settings were saved
        CCToastView.showDefaultToast("Settings Saved!", inView: self.view)
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        CCToastView.showDefaultToast("Example of Default Toast with hard-coded text (image optional).", inView: self.view)
    }
    
}

