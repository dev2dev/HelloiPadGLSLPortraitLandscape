//
//  ES2Renderer.h
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import "ESRenderer.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ES2Renderer : NSObject <ESRenderer> {
	
@private
    EAGLContext *_context;

    GLint _backingWidth;
    GLint _backingHeight;

    GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;

    GLuint _program;
}

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end

