google-maps-sdk-ios-drag-drop
=============================
A way to implement the drag &amp; drop functionality in the new Google Maps SDK for iOS.
***
Please note:
=============================
Before you compile the project you have to add your own Google Maps API key in the `GMAppDelegate`.

```
NSString *kPrivateMapsAPIKey = @"";
```
  The way to receive a key is descriped at: https://developers.google.com/maps/documentation/ios/start

***

`GMViewController` creates an instance of `GMDraggableMarkerManager` and sets itself as the delegate in order to be notified of drag events.

***

A long press on the marker enables you to drag it around and set it to another position.

***

If you have further questions or notes please feel free to contact:
robert.weindl@blackstack.net or stephen@crookneckconsulting.com

***

If you're happy and want me to stay happy you are welcome to buy me a coffee…
[![Donate](http://dribbble.s3.amazonaws.com/users/1390/screenshots/114752/shot_1297673467.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CJJTQQQGG2CJQ)