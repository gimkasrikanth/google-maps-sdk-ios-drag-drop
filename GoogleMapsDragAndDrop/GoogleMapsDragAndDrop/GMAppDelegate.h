//
//  GMAppDelegate.h
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 3/9/13.
//
//

#import <UIKit/UIKit.h>

@class GMViewController;

@interface GMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GMViewController *viewController;

@end
