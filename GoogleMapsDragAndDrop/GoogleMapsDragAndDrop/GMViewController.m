//
//  GMViewController.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 3/9/13.
//
//

#import "GMViewController.h"

#import "GMDraggableMarkerManager.h"

// Defines for Manhattan
#define GOOGLE_MAPS_START_LATITUDE 40.761869
#define GOOGLE_MAPS_START_LONGITUDE -73.975282
#define GOOGLE_MAPS_DEFAULT_ZOOM_LEVEL 12.0f

@interface GMViewController () <GMDraggableMarkerManagerDelegate>

@property (nonatomic, strong) GMDraggableMarkerManager *draggableMarkerManager;

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

    self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:self.googleMapsView delegate:self];
    
    // Place sample marker to the map.
    NSArray *array = [[NSArray alloc] initWithObjects: [[CLLocation alloc] initWithLatitude:40.767720 longitude:-74.011674],
                             [[CLLocation alloc] initWithLatitude:40.766290 longitude:-73.953309],
                             [[CLLocation alloc] initWithLatitude:40.814637 longitude:-73.974424],
                             [[CLLocation alloc] initWithLatitude:40.761869 longitude:-73.975282],
                             [[CLLocation alloc] initWithLatitude:40.735469 longitude:-73.985753], nil];
    
    NSInteger i = 0;
    for (CLLocation *location in array) {
        
        GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
        
        if (3 == i) {
            // alternative pin image (to test image code paths in GMDraggableMarkerManager
            marker.icon = [UIImage imageNamed:@"alternative-pin-red"];
        } else if (4 == i) {
            // non-draggable marker
            marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        }
        
        if (4 != i)
            [self.draggableMarkerManager addDraggableMarker:marker];
        
        i++;
        
        marker.map = self.googleMapsView;
    }
    
}

#pragma mark - GMDraggableMarkerManagerDelegate

- (void) onMarkerDragStart:(GMSMarker *)marker {
    
    NSLog(@"onMarkerDragStart: %@", marker.description);
}

- (void) onMarkerDragEnd:(GMSMarker *)marker {
    
    NSLog(@"onMarkerDragEnd: %@", marker.description);
}

@end
