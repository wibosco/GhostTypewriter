[![Build Status](https://travis-ci.org/wibosco/GhostTypewriter.svg)](https://travis-ci.org/wibosco/GhostTypewriter)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift" /></a>
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

A `TypewriterLabel` instance when added as a subview will hide it's content.

#### Starting

Starting the animation will cause the content of the label to be reveal one character at a time.

> How quickly each character is revealed is controlled by setting the `typingTimeInterval` property.

There are two ways to start an animation: with and without a completion closure.

With a completion closure:

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    titleLabel.startTypewritingAnimation {
        //Implement your completion closure body here...
    }
}
```

Without a completion closure:

```swift
import GhostTypewriter

@IBAction func startAnimationButtonPressed(_ sender: Any) {
    titleLabel.startTypewritingAnimation()
}
```

#### Stopping

Stopping an animation causes the characters that have been revealed to remain as is and no new characters being revealed.

```swift
import GhostTypewriter

@IBAction func stopAnimationButtonPressed(_ sender: Any) {
    titleLabel.stopTypewritingAnimation()
}
```

#### Resetting

Resetting an animation causes all characters to be hidden.

```swift
import GhostTypewriter

@IBAction func resetAnimationButtonPressed(_ sender: Any) {
    titleLabel.resetTypewritingAnimation()
}
```

It's important to note that resetting an `TypewriterLabel` instance does not cause the animation to restart instead you need to call `restartAnimationButtonPressed()`.

#### Restarting

Restarting an animation causes all characters to be hidden and for the animation to begin from the start again.

There are two ways to start an animation: with and without a completion closure.

Without a completion closure:

```swift
import GhostTypewriter

@IBAction func restartAnimationButtonPressed(_ sender: Any) {
    titleLabel.restartTypewritingAnimation()
}
```

With a completion closure:

```swift
import GhostTypewriter

@IBAction func restartAnimationButtonPressed(_ sender: Any) {
    titleLabel.restartTypewritingAnimation {
        //Implement your completion closure body here...
    }
}
```

#### Completing

Completing an animation causes all characters to instantly be revealed.

```swift
import GhostTypewriter

@IBAction func completeAnimationButtonPressed(_ sender: Any) {
    titleLabel.completeTypewritingAnimation()
}
```

#### Animation Options

By default `TypewriterLabel` hides the content of itself before revealing each character from index `0` to `n-1`. However it is possible to change this.

To hide each character rather than reveal, set the `animationStyle` property to `.hide`:

```swift
import GhostTypewriter

override func viewDidLoad() {
    super.viewDidLoad()

    titleLabel.animationStyle = .hide
}
```

`animationStyle` is defaulted to `.reveal`.

To go from index `n-1` to `0`, set the `animationDirection` to `.backward`:

```swift
import GhostTypewriter

override func viewDidLoad() {
    super.viewDidLoad()

    titleLabel.animationDirection = .backward
}
```

`animationDirection` is defaulted to `.forward`.

#### Adjusting Animation Timing

Each character of a `TypewriterLabel` instance is revealed at a pace set by the `typingTimeInterval` property.

`typingTimeInterval` defaults to `0.1` second.

```swift
import GhostTypewriter

override func viewDidLoad() {
    super.viewDidLoad()

    titleLabel.typingTimeInterval = 0.3
}
```

It's important to note that setting/changing `typingTimeInterval` after an animation has been started, has no affect on the timing of that animation.

#### Storyboards

As `TypewriterLabel` is contained in a pod, when using it with storyboards you will need to set the `Module` field to `GhostTypewriter`.

## Migrating from v1 to v2

Version [`2.0.0`](https://github.com/wibosco/GhostTypewriter/releases/tag/2.0.0) of `GhostTypewriter` contains breaking changes.

* `cancelTypewritingAnimation()` now use `resetTypewritingAnimation()`.
* `cancelTypewritingAnimation(clearText: true)` now use `resetTypewritingAnimation()`.
* `cancelTypewritingAnimation(clearText: false)` now use `stopTypewritingAnimation()`.

## Example

> `GhostTypewriter` comes with an [example project](https://github.com/wibosco/GhostTypewriter/tree/master/Example) to provide more details than listed above.

## Found an issue?

Please open a [new Issue here](https://github.com/wibosco/GhostTypewriterLabel/issues/new) if you run into a problem specific to GhostTypewriterLabel, have a feature request, or want to share a comment.

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
