/*
 *  File: depth2colormap.cpp
 *  Author: Patrick Mahoney
 *  Based on: http://stackoverflow.com/questions/18050285/why-kinect-color-and-depth-wont-align-correctly
 */

#include <windows.h>

#include "mex.h"
#include "matrix.h"
#include "NuiApi.h"    

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, 
        const mxArray *prhs[] ){

    //Check for correct input
    if( nrhs < 1 )
    {
        printf( "No depth input specified!\n" );
        mexErrMsgTxt( "Input Error" );
    }

    //Get input data
    unsigned short *depth = (unsigned short*) mxGetData(prhs[0]);
    int r = 480;
    int c = 640;

    //Find kinect device
    int iSensorCount = 0;

    int hr = NuiGetSensorCount(&iSensorCount);

    if (FAILED(hr) || iSensorCount == 0) {
        printf( "Unable to list kinect devices!\n" );
        mexErrMsgTxt( "Device Error" );
        return;
    }

    INuiSensor *sensor;
    for (int i = 0; i < iSensorCount; i++) {
         hr = NuiCreateSensorByIndex(i, &sensor);
         if (FAILED(hr)) {
             continue;
         }

         hr = sensor->NuiStatus();
         if (S_OK == hr) {
            break;
         }

         sensor->Release();
    }

    if (S_OK != hr) {
        printf( "Unable to find available to kinect device!\n" );
        mexErrMsgTxt( "Device Error" );
        return;
    }

    //Initialize device
    hr = sensor->NuiInitialize(NUI_INITIALIZE_FLAG_USES_COLOR | 
            NUI_INITIALIZE_FLAG_USES_DEPTH_AND_PLAYER_INDEX);

    if (FAILED(hr)) { 
        printf( "Unable to find initialize kinect device!\n" );
        mexErrMsgTxt( "Device Error" );
        return; 
    }

    //Compute Warping
    LONG *colorCoords = new LONG[ r*c*2 ];
    hr = sensor->NuiImageGetColorPixelCoordinateFrameFromDepthPixelFrameAtResolution(
            NUI_IMAGE_RESOLUTION_640x480, NUI_IMAGE_RESOLUTION_640x480, 
            640*480, depth, r*c*2, colorCoords );

    if (FAILED(hr)) {
        printf( "Unable to get coordinate mapping!\n" );
        mexErrMsgTxt( "Device Error" );
        return;
    }

    //Release Sensor
    sensor->NuiShutdown();
    sensor->Release();

    //Unpack data for matlab
    int dims[3] = {r, c, 2}; 
    int len = r * c;
    plhs[0] = mxCreateNumericArray( 3, dims, mxUINT16_CLASS, mxREAL );
    unsigned short *Iout = (unsigned short*)mxGetData( plhs[0] );

    for( int j = 0; j < r; j++ ) { //Row count
        for( int i= 0; i < c; i++ ){ // Column Count
            //Calculate position for a 2 * Int32 packing
            int pos = ( j*c + i )*2;
            
            //Find x and y where x is 1st packed and y 2nd
            unsigned short x = (unsigned short)colorCoords[pos];
            unsigned short y = (unsigned short)colorCoords[pos + 1];

            //Write out into matlab array format
            int idx = i*r + j;
            Iout[idx] = x;
            Iout[len + idx] = y;
        }
    }

    delete[] colorCoords;
}