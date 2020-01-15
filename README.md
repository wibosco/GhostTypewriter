[![Build Status](https://travis-ci.org/wibosco/GhostTypewriter.svg)](https://travis-ci.org/wibosco/GhostTypewriter)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat" alt="Swift" /></a>
[![Version](https://img.shields.io/cocoapods/v/GhostTypewriter.svg?style=flat)](http://cocoapods.org/pods/GhostTypewriter)
[![License](https://img.shields.io/cocoapods/l/GhostTypewriter.svg?style=flat)](http://cocoapods.org/pods/GhostTypewriter)
[![Platform](https://img.shields.io/cocoapods/p/GhostTypewriter.svg?style=flat)](http://cocoapods.org/pods/GhostTypewriter)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/GhostTypewriter.svg)](http://cocoapods.org/pods/GhostTypewriter)
<a href="https://twitter.com/wibosco"><img src="https://img.shields.io/badge/twitter-@wibosco-blue.svg?style=flat" alt="Twitter: @wibosco" /></a>

A `UILabel` subclass that adds a typewriting animation effect - as if a 👻 was typing it directly on your user's device!

This pod was inspired by the following post [here](http://williamboles.me/ghost-typing-your-way-to-hollywood/).

## Installation via [CocoaPods](https://cocoapods.org/)

To integrate `GhostTypewriter` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

pod 'GhostTypewriter'
```

Then, run the following command:

```bash
$ pod install
```

> CocoaPods 1.1.1+ is required to build `GhostTypewriter`.

## Usage

![Animated Typing](typingAnimation.gif)

`TypewriterLabel` is a subclass of `UILabel` and where the animation (magic) happens. It works by taking advantage of the `attributedText` property on the label and changing the properties of the text content to gradually expose the text using an animation similar to what you get on a mechanical typewriter. 

#### Starting

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    descriptionLabel.startTypewritingAnimation(completion: nil)
}
```

#### Stopping

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    if animating {
	descriptionLabel.stopTypewritingAnimation()
    } else {
	descriptionLabel.startTypewritingAnimation(completion: nil)
    }
}
```

#### Canceling

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    if animating {
        descriptionLabel.cancelTypewritingAnimation()
    } else {
	descriptionLabel.startTypewritingAnimation(completion: nil)
    }
}
```

#### Chaining animations

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    titleLabel.cancelTypewritingAnimation()
    descriptionLabel.cancelTypewritingAnimation()
    
    titleLabel.startGhostTypewriterAnimation {
        self.descriptionLabel.startTypewritingAnimation(completion: nil)
    }
}
```

#### Adjusting animation timing

```swift
import GhostTypewriter

override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.typingTimeInterval = 0.3
}
```

#### Storyboards

As `TypewriterLabel` is contained in a pod, when using it with storyboards you will need to set the `Module` field to `GhostTypewriter`.

## Example

> `GhostTypewriter` comes with an [example project](https://github.com/wibosco/GhostTypewriter/tree/master/Example) to provide more details than listed above.

## Found an issue?

Please open a [new Issue here](https://github.com/wibosco/GhostTypewriterLabel/issues/new) if you run into a problem specific to GhostTypewriterLabel, have a feature request, or want to share a comment.

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
