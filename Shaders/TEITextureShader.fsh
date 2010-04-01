//
//  TEITextureShader.fsh
//  HelloiPadGLSL
//
//  Created by turner on 2/25/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//
precision highp float;

varying lowp	vec4 v_rgba;
varying	mediump vec2 v_st;

uniform sampler2D	myTexture_0;

void main() {

	vec4 dev_null;
	dev_null = v_rgba;

	vec3 texas = texture2D(myTexture_0, v_st).rgb;	
	gl_FragColor = vec4(texas, 1.0);

}
