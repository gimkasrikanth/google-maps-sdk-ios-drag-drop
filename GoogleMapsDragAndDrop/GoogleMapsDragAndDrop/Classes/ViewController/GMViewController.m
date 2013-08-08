//
//  GMViewController.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 6/30/13.
//
//

#import "GMViewController.h"
#import "GMDraggableMarkerManager.h"
#import <GoogleMaps/GoogleMaps.h>

// Defines for Manhattan
#define GOOGLE_MAPS_START_LATITUDE 40.761869
#define GOOGLE_MAPS_START_LONGITUDE -73.975282
#define GOOGLE_MAPS_DEFAULT_ZOOM_LEVEL 12.0f

@interface GMViewController () <GMDraggableMarkerManagerDelegate>

@property (strong, nonatomic, readwrite) IBOutlet GMSMapView *googleMapsView;
@property (strong, nonatomic, readwrite) GMDraggableMarkerManager *draggableMarkerManager;

@end

@implementation GMViewController

#pragma mark - View lifecycle.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the GoogleMaps view.
    [self.googleMapsView setCamera:[GMSCameraPosition cameraWithLatitude:GOOGLE_MAPS_START_LATITUDE
                                                               longitude:GOOGLE_MAPS_START_LONGITUDE
                                                                    zoom:GOOGLE_MAPS_DEFAULT_ZOOM_LEVEL]];
    [self.googleMapsView setMapType:kGMSTypeNormal];

    // Initialize the draggable marker manager.
    self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:self.googleMapsView delegate:self];
    
    // Place sample marker to the map.
    NSArray *sampleMarkerLocations = [[NSArray alloc] initWithObjects: [[CLLocation alloc] initWithLatitude:40.767720 longitude:-74.011674],
                                      [[CLLocation alloc] initWithLatitude:40.766290 longitude:-73.953309],
                                      [[CLLocation alloc] initWithLatitude:40.814637 longitude:-73.974424],
                                      [[CLLocation alloc] initWithLatitude:40.761869 longitude:-73.975282],
                                      [[CLLocation alloc] initWithLatitude:40.735469 longitude:-73.985753], nil];
    
    NSUInteger index = 0;
    for (CLLocation *sampleMarkerLocation in sampleMarkerLocations)
    {
        // Initialize the marker.
        GMSMarker *marker = [GMSMarker markerWithPosition:sampleMarkerLocation.coordinate];

        switch (index)
        {
            // Demonstration of a non-draggable marker.
            case 0:
            {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
                marker.snippet = @"I am not draggable!";
                break;
            }
            // Demonstration of an marker with an alternative icon.
            case 1:
            {
                marker.icon = [UIImage imageNamed:@"alternative-pin-red"];
            }
            // Add a draggable marker.
            default:
            {
                marker.snippet = @"I am draggable!";
                [self.draggableMarkerManager addDraggableMarker:marker];
                break;
            }
        }
        // Add the marker to the map.
        marker.map = self.googleMapsView;
        index++;
    }
    
}

#pragma mark - GMDraggableMarkerManagerDelegate.
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    NSLog(@">>> mapView:didBeginDraggingMarker: %@", [marker description]);
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    NSLog(@">>> mapView:didDragMarker: %@", [marker description]);
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    NSLog(@">>> mapView:didEndDraggingMarker: %@", [marker description]);
}

- (void)mapView:(GMSMapView *)mapView didCancelDraggingMarker:(GMSMarker *)marker
{
    NSLog(@">>> mapView:didCancelDraggingMarker: %@", [marker description]);
}

@end
