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
	
    [super viewDidLoad];
	
//	EAGLView *glView = (EAGLView *)self.view;
//	
//	TEITexture	*texture_0 = [[ [TEITexture alloc] initWithImageFile:@"lena" extension:@"png" mipmap:YES ] autorelease];
//	[glView.renderer.rendererHelper.renderables setObject:texture_0 forKey:@"texture_0"];
//
//	TEITexture	*texture_1 = [[ [TEITexture alloc] initWithImageFile:@"mandrill" extension:@"png" mipmap:YES ] autorelease];
//	[glView.renderer.rendererHelper.renderables setObject:texture_1 forKey:@"texture_1"];
//	
//	[glView.renderer setupGLView:self.view.bounds.size];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Will Appear");
	
	[super viewWillAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"EAGL ViewController - view Will Disappear");
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	
	NSLog(@"EAGL ViewController - view Did Unload");
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

@end
