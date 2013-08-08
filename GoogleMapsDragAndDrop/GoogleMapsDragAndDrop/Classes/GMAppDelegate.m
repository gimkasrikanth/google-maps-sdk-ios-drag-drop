//
//  GMAppDelegate.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 6/30/13.
//
//

#import <GoogleMaps/GoogleMaps.h>

#import "GMAppDelegate.h"

#import "GMPrivateMapsKey.h"
#import "GMViewController.h"


@interface GMAppDelegate ()

@property (strong, nonatomic) GMViewController *viewController;

@end

@implementation GMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialization of the GoogleMaps SDK.
    [GMSServices provideAPIKey:kPrivateMapsAPIKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[GMViewController alloc] initWithNibName:@"GMViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
