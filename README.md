# Neura Swift Sample App
A port of the Objective-C sample app for Swift developers

##Notes on branches
This repository contains 2 different branches. The master branch is an example using Swift 2.7 code and is meant for developers with legacy codebases that still want to integrate with the Neura SDK. The swift_3 branch is meant for developers using the newest version of Swift.

##Up and running
To get this project up and running, the developer will need to clone the repository into their working environment. You will also need a copy of the Neura SDK. This can be done in one of two ways:

###Option 1: Cocoapods (Preferred)
In order to install the Neura SDK in your project using cocoapods, you'll need to add the Neura SDK specification to your Podfile:

`pod 'NeuraSDKFramework', '~> 2.0'`

Now, run `pod install` in the directory of your Podfile and you can begin working with the SDK

###Option 2: Manual Integration
If you choose to manually integrate the SDK into your app, you can download the zip file found [here](https://dev.theneura.com/docs/guide/ios/setup).
Unzip the download and drag the appropriate SDK framework into your project. Please check the "Copy items if needed" option. Make sure to follow the additional instructions on the [Neura Developer Site](https://dev.theneura.com/docs/guide/ios/setup).
