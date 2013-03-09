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
#define MARKER_DETECTION_BOX 60.0f

// Determines the distance between touch point and position of the marker.
#define MARKER_TOUCH_DISTANCE 70.0f

@interface GMViewController ()
@property (strong, nonatomic, readwrite) id<GMSMarker> marker;
@property (strong, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGesture;
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

    // Place a sample marker.
    GMSMarkerOptions *markerOptions = [[GMSMarkerOptions alloc] init];
    markerOptions.position = CLLocationCoordinate2DMake(40.761869, -73.975282);
    self.marker = [self.googleMapsView addMarkerWithOptions:markerOptions];
    
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
    
    // In the UIGestureRecognizerStateBegan there must be a check if there was a long press on the marker.
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        // Construct a rect arround your touch point.
        CGPoint markerPoint = [self.googleMapsView.projection pointForCoordinate:self.marker.position];
        CGRect markerVirtualBox = CGRectMake(markerPoint.x - (MARKER_DETECTION_BOX / 2.0f),
                                             markerPoint.y - (MARKER_DETECTION_BOX / 2.0f),
                                             MARKER_DETECTION_BOX,
                                             MARKER_DETECTION_BOX);
        
        // Check if touch point is in the rect.
        if (CGRectContainsPoint(markerVirtualBox, touchPoint))
        {
            // Disable the scroll gestures of the GoogleMaps view.
            self.googleMapsView.settings.scrollGestures = NO;
            
            // Save that marker was long pressed.
            self.didTapMarker = YES;
            
            // Calculate the new marker point - for better display the marker is shown slightly above of the touch.
            CGPoint newMarkerPoint = CGPointMake(markerPoint.x , markerPoint.y - MARKER_TOUCH_DISTANCE);

            // Calculate the coordinate of the marker point.
            CLLocationCoordinate2D coordinate = [self.googleMapsView.projection coordinateForPoint:newMarkerPoint];
            
            // Set the new coordinate to the marker.
            self.marker.position = coordinate;
        }
        
    }
    else
    {
        // Check if the marker was long pressed before.
        if (self.didTapMarker)
        {
            // Calculate the new marker point - for better display the marker is shown slightly above of the touch.
            CGPoint newMarkerPoint = CGPointMake(touchPoint.x , touchPoint.y - MARKER_TOUCH_DISTANCE);
            
            // Calculate the coordinate of the marker point.
            CLLocationCoordinate2D coordinate = [self.googleMapsView.projection coordinateForPoint:newMarkerPoint];
            
            // Update the marker position.
            if (UIGestureRecognizerStateChanged == recognizer.state)
            {
                // Set the new coordinate to the marker.
                self.marker.position = coordinate;
            }
            else
            {
                // Save that marker is no long pressed.
                self.didTapMarker = NO;
                
                // Enable the scroll gestures of the GoogleMaps view.
                self.googleMapsView.settings.scrollGestures = YES;
            }
        }
    }
}


@end
