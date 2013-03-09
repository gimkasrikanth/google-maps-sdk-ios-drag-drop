//
//  GMViewController.h
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 3/9/13.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GMViewController : UIViewController

// An outlet for the GoogleMaps view.
@property (strong, nonatomic, readwrite) IBOutlet GMSMapView *googleMapsView;

@end
