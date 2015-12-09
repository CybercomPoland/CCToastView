# CCToastView
=============

![ToastView example](Images/ToastView_Example.PNG)

## Introduction
CCToastView provides an easy way to present toast messages in iOS, while at the same time allowing to expand on its functionality.

Each accessible method and variable in the CCToastView class has been documented to explain what it does (it should also appear in Xcode's Quick Help, but documenting swift code at the time of writing is still a bit buggy, so no promises here).

The code is written in Swift.  
Requires iOS SDK 7.0+.  
ARC is used.  
QuartzCore framework is used (for drawing rounded corners).

## Getting started

### Instalation

The provided project shows examples of usage, but only the CCToastView.swift is needed for the toasts to work. To use, just copy that one file to your own project.

### How to use

#### Standard toast
For the simplest case, just call the static method:

```swift
CCToastView.showDefaultToast(text: "Hello World", inView: myUIView)
```

This will instantiate and show a toast with the default settings and the selected text. You can also pass an image to the method and it will be shown alongside the text:

```swift
let myImage = UIImage(named: "myImage")

CCToastView.showDefaultToast(text:"Hello World", inView: myUIView, image: myImage)
```

If you want to modify how the toast looks, instantiate the toast and then modify what you want before using the method to show it:

```swift
CCToastView myToast = CCToastView(text: "Hello World")

--Change toast parameters--

myToast.show(myUIView)
```

Similarly to the static method, you can pass an image in the constructor and it will be shown alongside the text.

Many parameters of the standard toast can be modified:

* background color
* corner radius
* vertical and horizontal alignment and margin
* duration time
* color of the label text
* label font
* number of lines in the label
* label line break mode
* image content mode
* image horizontal alignment (with respect to the toast)

Refer to the **Documentation - Instance Parameters** section for exact names for each of these parameters.

#### Default toast settings

Modify the parameters in **CCToastView.Defaults** to change the default parameters of the toasts. All toasts initially use the default settings, so you can use this to change the look of all your toasts without too much effort. For example, to change the background color of all future toasts to opaque red, you can do the following:

```swift
let myColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

CCToastView.Defaults.toastBackgroundColor = myColor

CCToastView.showDefaultToast("The default toast will now be red", inView: myUIView)

let myToast = CCToastView(text: "The instantiated toast will also be red")

myToast.show(myUIView)
```

Refer to the **Documentation - Default settings** section for exact names, types and default values of the parameters.

#### The toast queue

All of the toasts designated to be shown are stored in a private static array **toastQueue** (a struct workaround is used, since Swift at the time of writing still doesn't have class variables, only computed properties). Each new toast is added to the end of this queue and awaits its turn to be shown. Keep in mind that **only one toast is shown at a time**. If for some reason the target UIView is no longer in memory / visible on screen when the toast is first in queue, then it will be dropped and the next one will be taken. Otherwise, the toast will be shown for the duration (in seconds) specified in the toast parameter **toastDuration**. After that time has elapsed, the toast will disappear and the next one will be taken. This process will continue until the queue is emptied.

#### Toast modifications

If you want to create your own variation of a toast, you can pass a different parameter to the constructor:

```swift
CCToastView myToast = CCToastView(toastType: CCToastView.ToastViewType.Blank)
```

This will create a toast without the standard label and imageView. Add your own stuff to **myToast.toastContentView**. Make sure you add constraints.

## Documentation

### Enumerators

**ToastViewVerticalAlignment** - Possible vertical alignment methods of the toast. Values: Top, Center, Bottom.

**ToastViewHorizontalAlignment** - Possible horizontal alignment methods of the toast. Values: Left, Center, Right.

**ToastViewType** - Types of available (predefined) toasts. Values:

* **Blank** - creates an empty toastContentView - the standard label and imageView are not created. Use this if you want a custom toast. Add new elements to *toastContentView*.
* **Standard** - basic toast, creates the *toastContentView* along with standard label and imageView.

**ToastViewImageHorizontalAlignment** - Possible alignment methods of the standard imageView with respect to the parent toast. Values: Left, Right.

### Default settings

All toasts are created with the use of the default settings, so changing these allows to quickly change the layout of all toasts.
The default settings are stored in a structure, at **CCToastView.Defaults**. The static vars are the following:

| Name                             | Type                              | Default value                                    |
| -------------------------------- | --------------------------------- | ------------------------------------------------ |
| toastBackgroundColor             | UIColor                           | UIColor(red:0.1, green:0.1, blue:0.1, alpha:0.8) |
| toastCornerRadius                | CGFloat                           | 0.0                                              |
| toastVerticalAlignment           | ToastViewVerticalAlignemnt        | .Bottom                                          |
| toastHorizontalAlignment         | ToastViewHorizontalAlignemnt      | .Center                                          |
| toastVerticalMargin              | CGFloat                           | 20.0                                             |
| toastHorizontalMargin            | CGFloat                           | 20.0                                             |
| toastDuration                    | Double (regarded as seconds)      | 3.0                                              |
| standardLabelTextColor           | UIColor                           | UIColor.whiteColor()                             |
| standardLabelFont                | UIFont                            | UIFont.systemFontOfSize(UIFont.systemFontSize()) |
| standardLabelNumberOfLines       | Int                               | 0                                                |
| standardLabelLineBreakMode       | NSLineBreakMode                   | .ByWordWrapping                                  |
| standardImage                    | UIImage? (optional)               | nil                                              |
| standardImageContentMode         | UIViewContentMode                 | .ScaleToFill                                     |
| standardImageHorizontalAlignment | ToastViewImageHorizontalAlignment | .Left                                            |

The names should be (hopefully) self-explanatory. Variables with the *toast* prefix are general parameters used in all toasts, while variables with *standard* prefix are parameters used in the standard label and imageView present in the standard type of toast. Any variable type unique to the toasts is described in the **Enumerators** section above.
Note that for *toastDuration* the value stored is regarded as seconds (the value is multiplied by *Double(NSEC_PER_SEC)* in the code when deciding how long to wait before going for the next toast in the queue).

### Public methods

#### Designated initializer

The method to instantiate the class is the following:

```swift
init(toastType: ToastViewType = .Standard, text: String = "", image: UIImage? = Defaults.standardImage)
```

* **toastType** - the type of toast to create. By default, the standard toast is created.
* **text** - the text that will be be shown. By default, a blank string is used.
* **image** (optional) - the image to be shown alongside the text. By default, the standard image present in the default settings is used.

Full advantage is taken of the default parameters that are possible in Swift, so something like:

```swift
let myToast = CCToastView()
```

is perfectly viable (though a bit pointless). The main reason for this is so you don't have to write that you want a standard toast with a default image every time you create a new toast.

#### Show toast

This method is used to show an instantiated toast:

```swift
func show(inView: UIView)
```
* **inView** - the UIView where the toast will be shown.

The instantiated toast is pushed to the toastQueue with the specified UIView as the target.

#### Default toast static method

An additional static method is available for creating and showing a default toast when no parameters have to be changed. This creates the toast and immediately pushes it to the toastQueue with the specified UIView as target:

```swift
class func showDefaultToast(text: String = "", image: UIImage? = Defaults.standardImage, inView: UIView)
```
* **text** - the text that will be shown. By default, a blank string is used.
* **image** (optional) - the image to be shown alongside the text. By default, the standard image present in the default settings is used.
* **inView** - the UIView where the toast will be shown.

Only the UIView needs to be explicitly specified, the rest of the parameters have default values.

### Parameters

#### General parameters

These are the parameters present in every toast:

* **toastCornerRadius**: *CGFloat* - the radius of the corners for the toast.
* **toastVerticalAlignment**: *ToastViewVerticalAlignment* - the vertical alignment of the toast in relation to the view it is attached to.
* **toastHorizontalAlignment**: *ToastViewHorizontalAlignment* - the horizontal alignment of the toast in relation to the view it is attached to.
* **toastVerticalMargin**: *CGFloat* - the vertical margin of the toast from the edges of the view it is attached to.
* **toastHorizontalMargin**: *CGFloat* - the horizontal margin of the toast from the edges of the view it is attached to.
* **toastDuration**: *Double* - the amount of time the toast will be visible (in seconds).
* **toastType**: *ToastViewType (read-only)* - the type of toast. Currently only standard and blank (without the label and imageView) are available.
* **toastContentView**: *UIView (read-only)* - the UIView where all the UI content of the toast is stored. Add new UI elements here.
 

#### Standard toast parameters

These are the parameters present in a standard type of toast (they will be nil if the toast type is .Blank):

* **standardLabelText**: *String?* - the text in the standard label.
* **standardLabelTextColor**: *UIColor?* - the color of the text in the standard label.
* **standardLabelFont**: *UIFont?* - the font of the text in the standard label.
* **standardLabelNumberOfLines**: *Int?* - the maximum number of lines that can be present in the standard label. 0 - no limit.
* **standardLabelLineBreakMode**: *NSLineBreakMode?* - the type of line break to be used in the standard label. All NSLineBreakMode types are viable.
* **standardImage**: *UIImage?* - the image in the standard imageView.
* **standardImageContentMode**: *UIViewContentMode?* - the content mode to be used in the standard imageView. All UIViewContentMode types are viable.
* **standardImageHorizontalAlignment**: *ToastViewImageHorizontalAlignment?* - the horizontal alignment of the standard imageView in relation to the standard label.





