google-maps-sdk-ios-drag-drop
=============================
A way to implement the drag &amp; drop functionality in the new Google Maps SDK for iOS.

Please note:
=============================
- Before you can compile the project you have to add your own Google Maps API key
- Add a file named GMPrivateMapsKey.m to the project, and define the following constant:

`NSString *const kPrivateMapsAPIKey = @"YOUR_API_KEY";`

  The way to receive a key is descriped at: https://developers.google.com/maps/documentation/ios/start

- GMViewController creates an instance of GMDraggableMarkerManager and sets itself as the delegate in order to be notified of drag events

- A long press on the marker enables you to drag it around and set it to another position.

If you have further questions or notes please feel free to contact:
robert.weindl@blackstack.net
stephen@crookneckconsulting.com
