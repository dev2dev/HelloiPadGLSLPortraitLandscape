//
//  EAGLView.m
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import "EAGLView.h"
#import "ES2Renderer.h"

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

- (void)dealloc {
	
    [renderer release];
	
    [super dealloc];
}

- (id)initWithCoder:(NSCoder*)coder {    
	
    if ((self = [super initWithCoder:coder])) {
		
         CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, 
										kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, 
										nil];

        renderer = [[ES2Renderer alloc] init];

		if (!renderer) {
			
			[self release];
			return nil;
		} // if (!renderer)
 
        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
		displayLinkSupported = TRUE;
    }

    return self;
}

- (void)drawView:(id)sender {
	
    [renderer render];
}

- (void)layoutSubviews {
	
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
	
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
	
    if (!animating) {
		
		displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
		[displayLink setFrameInterval:animationFrameInterval];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        animating = TRUE;
		
    } // if (!animating)
	
}

- (void)stopAnimation {
	
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
