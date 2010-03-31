//
//  HelloiPadGLSLPortraitLandscapeAppDelegate.m
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import "HelloiPadGLSLPortraitLandscapeAppDelegate.h"
#import "EAGLViewController.h"
#import "EAGLView.h"

@implementation HelloiPadGLSLPortraitLandscapeAppDelegate

@synthesize window = _window;
@synthesize controller = _controller;

- (void) dealloc {
	
    [_window		release], _window		= nil;
    [_controller	release], _controller	= nil;
	
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {
	
	NSLog(@"Hello iPad GLSL Portrait Landscape AppDelegate - application Did Finish Launching");
	
    [self.window addSubview:self.controller.view];
    [self.window makeKeyAndVisible];
	
}

- (void) applicationWillResignActive:(UIApplication *)application {
	
	NSLog(@"Hello iPad GLSL Portrait Landscape AppDelegate - application Will Resign Active - [glView stopAnimation]");
	
	EAGLView *glView = (EAGLView *)self.controller.view;
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
	
	NSLog(@"Hello iPad GLSL Portrait Landscape AppDelegate - application Did Become Active - [glView startAnimation]");
	
//	EAGLView *glView = (EAGLView *)self.controller.view;
//	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSLog(@"Hello iPad GLSL Portrait Landscape AppDelegate - application Will Terminate - [glView stopAnimation]");
	
	EAGLView *glView = (EAGLView *)self.controller.view;
	[glView stopAnimation];
}

@end
