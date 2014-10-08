METR4202_Lab2
=============
NOTE v5.m is main

GLASS HALF FULL
A program useful for hospitality environments, using the XBox 360 Kinect to determine:
 - What type of cups are on a table (both cups and glasses)
 - Where the cups are placed on the table
 - How full these cups are (does the customer require a refill?)
 - For clean up, what orientation the cups placed?

INSTALLATION
This program runs using the XBox 360 Kinect device.

This program runs through Matlab 2014. The download link can be found below:
http://www.mathworks.com.au/products/matlab/
Please ensure that the Image Acquisition Toolbox is installed along with the Matlab program.

Download and install the Kinect For Windows SDK V1.8:
http://www.microsoft.com/en-au/download/details.aspx?id=40278

Download the Kinect IMAQ Adapter and unzip the files to a permanent directory:
http://robotics.itee.uq.edu.au/~metr4202/kinect/kinectimaq.zip

In Matlab, use the 'imaqregister' command to install the adapter, ie.
	>> imaqregister(’H:/example/kinectimaq/mwkinectimaq.dll’)
		ans =
			’H:/example/kinectimaq/mwkinectimaq.dll’
To test if this installation succeeded, run the imaqhwinfo function:
(for example)
	>> imaqhwinfo
	
		ans =
			InstalledAdaptors: {’mwkinectimaq’}
			MATLABVersion: ’8.3 (R2014a)’
			ToolboxName: ’Image Acquisition Toolbox’
			ToolboxVersion: ’4.7 (R2014a)’


Information for the adapter can be shown by using imaqhwinfo('mwkinectimaq').
For information about each of the connected devices, select the device from the 'imaqhwinfo' function.

Further documentation on how to interact with the kinect through the IMAQ Adapter can be found in the Matlab documentation:
http://www.mathworks.com.au/help/imaq/examples/using-the-kinect-r-for-windows-r-from-image-acquisitions-toolbox-tm.html


USAGE
To run the program, download all files into a permanent directory.
Add this directory to your Matlab path (include all folders and subfolders).
Do not do METR4202.
