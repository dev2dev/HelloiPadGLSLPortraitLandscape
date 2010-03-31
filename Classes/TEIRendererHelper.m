//
//  TEIRendererHelper.m
//  HelloiPhoneiPodTouchPanorama
//
//  Created by turner on 3/4/10.
//  Copyright 2010 Douglass Turner Consulting. All rights reserved.
//

#import "TEIRendererHelper.h"
#import "JLMMatrixLibrary.h"

@implementation TEIRendererHelper

@synthesize renderables = _renderables;

- (void) dealloc {
	
	[_renderables release], _renderables = nil;
    [super dealloc];
}

- (id) init {
	
	if (self = [super init]) {
		
		self.renderables = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
							 [NSNull null], @"texture",
							 [NSNull null], @"model",
							nil] autorelease];
		
	} // if (self = [super init])
	
	return self;
}

- (void)perspectiveProjectionWithFieldOfViewInDegreesY:(GLfloat)fieldOfViewInDegreesY 
							aspectRatioWidthOverHeight:(GLfloat)aspectRatioWidthOverHeight 
												  near:(GLfloat)near 
												   far:(GLfloat)far {
	
	GLfloat top		= near * tanf( m3dDegToRad(fieldOfViewInDegreesY)/2.0 );
	GLfloat bottom	= -top;
	
	GLfloat left	= bottom * aspectRatioWidthOverHeight;
	GLfloat right	=    top * aspectRatioWidthOverHeight;
		
	// column 1
	_projection[_11] = (2.0 * near) / (right - left);
	_projection[_12] = 0.0;
	_projection[_13] = 0.0;
	_projection[_14] = 0.0;
	
	// column 2
	_projection[_21] = 0.0;
	_projection[_22] = (2.0 * near)/(top - bottom);
	_projection[_23] = 0.0;
	_projection[_24] = 0.0;
	
	// column 3
	_projection[_31] = (right + left)/(right - left);
	_projection[_32] = (top + bottom)/(top - bottom);
	_projection[_33] = -(far + near)/(far - near);
	_projection[_34] = -1.0;
	
	// column 4
	_projection[_41] = 0.0;
	_projection[_42] = 0.0;
	_projection[_43] = -(2.0 * far * near)/(far - near);
	_projection[_44] = 0.0;
	
}

