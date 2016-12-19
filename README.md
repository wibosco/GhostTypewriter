[![Build Status](https://travis-ci.org/wibosco/TypeWriting.svg)](https://travis-ci.org/wibosco/TypeWriting)
[![Version](https://img.shields.io/cocoapods/v/TypeWriting.svg?style=flat)](http://cocoapods.org/pods/TypeWriting)
[![License](https://img.shields.io/cocoapods/l/TypeWriting.svg?style=flat)](http://cocoapods.org/pods/TypeWriting)
[![Platform](https://img.shields.io/cocoapods/p/TypeWriting.svg?style=flat)](http://cocoapods.org/pods/TypeWriting)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/TypeWriting.svg)](http://cocoapods.org/pods/TypeWriting)

A `UILabel` subclass that adds a type writing animation effect.

This pod was inspired by the following post [here](http://williamboles.me/ghost-typing-your-way-to-hollywood/).

##Installation via [CocoaPods](https://cocoapods.org/)

To integrate CoreDataServices into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

pod 'TypeWriting'
```

Then, run the following command:

```bash
$ pod install
```

> CocoaPods 1.1.1+ is required to build `TypeWriting`.

##Usage

![Animated Typing](typingAnimation.gif)

`TypeWritingLabel` is a subclass of `UILabel` and where the animation (magic) happens. It works by taking advantage of the `attributedText` property on the label and changing the properties of the text content to gradually expose the text using an animation similar to what you get on a mechanical type writer. 

####Starting

```swift
import TypeWriting

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    self.descriptionLabel.startTypewritingAnimation(completion: nil)
}
```

####Stoping

```swift
import TypeWriting

@IBAction func startAnimationButtonPressed(_ sender: Any) {
	if animating {
		descriptionLabel.stopTypewritingAnimation()
	} else {
		self.descriptionLabel.startTypewritingAnimation(completion: nil)
	}
}
```

####Canceling

```swift
import TypeWriting

@IBAction func startAnimationButtonPressed(_ sender: Any) {
	if animating {
		descriptionLabel.cancelTypewritingAnimation()
	} else {
		self.descriptionLabel.startTypewritingAnimation(completion: nil)
	}
}
```

####Chaining animations

```swift
import TypeWriting

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    titleLabel.cancelTypewritingAnimation()
    descriptionLabel.cancelTypewritingAnimation()
    
    titleLabel.startTypewritingAnimation {
        self.descriptionLabel.startTypewritingAnimation(completion: nil)
    }
}
```

####Adjusting animation timing

```swift
import TypeWriting

override func viewDidLoad() {
	super.viewDidLoad()
	titleLabel.typingTimeInterval = 0.3
}
```

####Storyboards

As `TypeWritingLabel` is in a pod, when using it in storyboards you will need to define the `Module` field.

##Example

> `TypeWriting` comes with an [example project](https://github.com/wibosco/TypeWritingLabel/tree/master/Example) to provide more details than listed above.

##Found an issue?

Please open a [new Issue here](https://github.com/wibosco/TypeWritingLabel/issues/new) if you run into a problem specific to CoreDataServices, have a feature request, or want to share a comment. Note that general Core Data questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
