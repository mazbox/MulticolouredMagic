
/**
 * == Simplified BSD *** MODIFIED FOR NON-COMMERCIAL USE ONLY!!! *** ==
 * Copyright (c) 2011, Cariad Interactive LTD
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted 
 * provided that the following conditions are met:
 * 
 *   * Redistributions of source code must retain the above copyright notice, this list of 
 *     conditions and the following disclaimer.
 * 
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of 
 *     conditions and the following disclaimer in the documentation and/or other materials provided 
 *     with the distribution.
 * 
 *   * Any redistribution, use, or modification is done solely for personal benefit and not for any 
 *     commercial purpose or for monetary gain
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include "ofMain.h"
#include "testApp.h"
#include "ReactickleApp.h"



int WIDTH = 480;
int HEIGHT = 320;
float WIDTH_SCALE = 1;
float HEIGHT_SCALE = 1;

bool RETINA = true;
bool IPAD = true;
bool HI_RES = true;
bool FAKE_GAME_MODE = false;
bool HAS_CAMERA = true;

string IMAGE_ROOT = "images4/";

string APP_NAME = "openFrameworks";
//#define DEBUG_MODE


int main(){
#ifdef TARGET_OF_IPHONE
	
	WIDTH = [[UIScreen mainScreen] bounds].size.width;
	HEIGHT = [[UIScreen mainScreen] bounds].size.height;
	
	if(WIDTH<HEIGHT) {
		std::swap(WIDTH, HEIGHT);
	}
	

	printf("WIDTH: %d    HEIGHT: %d\n", WIDTH, HEIGHT);

	
	ofiOSWindowSettings settings;
	settings.enableRetina = true; // enables retina resolution if the device supports it.
	settings.enableDepth = false; // enables depth buffer for 3d drawing.
//	settings.enableAntiAliasing = false; // enables anti-aliasing which smooths out graphics on the screen.
//	settings.numOfAntiAliasingSamples = 0; // number of samples used for anti-aliasing.
	settings.enableHardwareOrientation = false; // enables native view orientation.
	settings.enableHardwareOrientationAnimation = false; // enables native orientation changes to be animated.
//	settings.glesVersion = OFXIOS_RENDERER_ES2; // type of renderer to use, ES1, ES2, ES3
//	settings.windowControllerType = ofxiOSWindowControllerType::GL_KIT; // Window Controller Type
	settings.colorType = ofxiOSRendererColorFormat::RGBA8888; // color format used default RGBA8888
	settings.depthType = ofxiOSRendererDepthFormat::DEPTH_NONE; // depth format (16/24) if depth enabled
	settings.stencilType = ofxiOSRendererStencilFormat::STENCIL_NONE; // stencil mode
	settings.enableMultiTouch = true; // enables multitouch support and updates touch.id etc.
//	ofCreateWindow(settings);
	
	auto fullscreenType = OF_FULLSCREEN;
//	fullscreenType = OF_WINDOW;
//	ofSetupOpenGL(WIDTH, HEIGHT, fullscreenType);			// <-------- setup the GL context

	settings.glesVersion = 1;

	settings.setSize(WIDTH, HEIGHT);
	settings.windowMode = fullscreenType;
	ofCreateWindow(settings);
	
	
#else
	//WIDTH_SCALE = 2;
	//HEIGHT_SCALE = 2;
	WIDTH = 1024;
	HEIGHT = 768;
	HI_RES = true;
	RETINA = false;
	IPAD = true;
	//FAKE_GAME_MODE = true;
	printf("SETTED HERE!!!!!\n\n\n\n");

	
	WIDTH_SCALE = (float)WIDTH/480.f;
	HEIGHT_SCALE = (float)HEIGHT/320.f;
	
	auto fullscreenType = OF_FULLSCREEN;
	fullscreenType = OF_WINDOW;
	ofSetupOpenGL(WIDTH, HEIGHT, fullscreenType);			// <-------- setup the GL context
#endif

	

	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp( new testApp());

	
}
