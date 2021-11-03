# Live Chat SDK iOS by Sociomile

### Required

* Programming language Swift
* Minimum iOS 15

### Download

1. Add pod file to the root file of your project at the end of repositories.
```ruby
target 'SociomileChatSDKApps' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SociomileChatSDK
  pod 'SociomileChatSDK', :path => './'

end
```

2. Add the dependency Sociomile
```swift
import SociomileChatSDK
``` 

### Usage
Usage is very simply, you only need to do following:

#### Add this code into your view controller:

```swift
let YOUR_CLIENT_ID = "***"
let THEME: Theme = .blue
SociomileRouter.setFloatingButton(self, self.view, theme: theme, clientId: YOUR_CLIENT_ID)
```

#### Configuration

* your set clientId already registered in sociomile:
```swift
let YOUR_CLIENT_ID = "/* your clientId set in here */"
```
* your set theme with .blue or .red:
```swift
let THEME = "/* your theme */"
```