- (void)placeCameraAtLocation:(M3DVector3f)location target:(M3DVector3f)target up:(M3DVector3f)up {
	
	// We use the Richard Paul matrix notation of n, o, a, and p 
	// for x, y, z axes of orientation and p as translation
	M3DVector3f n; // x-axis
	M3DVector3f o; // y-axis
	M3DVector3f a; // z-axis
	M3DVector3f p; // translation vector
	
	// The camera is always pointed along the -z axis. So the "a" vector = -(target - eye)
	m3dLoadVector3f(a, -(target[0] - location[0]), -(target[1] - location[1]), -(target[2] - location[2]));
	m3dNormalizeVectorf(a);
	
	// The up parameter is assumed approximate. It corresponds to the y-axis or "o" vector.
	M3DVector3f o_approximate;
	m3dCopyVector3f(o_approximate, up);
	m3dNormalizeVectorf(o_approximate);
	
	//	n = o_approximate X a
	m3dCrossProductf(n, o_approximate, a);
	m3dNormalizeVectorf(n);
	
	// Calculate the exact up vector from the cross product
	// of the other basis vectors which are indeed orthogonal:
	//
	// o = a X n
	//
	m3dCrossProductf(o, a, n);
	
	// The translation vector - location - is the eye location.
	// It is the where the camera is positioned in world space.
	// Copy it into the "p" vector
	m3dCopyVector3f(p, location);
	
	// Build camera transform matrix from column vectors: n, o, a, p
	m3dLoadIdentity44f(_cameraTransform);
	MatrixElement(_cameraTransform, 0, 0) = n[0];
	MatrixElement(_cameraTransform, 1, 0) = n[1];
	MatrixElement(_cameraTransform, 2, 0) = n[2];
	
	MatrixElement(_cameraTransform, 0, 1) = o[0];
	MatrixElement(_cameraTransform, 1, 1) = o[1];
	MatrixElement(_cameraTransform, 2, 1) = o[2];
	
	MatrixElement(_cameraTransform, 0, 2) = a[0];
	MatrixElement(_cameraTransform, 1, 2) = a[1];
	MatrixElement(_cameraTransform, 2, 2) = a[2];
	
	MatrixElement(_cameraTransform, 0, 3) = p[0];
	MatrixElement(_cameraTransform, 1, 3) = p[1];
	MatrixElement(_cameraTransform, 2, 3) = p[2];
	
//	TIEEchoMatrix4x4(_cameraTransform);
	
	// Build upper 3x3 of OpenGL style "view" transformation from transpose of camera orientation
	// This is the inversion process. Since these 3x3 matrices are orthonormal a transpose is 
	// sufficient to invert
	m3dLoadIdentity44f(_viewTransform);	
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			MatrixElement(_viewTransform, i, j) = MatrixElement(_cameraTransform, j, i);
		}
	}
	
	// Complete building OpenGL camera transform by inserting the translation vector
	// as described in Richard Paul.
	MatrixElement(_viewTransform, 0, 3) = -m3dDotProductf(p, n);
	MatrixElement(_viewTransform, 1, 3) = -m3dDotProductf(p, o);
	MatrixElement(_viewTransform, 2, 3) = -m3dDotProductf(p, a);
	
}

- (float *) projectionViewModelTransform {
	return &_projectionViewModelTransform[0];
}

- (void) setProjectionViewModelTransform:(M3DMatrix44f)input {
	m3dCopyMatrix44f(_projectionViewModelTransform, input);
}

- (float *) viewModelTransform {
	return &_viewModelTransform[0];
}

- (void) setViewModelTransform:(M3DMatrix44f)input {
	m3dCopyMatrix44f(_viewModelTransform, input);
}

- (float *) projection {
	return &_projection[0];
}

- (void) setProjection:(M3DMatrix44f)input {
	m3dCopyMatrix44f(_projection, input);
}

- (float *) modelTransform {
	return &_modelTransform[0];
}

- (void) setModelTransform:(M3DMatrix44f)input {
	
	m3dCopyMatrix44f(_modelTransform, input);
	OolongMatrixInverse(_modelTransform, _surfaceNormalTransform);
}

- (float *) viewTransform {
	return &_viewTransform[0];
}

- (float *) cameraTransform {
	return &_cameraTransform[0];
}

- (float *) surfaceNormalTransform {
	return &_surfaceNormalTransform[0];
}

// eye
- (float *) eye {
	return &_eye[0];
}

- (void) setEye:(M3DVector3f)input {
	_eye[0] = input[0];
	_eye[1] = input[1];
	_eye[2] = input[2];
}

- (void) setEyeX:(float)x y:(float)y z:(float)z {
	_eye[0] = x;
	_eye[1] = y;
	_eye[2] = z;
	
}

// target
- (float *) target {
	return &_target[0];
}

- (void) setTarget:(M3DVector3f)input {
	_target[0] = input[0];
	_target[1] = input[1];
	_target[2] = input[2];
}

- (void) setTargetX:(float)x y:(float)y z:(float)z {
	_target[0] = x;
	_target[1] = y;
	_target[2] = z;
	
}

// up
- (float *) up {
	return &_up[0];
}

- (void) setUp:(M3DVector3f)input {
	_up[0] = input[0];
	_up[1] = input[1];
	_up[2] = input[2];
}

- (void) setUpX:(float)x y:(float)y z:(float)z {
	_up[0] = x;
	_up[1] = y;
	_up[2] = z;
	
}


@end
