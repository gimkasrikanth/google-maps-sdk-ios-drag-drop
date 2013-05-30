//
//  GMAppDelegate.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 3/9/13.
//
//

#import "GMAppDelegate.h"

#import "GMViewController.h"
#import "GMPrivateMapsKey.h"
#import <GoogleMaps/GoogleMaps.h>

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
