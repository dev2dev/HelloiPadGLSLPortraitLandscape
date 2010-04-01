//
//  EAGLView.m
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import "EAGLView.h"
#import "ES2Renderer.h"

@interface EAGLView (PrivateMethods)
-(id)initializeEAGL;
@end

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

- (void)dealloc {
	
    [renderer release];
	
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {

	NSLog(@"EAGL View - init With Frame: origin(%f %f) size(%f %f)", 
		  frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	
    if ((self = [super initWithFrame:frame])) {
		
		self = [self initializeEAGL];
		
    } // if ((self = [super initWithFrame:frame]))
	
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {    
	
	NSLog(@"EAGL View - init With Coder");
	
    if ((self = [super initWithCoder:coder])) {
		
		self = [self initializeEAGL];
		
    } // if ((self = [super initWithCoder:coder]))

    return self;
}

-(id)initializeEAGL {

	NSLog(@"EAGL View - initialize EAGL");

	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	NSLog(@"bounds: %f %f %f %f", eaglLayer.bounds.origin.x, eaglLayer.bounds.origin.y, eaglLayer.bounds.size.width, eaglLayer.bounds.size.height);
	NSLog(@"transform");
	NSLog(@"%f %f %f %f", eaglLayer.transform.m11, eaglLayer.transform.m12, eaglLayer.transform.m13, eaglLayer.transform.m14);
	NSLog(@"%f %f %f %f", eaglLayer.transform.m21, eaglLayer.transform.m22, eaglLayer.transform.m23, eaglLayer.transform.m24);
	NSLog(@"%f %f %f %f", eaglLayer.transform.m31, eaglLayer.transform.m32, eaglLayer.transform.m33, eaglLayer.transform.m34);
	NSLog(@"%f %f %f %f", eaglLayer.transform.m41, eaglLayer.transform.m42, eaglLayer.transform.m43, eaglLayer.transform.m44);
	
	eaglLayer.opaque = TRUE;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, 
									kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, 
									nil];
	
	renderer = [[ES2Renderer alloc] init];
	
	if (nil == renderer) {
		
		[self release];
		
		return renderer;
		
	} // if (nil == renderer)
	
	animating = FALSE;
	displayLinkSupported = FALSE;
	animationFrameInterval = 1;
	displayLink = nil;
	displayLinkSupported = TRUE;
	
	return self;
	
}

- (void)drawView:(id)sender {
	
//	NSLog(@"EAGL View - draw View");
		
    [renderer render];
}

- (void)layoutSubviews {
	
	NSLog(@"EAGL View - layout Subviews");
	
	// !!!!!!!!!!!!!!!!!
	[self stopAnimation];
	// !!!!!!!!!!!!!!!!!
	
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
	
	// !!!!!!!!!!!!!!!!!
	[self startAnimation];
	// !!!!!!!!!!!!!!!!!

    [self drawView:nil];
}

- (NSInteger)animationFrameInterval {
	
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval {
	
    if (frameInterval >= 1) {
		
        animationFrameInterval = frameInterval;

        if (animating) {
			
            [self stopAnimation];
            [self startAnimation];
			
        } // if (animating)
		
    } // if (frameInterval >= 1)
}

- (void)startAnimation {
	
	NSLog(@"EAGL View - start Animation");
		
    if (!animating) {
		
		displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
		[displayLink setFrameInterval:animationFrameInterval];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        animating = TRUE;
		
    } // if (!animating)
	
}

- (void)stopAnimation {
	
	NSLog(@"EAGL View - stop Animation");
	
    if (animating) {
		
		[displayLink invalidate];
		displayLink = nil;

        animating = FALSE;
		
    } // if (animating)
	
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

@end
