//
//  GMDraggableMarkerManagerDelegate.h
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 6/30/13.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol GMDraggableMarkerManagerDelegate <NSObject>

@optional
/**
 *  Called after a marker startet has been long pressed and the dragging starts.
 *
 *  @param mapView The map view that was long pressed.
 *  @param marker The marker that was long pressed.
 */
- (void)mapView:(GMSMapView *)mapView didStartDraggingMarker:(GMSMarker *)marker;

/**
 *  Called after the dragging of a marker ended.
 *
 *  @param mapView The map view where the dragging ended.
 *  @param marker The marker that was dragging ended.
 */
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker;

/**
 *  Called while a marker gets dragged. 
 *  This method will be called first if there was a significant change of the initial position in comparison to the touch point.
 *
 *  @param mapView The map view where the marker gets dragged.
 *  @param marker The marker that gets dragged.
 */
- (void)mapView:(GMSMapView *)mapView didDraggingMarker:(GMSMarker *)marker;

/**
 * Called after a long-press gesture at a particular coordinate.
 * This method has the same functionality than the method mapView:didStartDraggingMarker:.
 * The method is implemented to avoid conflicts with the GMSMapViewDelegate.
 *
 * @param mapView The map view that was pressed.
 * @param coordinate The location that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;

@end
