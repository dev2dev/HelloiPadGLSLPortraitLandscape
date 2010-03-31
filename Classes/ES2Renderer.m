//
//  ES2Renderer.m
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

#import "ES2Renderer.h"

// uniform index
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// attribute index
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface ES2Renderer (PrivateMethods)
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ES2Renderer

- (id) init {
	
	if (self = [super init]) {
		
		_backingWidth = -1;
		_backingHeight = -1;
		
		NSLog(@"ES2 Renderer - init backing size (%d %d)", _backingWidth, _backingHeight);
				
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!_context || ![EAGLContext setCurrentContext:_context] || ![self loadShaders]) {
			
            [self release];
            return nil;
			
        } // if (!_context || ![EAGLContext setCurrentContext:_context] || ![self loadShaders])
		
	} // if (self = [super init])
	
	return self;
}





- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer {
	
	NSLog(@"ES2 Renderer - resize From Layer");
	
	NSLog(@"bounds: %f %f %f %f", layer.bounds.origin.x, layer.bounds.origin.y, layer.bounds.size.width, layer.bounds.size.height);
	NSLog(@"transform");
	NSLog(@"%f %f %f %f", layer.transform.m11, layer.transform.m12, layer.transform.m13, layer.transform.m14);
	NSLog(@"%f %f %f %f", layer.transform.m21, layer.transform.m22, layer.transform.m23, layer.transform.m24);
	NSLog(@"%f %f %f %f", layer.transform.m31, layer.transform.m32, layer.transform.m33, layer.transform.m34);
	NSLog(@"%f %f %f %f", layer.transform.m41, layer.transform.m42, layer.transform.m43, layer.transform.m44);
	NSLog(@"backing size BEFORE glGetRenderbufferParameter: (%d %d)", _backingWidth, _backingHeight);

	
	if (_defaultFramebuffer) {
		
		glDeleteFramebuffers(1, &_defaultFramebuffer);
		_defaultFramebuffer = 0;
	}
	
	if (_colorRenderbuffer) {
		
		glDeleteRenderbuffers(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
	}
		
	// framebuffer
	glGenFramebuffers(1, &_defaultFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
	
	// rgb buffer
	glGenRenderbuffers(1, &_colorRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
	
	
	
	
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
	
	NSLog(@"backing size  AFTER glGetRenderbufferParameter: (%d %d)", _backingWidth, _backingHeight);
	
    return YES;
}

- (void)render {
	
    // Replace the implementation of this method to do your own custom drawing

    static const GLfloat squareVertices[] = {
        -0.5f, -0.33f,
         0.5f, -0.33f,
        -0.5f,  0.33f,
         0.5f,  0.33f,
    };

    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };

    static float transY = 0.0f;

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:_context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
    glViewport(0, 0, _backingWidth, _backingHeight);

    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    // Use shader program
    glUseProgram(_program);

    // Update uniform value
    glUniform1f(uniforms[UNIFORM_TRANSLATE], (GLfloat)transY);
    transY += 0.075f;	

    // Update attribute values
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors);
    glEnableVertexAttribArray(ATTRIB_COLOR);

    // Validate program before drawing. This is a good check, but only really necessary in a debug build.
    // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:_program])
    {
        NSLog(@"Failed to validate program: %d", _program);
        return;
    }
#endif

    // Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;

    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }

    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;

    glLinkProgram(prog);

#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;

    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }

    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;

    // Create shader program
    _program = glCreateProgram();

    // Create and compile vertex shader
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }

    // Create and compile fragment shader
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }

    // Attach vertex shader to program
    glAttachShader(_program, vertShader);

    // Attach fragment shader to program
    glAttachShader(_program, fragShader);

    // Bind attribute locations
    // this needs to be done prior to linking
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_COLOR, "color");

    // Link program
    if (![self linkProgram:_program])
    {
        NSLog(@"Failed to link program: %d", _program);

        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program)
        {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return FALSE;
    }

    // Get uniform locations
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(_program, "translate");

    // Release vertex and fragment shaders
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);

    return TRUE;
}

- (void)dealloc
{
    // Tear down GL
    if (_defaultFramebuffer)
    {
        glDeleteFramebuffers(1, &_defaultFramebuffer);
        _defaultFramebuffer = 0;
    }

    if (_colorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }

    if (_program)
    {
        glDeleteProgram(_program);
        _program = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == _context)
        [EAGLContext setCurrentContext:nil];

    [_context release];
    _context = nil;

    [super dealloc];
}

@end
