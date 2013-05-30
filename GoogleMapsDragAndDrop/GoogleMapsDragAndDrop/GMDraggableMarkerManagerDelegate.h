//
//  GMDraggableMarkerManagerDelegate.h
//  GoogleMapsDragAndDrop
//
//  Created by Stephen Trainor on 5/30/13.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol GMDraggableMarkerManagerDelegate <NSObject>

@optional

- (void) onMarkerDrag:(GMSMarker *)marker;
- (void) onMarkerDragEnd:(GMSMarker *)marker;
- (void) onMarkerDragStart:(GMSMarker *)marker;

@end
