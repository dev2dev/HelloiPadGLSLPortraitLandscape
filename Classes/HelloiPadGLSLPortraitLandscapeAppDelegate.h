//
//  HelloiPadGLSLPortraitLandscapeAppDelegate.h
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLViewController;

@interface HelloiPadGLSLPortraitLandscapeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow			*_window;
	EAGLViewController	*_controller;
}

@property(nonatomic,retain) IBOutlet UIWindow *window;
@property(nonatomic,retain) IBOutlet EAGLViewController *controller;

@end
