google-maps-sdk-ios-drag-drop
=============================
A way to implement the drag &amp; drop functionality in the new Google Maps SDK for iOS.
***
Please note:
=============================
Before you can compile the project you have to create a new file called ```GMPrivateMapsKey.m``` and add it to the project. This file has to contain your API Key for the Google Maps SDK.
```
#import "GMPrivateMapsKey.h"

NSString *const kPrivateMapsAPIKey = @"<YOUR API KEY>";
```
  The way to receive a key is descriped at: https://developers.google.com/maps/documentation/ios/start

***

`GMViewController` creates an instance of `GMDraggableMarkerManager` and sets itself as the delegate in order to be notified of drag events.

***

A long press on the marker enables you to drag it around and set it to another position.

***

1. To initialize the drag & drop functionality you have to do import the `GMDraggableMarkerManager.h` in your UIViewController displaying the map:

	```#import "GMDraggableMarkerManager.h"```
2.	Create a property for the `GMDraggableMarkerManager`:

	```@property (strong, nonatomic, readwrite) GMDraggableMarkerManager *draggableMarkerManager;```


3. After the initialization of the Google Maps View you have to initialize the `draggableMarkerManager`:
	    `self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:self.googleMapsView delegate:self];`

***

To receive callbacks when the marker was dragged, the dragging startet/ended or just when there was a long press on a coordinate you have to conform the `GMDraggableMarkerManagerDelegate` protocol.

At the moment the following optional methods are available:

1.	`- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker;`


2.	`- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker;`

3.	`- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker;`

4.	`- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;`


***

If you have further questions or notes please feel free to contact:<br/>
robert.weindl@blackstack.net or stephen@crookneckconsulting.com

***

If you're happy and want me to stay happy you are welcome to buy me a coffee…
[![Donate](http://dribbble.s3.amazonaws.com/users/1390/screenshots/114752/shot_1297673467.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CJJTQQQGG2CJQ)