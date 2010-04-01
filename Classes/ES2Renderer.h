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

@class TEIRendererHelper;

@interface ES2Renderer : NSObject <ESRenderer> {
	
	TEIRendererHelper *_rendererHelper;
	
	EAGLContext *_context;
	
	GLint _backingWidth;
	GLint _backingHeight;
	
	GLuint _framebuffer;
	GLuint _colorbuffer;
	GLuint _depthbuffer;
	
	GLuint _program;
}

@property (nonatomic, retain) TEIRendererHelper *rendererHelper;

- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

@end

