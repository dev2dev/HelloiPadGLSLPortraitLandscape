//
//  EAGLView.h
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ESRenderer.h"

@interface EAGLView : UIView {    
	
@private
    id <ESRenderer> renderer;

    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    id displayLink;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;

@end
