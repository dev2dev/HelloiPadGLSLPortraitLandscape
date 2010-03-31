//
//  Shader.vsh
//  HelloiPadGLSLPortraitLandscape
//
//  Created by turner on 3/31/10.
//  Copyright Douglass Turner Consulting 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
