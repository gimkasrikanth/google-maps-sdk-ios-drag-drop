//
//  GMDraggableMarkerManager.h
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 6/30/13.
//
//

#import <Foundation/Foundation.h>
#import "GMDraggableMarkerManagerDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GMDraggableMarkerManager : NSObject

/**
	Initialize the draggable marker delegate.
	@param mapView The map view.
	@param delegate The delegate.
	@returns An object of the GMDraggableMarkerManager.
 */
- (id)initWithMapView:(GMSMapView *)mapView delegate:(id<GMDraggableMarkerManagerDelegate>)delegate;

/**
	Add and display a draggable marker.
	@param marker The new draggable marker.
 */
- (void)addDraggableMarker:(GMSMarker *)marker;

/**
	Remove a specific draggable marker.
	@param marker The marker to remove.
 */
- (void)removeDraggableMarker:(GMSMarker *)marker;

/**
	Remove all draggable marker.
 */
- (void)removeAllDraggableMarkers;

/**
	Return all draggable marker.
	@returns All draggable marker.
 */
- (NSArray *)draggableMarkers;

/**
    Property to control duration of the marker 'jump up' animation
 */
@property (nonatomic) NSTimeInterval markerAnimateUpDuration;

/**
    Property to control duration of the marker 'drop' animation
 */
@property (nonatomic) NSTimeInterval markerAnimateDownDuration;


/**
    Property to control distance that marker jumps up at start of drag
 */
@property (nonatomic) CGFloat markerAnimateUpDistance;

/**
 Property to control distance that marker jumps and then drops at end of drag
 */
@property (nonatomic) CGFloat markerAnimateDownDistance;

@end
