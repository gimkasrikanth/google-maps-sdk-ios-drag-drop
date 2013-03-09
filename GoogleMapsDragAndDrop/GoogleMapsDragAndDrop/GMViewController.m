//
//  GMViewController.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 3/9/13.
//
//

#import "GMViewController.h"

// Defines for Manhattan
#define GOOGLE_MAPS_START_LATITUDE 40.761869
#define GOOGLE_MAPS_START_LONGITUDE -73.975282
#define GOOGLE_MAPS_DEFAULT_ZOOM_LEVEL 12.0f

// Determine dimensions of CGRect which is used to detect if the marker was long pressed.
#define MARKER_DETECTION_BOX 40.0f

// Determines the distance between touch point and position of the marker.
#define MARKER_TOUCH_DISTANCE 70.0f

@interface GMViewController ()
@property (strong, nonatomic, readwrite) id<GMSMarker> marker;
@property (strong, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGesture;

@property (assign, nonatomic, readwrite) CLLocationCoordinate2D initialMarkerPosition;
@property (assign, nonatomic, readwrite) BOOL didDragMarker;
@property (assign, nonatomic, readwrite) BOOL didTapMarker;
@end

@implementation GMViewController

#pragma mark - View appearance.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the GoogleMaps view.
    [self.googleMapsView setCamera:[GMSCameraPosition cameraWithLatitude:GOOGLE_MAPS_START_LATITUDE
                                                               longitude:GOOGLE_MAPS_START_LONGITUDE
                                                                    zoom:GOOGLE_MAPS_DEFAULT_ZOOM_LEVEL]];
    [self.googleMapsView setMapType:kGMSTypeNormal];

    // Place sample marker to the map.
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects: [[CLLocation alloc] initWithLatitude:40.767720 longitude:-74.011674],
                             [[CLLocation alloc] initWithLatitude:40.766290 longitude:-73.953309],
                             [[CLLocation alloc] initWithLatitude:40.814637 longitude:-73.974424],
                             [[CLLocation alloc] initWithLatitude:40.761869 longitude:-73.975282],
                             [[CLLocation alloc] initWithLatitude:40.735469 longitude:-73.985753], nil];
    
    for (CLLocation *location in array)
    {
        GMSMarkerOptions *marker = [[GMSMarkerOptions alloc] init];
        marker.position = location.coordinate;
        [self.googleMapsView addMarkerWithOptions:marker];
    }
    
    // Store the initial position of the sample marker.
    self.initialMarkerPosition = self.marker.position;
    
    // Add a custom long press gesture recognizer to the map.
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleLongPressGesture:)];
    self.longPressGesture.minimumPressDuration = 0.4f;
    [self.googleMapsView addGestureRecognizer:self.longPressGesture];
    
}

#pragma mark - Gesture Reconizer.
- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer
{
    // Extract the touch point on the GoogleMaps view.
    CGPoint touchPoint = [recognizer locationInView:self.googleMapsView];

    // Before the rect can be created the closest marker to the touch point must be determined.
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        self.marker = [self determineClosestMarkerForTouchPoint:touchPoint];
        
        // Deselect the marker if it is not the selected one.
        if (self.googleMapsView.selectedMarker != self.marker)
        {
            self.googleMapsView.selectedMarker = nil;
        }
    }
    
    // Check if a marker could be determined
    if (nil != self.marker)
    {
        // The rect arround the current touch point. It is used to check wheter a point was long pressed.
        // Furthermore the rect allows you to controll if a user also dragged the marker.
        CGPoint markerPoint = [self.googleMapsView.projection pointForCoordinate:self.marker.position];
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
                
                // Calculate the new marker point - for better display the marker is shown slightly above of the touch.
                CGPoint newMarkerPoint = CGPointMake(markerPoint.x , markerPoint.y - MARKER_TOUCH_DISTANCE);

                // Calculate the coordinate of the marker point.
                CLLocationCoordinate2D coordinate = [self.googleMapsView.projection coordinateForPoint:newMarkerPoint];
                
                // Set the new coordinate to the marker.
                self.marker.position = coordinate;
            }
            else
            {
                // No marker was hit so deselect the current marker and restore the default state.
                self.googleMapsView.selectedMarker = nil;
                [self resetControlStates];
            }
        }
        else if (UIGestureRecognizerStateChanged == recognizer.state)
        {
            // Check if the marker was long pressed before.
            if (self.didTapMarker)
            {
                // The user startet to drag the marker. So there is no longer an intention to restore the old state.
                if (!CGRectContainsPoint(markerVirtualBox, touchPoint) &&
                    NO == self.didDragMarker)
                {
                    // The marker was dragged.
                    self.didDragMarker = YES;
                }
                
                // Calculate the new marker point - for better display the marker is shown slightly above of the touch.
                CGPoint newMarkerPoint = CGPointMake(touchPoint.x , touchPoint.y - MARKER_TOUCH_DISTANCE);
                
                // Calculate the coordinate of the marker point.
                CLLocationCoordinate2D coordinate = [self.googleMapsView.projection coordinateForPoint:newMarkerPoint];
                
                // Set the new coordinate to the marker.
                self.marker.position = coordinate;
            }
        }
        else if (UIGestureRecognizerStateEnded == recognizer.state)
        {
            // Only store the new position of the marker if there was a drag action.
            if (!self.didDragMarker)
            {
                // Restore the old position.
                self.marker.position = self.initialMarkerPosition;
            }
            [self resetControlStates];
        }
        else
        {
            [self resetControlStates];
        }
    }
}

#pragma mark - Map Control.
// Enables or disables all GoogleMap View Settings.
- (void)enableGoogleMapViewSettings:(BOOL)enable
{
    if (enable)
    {
        self.googleMapsView.settings.scrollGestures = YES;
        self.googleMapsView.settings.zoomGestures = YES;
        self.googleMapsView.settings.tiltGestures = YES;
        self.googleMapsView.settings.rotateGestures = YES;
    }
    else
    {
        self.googleMapsView.settings.scrollGestures = NO;
        self.googleMapsView.settings.zoomGestures = NO;
        self.googleMapsView.settings.tiltGestures = NO;
        self.googleMapsView.settings.rotateGestures = NO;
    }
}

#pragma mark - Helper methods.
// Determines the closest marker 
- (id<GMSMarker>)determineClosestMarkerForTouchPoint:(CGPoint)touchPoint
{
    // Initialize the return value.
    id<GMSMarker> resultMarker = nil;
    
    // Initialize the initial distance as the maximum of CGFloat.
    CGFloat distance = CGFLOAT_MAX;
    CGFloat tempDistance = CGFLOAT_MAX;
    
    // Determine the closest marker to the current touch point
    for (id<GMSMarker> marker in self.googleMapsView.markers)
    {
        CGPoint markerPoint = [self.googleMapsView.projection pointForCoordinate:marker.position];
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

// Reset control states.
- (void)resetControlStates
{
    // Reset the control properties.
    self.didTapMarker = NO;
    self.didDragMarker = NO;
    
    // Enable the gestures of the GoogleMaps view for UIX.
    [self enableGoogleMapViewSettings:YES];
    
    // Marker is no longer selected.
    self.marker = nil;
}

@end
