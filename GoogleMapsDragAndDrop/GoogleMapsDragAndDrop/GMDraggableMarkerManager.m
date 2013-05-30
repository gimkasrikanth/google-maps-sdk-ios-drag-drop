//
//  GMDraggableMarkerManager.m
//  GoogleMapsDragAndDrop
//
//  Created by Stephen Trainor on 5/30/13.
//
//

#import "GMDraggableMarkerManager.h"

// Determine dimensions of CGRect which is used to detect if the marker was long pressed.
#define MARKER_DETECTION_BOX 40.0f

// Determines the distance between touch point and position of the marker.
#define MARKER_TOUCH_DISTANCE 70.0f


@interface GMDraggableMarkerManager()

@property (nonatomic, weak) id<GMDraggableMarkerManagerDelegate> delegate;
@property (nonatomic, weak) GMSMapView *mapView;
@property (nonatomic, weak) GMSMarker *marker;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (assign, nonatomic, readwrite) CLLocationCoordinate2D initialMarkerPosition;
@property (assign, nonatomic, readwrite) BOOL didDragMarker;
@property (assign, nonatomic, readwrite) BOOL didTapMarker;

@end

@implementation GMDraggableMarkerManager

- (id) initWithMapView:(GMSMapView *)mapView delegate:(id<GMDraggableMarkerManagerDelegate>)delegate {
    
    self = [super init];
    if (self) {
        _delegate = delegate;
        _mapView = mapView;
        
        // Add a custom long press gesture recognizer to the map.
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressGesture.minimumPressDuration = 0.4f;
        [_mapView addGestureRecognizer:_longPressGesture];
    }
    
    return self;
}

#pragma mark - Gesture Reconizer.
- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer {
    
    // Extract the touch point on the GoogleMaps view.
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    
    // Before the rect can be created the closest marker to the touch point must be determined.
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        self.marker = [self determineClosestMarkerForTouchPoint:touchPoint];
        
        // Deselect the marker if it is not the selected one.
        if (self.mapView.selectedMarker != self.marker)
        {
            self.mapView.selectedMarker = nil;
        }
    }
    
    // Check if a marker could be determined
    if (nil != self.marker)
    {
        // The rect arround the current touch point. It is used to check wheter a point was long pressed.
        // Furthermore the rect allows you to controll if a user also dragged the marker.
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:self.marker.position];
        CGRect markerVirtualBox = CGRectMake(markerPoint.x - (MARKER_DETECTION_BOX / 2.0f),
                                             markerPoint.y - (MARKER_DETECTION_BOX / 2.0f),
                                             MARKER_DETECTION_BOX,
                                             MARKER_DETECTION_BOX);
        
        // In the UIGestureRecognizerStateBegan there must be a check if there was a long press on the marker.
        if (UIGestureRecognizerStateBegan == recognizer.state)
        {
            // Check if touch point is in the rect.
            if (CGRectContainsPoint(markerVirtualBox, touchPoint))
            {
                // Disable the gestures of the GoogleMaps view for UIX.
                [self enableGoogleMapViewSettings:NO];
                
                // Reset the control properties.
                self.didTapMarker = YES;
                self.didDragMarker = NO;
                
                // Save the initial marker position.
                self.initialMarkerPosition = self.marker.position;
                
                // Calculate the new marker point - for better display the marker is shown slightly above the touch point.
                CGPoint newMarkerPoint = CGPointMake(markerPoint.x , markerPoint.y - MARKER_TOUCH_DISTANCE);
                
                // Calculate the coordinate of the marker point.
                CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:newMarkerPoint];
                
                // Set the new coordinate to the marker.
                self.marker.position = coordinate;
                
                if ([self.delegate respondsToSelector:@selector(onMarkerDragStart:)])
                    [self.delegate onMarkerDragStart:self.marker];
            }
            else
            {
                // No marker was hit so deselect the current marker and restore the default state.
                self.mapView.selectedMarker = nil;
                [self reset];
            }
        }
        else if (UIGestureRecognizerStateChanged == recognizer.state)
        {
            // Check if the marker was long pressed before.
            if (self.didTapMarker)
            {
                // The user started to drag the marker, so there is no longer any intention to restore the old state.
                if (!CGRectContainsPoint(markerVirtualBox, touchPoint) && NO == self.didDragMarker) {
                    // The marker was dragged.
                    self.didDragMarker = YES;
                }
                
                // Calculate the new marker point - for better display the marker is shown slightly above the touch point.
                CGPoint newMarkerPoint = CGPointMake(touchPoint.x , touchPoint.y - MARKER_TOUCH_DISTANCE);
                
                // Calculate the coordinate of the marker point.
                CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:newMarkerPoint];
                
                // Set the new coordinate to the marker.
                self.marker.position = coordinate;
                
                if ([self.delegate respondsToSelector:@selector(onMarkerDrag:)])
                    [self.delegate onMarkerDrag:self.marker];

            }
        }
        else if (UIGestureRecognizerStateEnded == recognizer.state)
        {
            // Only store the new position of the marker if there was a drag action.
            if (!self.didDragMarker) {
                // Restore the old position.
                self.marker.position = self.initialMarkerPosition;
            }

            // notify delegate before we reset
            if ([self.delegate respondsToSelector:@selector(onMarkerDragEnd:)])
                [self.delegate onMarkerDragEnd:self.marker];
            
            [self reset];
        } else {
            [self reset];
        }
    }
}

#pragma mark - Map Control

// Enables or disables all GoogleMap View Settings.
- (void)enableGoogleMapViewSettings:(BOOL)enable {

    if (enable) {
        self.mapView.settings.scrollGestures = YES;
        self.mapView.settings.zoomGestures = YES;
        self.mapView.settings.tiltGestures = YES;
        self.mapView.settings.rotateGestures = YES;
    } else {
        self.mapView.settings.scrollGestures = NO;
        self.mapView.settings.zoomGestures = NO;
        self.mapView.settings.tiltGestures = NO;
        self.mapView.settings.rotateGestures = NO;
    }
}

#pragma mark - Helper methods
// Determines the closest marker
- (GMSMarker *)determineClosestMarkerForTouchPoint:(CGPoint)touchPoint {
    
    // Initialize the return value.
    GMSMarker *resultMarker = nil;
    
    // Initialize the initial distance as the maximum of CGFloat.
    CGFloat distance = CGFLOAT_MAX;
    CGFloat tempDistance = CGFLOAT_MAX;
    
    // Determine the closest marker to the current touch point
    for (GMSMarker *marker in self.mapView.markers)
    {
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:marker.position];
        CGFloat xDist = (touchPoint.x - markerPoint.x);
        CGFloat yDist = (touchPoint.y - markerPoint.y);
        tempDistance = sqrt((xDist * xDist) + (yDist * yDist));
        
        // Check if a closer marker was found.
        if (tempDistance <= distance)
        {
            resultMarker = marker;
            distance = tempDistance;
        }
    }
    return resultMarker;
}

// Reset state
- (void)reset {
    
    // Reset the control properties.
    self.didTapMarker = NO;
    self.didDragMarker = NO;
    
    // Enable the gestures of the GoogleMaps view for UIX.
    [self enableGoogleMapViewSettings:YES];
    
    // Marker is no longer selected.
    self.marker = nil;
}

@end
