//
//  TEIRendererHelper.h
//  HelloiPhoneiPodTouchPanorama
//
//  Created by turner on 3/4/10.
//  Copyright 2010 Douglass Turner Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ConstantsAndMacros.h"
#import "VectorMatrix.h"

@interface TEIRendererHelper : NSObject {

	M3DMatrix44f	_projectionViewModelTransform;
	M3DMatrix44f	_viewModelTransform;

	M3DMatrix44f	_projection;
	M3DMatrix44f	_modelTransform;
	M3DMatrix44f	_viewTransform;

	M3DMatrix44f	_cameraTransform;
	M3DMatrix44f	_surfaceNormalTransform;
	
	M3DVector3f		_eye;
	M3DVector3f		_target;
	M3DVector3f		_up;
	
	NSMutableDictionary	*_renderables;

}

- (float *) projectionViewModelTransform; 
- (void) setProjectionViewModelTransform:(M3DMatrix44f)input; 

- (float *) viewModelTransform; 
- (void) setViewModelTransform:(M3DMatrix44f)input; 

- (float *) projection; 
- (void) setProjection:(M3DMatrix44f)input; 

- (float *) modelTransform; 
- (void) setModelTransform:(M3DMatrix44f)input; 

- (float *) viewTransform; 

- (float *) cameraTransform; 

- (float *) surfaceNormalTransform; 

// eye
- (float *) eye; 
- (void) setEye:(M3DVector3f)input; 
- (void) setEyeX:(float)x y:(float)y z:(float)z; 

// target
- (float *) target; 
- (void) setTarget:(M3DVector3f)input; 
- (void) setTargetX:(float)x y:(float)y z:(float)z; 

// up
- (float *) up; 
- (void) setUp:(M3DVector3f)input; 
- (void) setUpX:(float)x y:(float)y z:(float)z; 

@property(nonatomic,retain)NSMutableDictionary *renderables;

- (void)placeCameraAtLocation:(M3DVector3f)location target:(M3DVector3f)target up:(M3DVector3f)up;

- (void)perspectiveProjectionWithFieldOfViewInDegreesY:(GLfloat)fieldOfViewInDegreesY 
							aspectRatioWidthOverHeight:(GLfloat)aspectRatioWidthOverHeight 
												  near:(GLfloat)near 
												   far:(GLfloat)far;

@end
