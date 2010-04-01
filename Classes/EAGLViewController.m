//
//  EAGLViewController.m
//  HelloiPhoneiPodTouchPanorama
//
//  Created by turner on 2/25/10.
//  Copyright 2010 Douglass Turner Consulting. All rights reserved.
//

#import "EAGLViewController.h"
#import "EAGLView.h"
#import "ES2Renderer.h"
#import "TEITexture.h"

@interface EAGLViewController (PrivateMethods)
- (NSString*)interfaceOrientationName:(UIInterfaceOrientation) interfaceOrientation;
- (NSString*)deviceOrientationName:(UIDeviceOrientation) deviceOrientation;
@end

@implementation EAGLViewController

- (void)dealloc {
 
    [super dealloc];
}

- (void)loadView {
	
	NSLog(@"EAGL ViewController - view Did Load");
	
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	
	EAGLView *eaglView = [[[EAGLView alloc] initWithFrame:frame] autorelease];
	
	self.view = eaglView;
}

 - (void)viewDidLoad {
	
	NSLog(@"EAGL ViewController - view Did Load");
		
//	EAGLView *glView = (EAGLView *)self.view;
//	
//	TEITexture	*t = [[ [TEITexture alloc] initWithImageFile:@"twitter_fail_whale" extension:@"png" mipmap:YES ] autorelease];
//	[glView.renderer.rendererHelper.renderables setObject:t forKey:@"texture_0"];

}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Will Appear");
		
}

- (void)viewDidAppear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Did Appear");
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Will Disappear");
	
}

- (void)viewDidDisappear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Did Disappear");
	
}

- (void)viewDidUnload {
	
	NSLog(@"EAGL ViewController - view Did Unload");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	
	UIDeviceOrientation currentDeviceOrientation = [UIDevice currentDevice].orientation;
	UIInterfaceOrientation currentInterfaceOrientation	= self.interfaceOrientation;
	
	NSLog(@"EAGL ViewController - will Rotate To Interface Orientation: %@. Current Interface Orientation: %@. Current Device Orientation: %@", 
		  [self interfaceOrientationName:toInterfaceOrientation], 
		  [self interfaceOrientationName:currentInterfaceOrientation], 
		  [self deviceOrientationName:currentDeviceOrientation]);
		
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	UIDeviceOrientation currentDeviceOrientation = [UIDevice currentDevice].orientation;
	UIInterfaceOrientation currentInterfaceOrientation	= self.interfaceOrientation;
	
	NSLog(@"EAGL ViewController - did Rotate From Interface Orientation: %@. Current Interface Orientation: %@. Current Device Orientation: %@", 
		  [self interfaceOrientationName:fromInterfaceOrientation], 
		  [self interfaceOrientationName:currentInterfaceOrientation], 
		  [self deviceOrientationName:currentDeviceOrientation]);
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (NSString*)interfaceOrientationName:(UIInterfaceOrientation) interfaceOrientation {
	
	NSString* result = nil;
	
	switch (interfaceOrientation) {
			
		case UIInterfaceOrientationPortrait:
			result = @"UIInterfaceOrientationPortrait";
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			result = @"UIInterfaceOrientationPortraitUpsideDown";
			break;
		case UIInterfaceOrientationLandscapeLeft:
			result = @"UIInterfaceOrientationLandscapeLeft";
			break;
		case UIInterfaceOrientationLandscapeRight:
			result = @"UIInterfaceOrientationLandscapeRight";
			break;
		default:
			result = @"Unknown Interface Orientation";
	}
	
	return result;
};

- (NSString*)deviceOrientationName:(UIDeviceOrientation) deviceOrientation {
	
	NSString* result = nil;
	
	switch (deviceOrientation) {
			
		case UIDeviceOrientationUnknown:
			result = @"UIDeviceOrientationUnknown";
			break;
		case UIDeviceOrientationPortrait:
			result = @"UIDeviceOrientationPortrait";
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			result = @"UIDeviceOrientationPortraitUpsideDown";
			break;
		case UIDeviceOrientationLandscapeLeft:
			result = @"UIDeviceOrientationLandscapeLeft";
			break;
		case UIDeviceOrientationLandscapeRight:
			result = @"UIDeviceOrientationLandscapeRight";
			break;
		case UIDeviceOrientationFaceUp:
			result = @"UIDeviceOrientationFaceUp";
			break;
		case UIDeviceOrientationFaceDown:
			result = @"UIDeviceOrientationFaceDown";
			break;
		default:
			result = @"Unknown Device Orientation";
	}
	
	return result;
};

@end
