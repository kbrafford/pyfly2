# -*- coding: latin-1 -*-
"""
.. module:: pyfly2
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture2 C API from Point Grey Research

.. moduleauthor:: Keith Brafford,

Some modifications Matt Newville
"""

from PIL import Image
import numpy as np
import wx
import cStringIO

error_dict = {
    FC2_ERROR_UNDEFINED                    :  "Undefined",
    FC2_ERROR_OK                           :  "Function returned with no errors.",
    FC2_ERROR_FAILED                       :  "General failure.",
    FC2_ERROR_NOT_IMPLEMENTED              :  "Function has not been implemented.",
    FC2_ERROR_FAILED_BUS_MASTER_CONNECTION :  "Could not connect to Bus Master.",
    FC2_ERROR_NOT_CONNECTED                :  "Camera has not been connected.",
    FC2_ERROR_INIT_FAILED                  :  "Initialization failed.",
    FC2_ERROR_NOT_INTITIALIZED             :  "Camera has not been initialized.",
    FC2_ERROR_INVALID_PARAMETER            :  "Invalid parameter passed to function.",
    FC2_ERROR_INVALID_SETTINGS             :  "Setting set to camera is invalid.",
    FC2_ERROR_INVALID_BUS_MANAGER          :  "Invalid Bus Manager object.",
    FC2_ERROR_MEMORY_ALLOCATION_FAILED     :  "Could not allocate memory.",
    FC2_ERROR_LOW_LEVEL_FAILURE            :  "Low level error.",
    FC2_ERROR_NOT_FOUND                    :  "Device not found.",
    FC2_ERROR_FAILED_GUID                  :  "GUID failure.",
    FC2_ERROR_INVALID_PACKET_SIZE          :  "Packet size set to camera is invalid.",
    FC2_ERROR_INVALID_MODE                 :  "Invalid mode has been passed to function.",
    FC2_ERROR_NOT_IN_FORMAT7               :  "Error due to not being in Format7.",
    FC2_ERROR_NOT_SUPPORTED                :  "This feature is unsupported.",
    FC2_ERROR_TIMEOUT                      :  "Timeout error.",
    FC2_ERROR_BUS_MASTER_FAILED            :  "Bus Master Failure.",
    FC2_ERROR_INVALID_GENERATION           :  "Generation Count Mismatch.",
    FC2_ERROR_LUT_FAILED                   :  "Look Up Table failure.",
    FC2_ERROR_IIDC_FAILED                  :  "IIDC failure.",
    FC2_ERROR_STROBE_FAILED                :  "Strobe failure.",
    FC2_ERROR_TRIGGER_FAILED               :  "Trigger failure.",
    FC2_ERROR_PROPERTY_FAILED              :  "Property failure.",
    FC2_ERROR_PROPERTY_NOT_PRESENT         :  "Property is not present.",
    FC2_ERROR_REGISTER_FAILED              :  "Register access failed.",
    FC2_ERROR_READ_REGISTER_FAILED         :  "Register read failed.",
    FC2_ERROR_WRITE_REGISTER_FAILED        :  "Register write failed.",
    FC2_ERROR_ISOCH_FAILED                 :  "Isochronous failure.",
    FC2_ERROR_ISOCH_ALREADY_STARTED        :  "Isochronous transfer has already been started.",
    FC2_ERROR_ISOCH_NOT_STARTED            :  "Isochronous transfer has not been started.",
    FC2_ERROR_ISOCH_START_FAILED           :  "Isochronous start failed.",
    FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED :  "Isochronous retrieve buffer failed.",
    FC2_ERROR_ISOCH_STOP_FAILED            :  "Isochronous stop failed.",
    FC2_ERROR_ISOCH_SYNC_FAILED            :  "Isochronous image synchronization failed.",
    FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED     :  "Isochronous bandwidth exceeded.",
    FC2_ERROR_IMAGE_CONVERSION_FAILED      :  "Image conversion failed.",
    FC2_ERROR_IMAGE_LIBRARY_FAILURE        :  "Image library failure.",
    FC2_ERROR_BUFFER_TOO_SMALL             :  "Buffer is too small.",
    FC2_ERROR_IMAGE_CONSISTENCY_ERROR      :  "There is an image consistency error.",
    }

class FCVideoMode(object):
    """Enum describing different video modes."""
    _160x120YUV444     = 0
    _320x240YUV422     = 1
    _640x480YUV411     = 2
    _640x480YUV422     = 3
    _640x480RGB        = 4
    _640x480Y8         = 5
    _640x480Y16        = 6
    _800x600YUV422     = 7
    _800x600RGB        = 8
    _800x600Y8         = 9
    _800x600Y16        = 10
    _1024x768YUV422    = 11
    _1024x768RGB       = 12
    _1024x768Y8        = 13
    _1024x768Y16       = 14
    _1280x960YUV422    = 15
    _1280x960RGB       = 16
    _1280x960Y8        = 17
    _1280x960Y16       = 18
    _1600x1200YUV422   = 19
    _1600x1200RGB      = 20
    _1600x1200Y8       = 21
    _1600x1200Y16      = 22
    _FORMAT7           = 23
    _NUM_VIDEOMODES    = 24
    _FORCE_32BITS      = 0x7FFFFFFF

class FCFrameRate(object):
    """Enum describing different framerates."""
    _1_875           = 0
    _3_75            = 1
    _7_5             = 2
    _15              = 3
    _30              = 4
    _60              = 5
    _120             = 6
    _240             = 7
    _FORMAT7         = 8
    _NUM_FRAMERATES  = 9
    _FORCE_32BITS    = 0x7FFFFFFF

class FCColorProcessingAlgorithm(object):
    _DEFAULT               = 0
    _NO_COLOR_PROCESSING   = 1
    _NEAREST_NEIGHBOR_FAST = 2
    _EDGE_SENSING          = 3
    _HQ_LINEAR             = 4
    _RIGOROUS              = 5
    _IPP                   = 6
    _DIRECTIONAL           = 7
    _FORCE_32BITS          = 0x7FFFFFFF

ctypedef union fc2ContextContainer:
    fc2Context   as_void
    unsigned int as_int

class FC2Error(Exception):
    """Exception wrapper for errors returned from underlying FlyCapture2 calls"""
    def __init__(self, errorcode):
        self.errorcode = errorcode

    def __str__(self):
        error_desc = error_dict.get(self.errorcode)
        return repr(error_desc)

cdef inline bint errcheck(fc2Error result) except True:
    cdef bint is_error = (result != FC2_ERROR_OK)
    if is_error:
        raise FC2Error(result)
    return is_error

_PROPERTIES = dict(brightness = FC2_BRIGHTNESS,
                   sharpness  = FC2_SHARPNESS,
                   hue = FC2_HUE,
                   saturation = FC2_SATURATION,
                   gamma = FC2_GAMMA,
                   shutter = FC2_SHUTTER,
                   gain = FC2_GAIN,
                   white_balance = FC2_WHITE_BALANCE)

def library_version():
    """returns the version of the underlying FlyCapture2 library

    Parameters
    ----------
        None

    Returns
    -------
        out : tuple
            the major, minor, type and build level of the FlyCapture 2 library

    Raises
    ------
    FC2Error
            An error occurred accessing the fc2GetLibraryVersion function

    Notes
    -----
        The underlying Point Grey call is 'fc2GetLibraryVersion'

    Examples
    --------
    >>> import pyflycapture2_C
    >>> print pyflycapture2_C.library_version()
    (2L, 3L, 2L, 14L)
    """

    cdef fc2Version v
    errcheck(fc2GetLibraryVersion(&v))
    return (v.major, v.minor, v.type, v.build)

cdef class Camera(object):
    """Camera object"""
    image_format_map = {
                       "ext"       :  FC2_FROM_FILE_EXT,
                       "PGM"       :  FC2_PGM,
                       "PPM"       :  FC2_PPM,
                       "BMP"       :  FC2_BMP,
                       "JPEG"      :  FC2_JPEG,
                       "JPEG2000"  :  FC2_JPEG2000,
                       "TIFF"      :  FC2_TIFF,
                       "PNG"       :  FC2_PNG,
                       "RAW"       :  FC2_RAW,
                      }

    cdef fc2PGRGuid guid
    cdef fc2Context _context
    cdef fc2ContextContainer _container
    cdef fc2Image rawImage
    cdef fc2Image rgbImage

    def __dealloc__(self):
        pass

    def __cinit__(self):
        pass

    def __init__(self, my_context_int, v0,v1, v2, v3):
        """"""
        self._container.as_int = my_context_int
        self._context = self._container.as_void
        self.guid.value[0] = v0
        self.guid.value[1] = v1
        self.guid.value[2] = v2
        self.guid.value[3] = v3

        errcheck(fc2CreateImage( &self.rawImage ))
        errcheck(fc2CreateImage( &self.rgbImage ))

    def Connect(self):
        """"""
        errcheck(fc2Connect(self._context, &self.guid))

    def StartCapture(self):
        """"""
        errcheck(fc2StartCapture(self._context))

    def StopCapture(self):
        """"""
        errcheck(fc2StopCapture(self._context))

    def GetProperty(self, name):
        cdef fc2Property p
        if name not in _PROPERTIES:
            return None
        p.type = _PROPERTIES[name]
        errcheck( fc2GetProperty(self._context, &p))
        return {"type": p.type,
                "present": bool(p.present),
                "autoManualMode": bool(p.autoManualMode),
                "absControl": bool(p.absControl),
                "onOff": bool(p.onOff),
                "onePush": bool(p.onePush),
                "absValue": p.absValue,
                "valueA": p.valueA,
                "valueB": p.valueB}


    def SetPropertyValue(self, name, value, auto=False, absolute=True):
        """Set Value for property.  Supports setting the properties
        'brightness', 'sharpness', 'hue', 'saturation', 'gamma', 
        'shutter', 'gain', and 'white_balance' (see note below).

        Arguments
        ---------
        name       property name ('gamma', 'gain', 'shutter', ...)
        value      value for property
        absolute   whether value is absolute (physical units) default=True
        auto       whether to set autoManualMode              default=False

        Example
        -------
             context = pyfly2.Context()
             camera  = context.get_camera(0)
             camera.Connect()
             camera.SetProperty('gain', 2.0)

        Notes
        ------
           The 'white_balance' property takes a two-element tuple for values
           for red- and blue-white balance.  Absolute control is forced to be 
           False.  To set the white balance, use something like
           
             camera.SetProperty('white_balance', (550, 800))
        """
        cdef fc2Property p
        if name not in _PROPERTIES:
            return None
        p.type = _PROPERTIES[name]
        errcheck( fc2GetProperty(self._context, &p))
        p.onOff = True
        p.autoManualMode = auto

        if p.type == FC2_WHITE_BALANCE:
            p.valueA = value[0]
            p.valueB = value[1]
            p.absValue = 0.0
            p.absControl = False
        else:
            p.absValue = value
            p.absControl = absolute
        errcheck( fc2SetProperty(self._context, &p))


    def GrabImageToDisk(self, filename, format="ext"):
        """"""
        # Retrieve the image
        errcheck(fc2RetrieveBuffer( self._context, &self.rawImage ))

        # Convert the mage to RGB
        errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_RGB, &self.rawImage, &self.rgbImage))

        # Save it
        image_format = self.image_format_map[format]
        errcheck(fc2SaveImage( &self.rgbImage, filename, image_format))

    def GetSize(self):
        """returns image size
        """
        errcheck(fc2RetrieveBuffer(self._context, &self.rawImage))
        return (self.rawImage.cols, self.rawImage.rows)

    def GrabNumPyImage(self, format='bgr'):
        """return an image as a NumPy array
        optionally specifying color
        """
        errcheck(fc2RetrieveBuffer(self._context, &self.rawImage))
        ncols, nrows = self.rawImage.cols, self.rawImage.rows
        size = ncols * nrows
        if format == 'bgr':
            errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_BGR,
                                       &self.rawImage, &self.rgbImage))
            bytes = bytearray(self.rgbImage.pData[:3*size])
            img = np.array(bytes).reshape(nrows, ncols, 3)
        elif format == 'rgb':
            errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_RGB8,
                                       &self.rawImage, &self.rgbImage))
            bytes = bytearray(self.rgbImage.pData[:3*size])
            img = np.array(bytes).reshape(nrows, ncols, 3)
        elif format == 'gray':
            errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_MONO8,
                                       &self.rawImage, &self.rgbImage))
            bytes = bytearray(self.rgbImage.pData[:size])
            img = np.array(bytes).reshape(nrows, ncols)
        else:
            raise ValueError("Invalid argument: format='%s'. Expected 'bgr', 'rgb', or 'gray'." % format)
        return img

    def GrabWxImage(self, scale=1.00, rgb=True):
        """returns a wximage
        optionally specifying scale and color
        """
        errcheck(fc2RetrieveBuffer(self._context, &self.rawImage))
        ncols, nrows = self.rawImage.cols, self.rawImage.rows
        size = ncols *nrows
        if rgb:
            errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_RGB8,
                                       &self.rawImage, &self.rgbImage))
            img = wx.ImageFromData(ncols, nrows, self.rgbImage.pData[:3*size])
        else:
            img = wx.ImageFromData(ncols, nrows, self.rawImage.pData[:size])

        scale = max(scale, 0.05)
        return img.Scale(int(scale*ncols), int(scale*nrows))

    def GrabPILImage(self):
        """"""
        # We import PIL here so that PIL is only a requirement if you need PIL

        # Retrieve the image
        errcheck(fc2RetrieveBuffer( self._context, &self.rawImage ))

        # calculate the size (in bytes) of the image
        width, height = self.rawImage.cols, self.rawImage.rows
        size = width * height

        # perform the creation of the PIL Image
        return Image.frombytes('L', (width, height), self.rawImage.pData[0:size])

    def GrabImageToMemory(self, format="BMP"):
        """This is a really bad way to do this.  Fix later."""
        if format == "ext":
            raise TypeError("specifying image format by file extension makes no sense here")

        import tempfile
        import os
        import shutil
        tempdir = tempfile.mkdtemp(prefix = "pfc")
        tempfilename = os.path.join(tempdir, "image." + format)

        self.GrabImageToDisk(tempfilename)

        # read in the image
        with open(tempfilename,"rb") as fp:
            imagedata = fp.read()

        # now clean up the tempdir stuff
        shutil.rmtree(tempdir)
        return imagedata

    def DemoGrabImages(self, numImagesToGrab):
        """Hey"""
        cdef fc2TimeStamp prevTimestamp
        cdef fc2TimeStamp ts
        cdef int diff

        prevTimestamp.seconds = 0
        prevTimestamp.microSeconds = 0
        prevTimestamp.cycleSeconds = 0
        prevTimestamp.cycleCount = 0
        prevTimestamp.cycleOffset = 0
        for i in range(8):
            prevTimestamp.reserved[i] = 0


        # If externally allocated memory is to be used for the converted image,
        # simply assigning the pData member of the fc2Image structure is
        # insufficient. fc2SetImageData() should be called in order to populate
        # the fc2Image structure correctly. This can be done at this point,
        # assuming that the memory has already been allocated.

        for i in range(numImagesToGrab):
            # Retrieve the image
            errcheck(fc2RetrieveBuffer( self._context, &self.rawImage ))

            # Get and print out the time stamp
            ts = fc2GetImageTimeStamp( &self.rawImage)
            diff = (ts.cycleSeconds - prevTimestamp.cycleSeconds) * 8000 \
                        + (ts.cycleCount - prevTimestamp.cycleCount)
            prevTimestamp = ts
            # print "timestamp [%d %d] - %d" % (ts.cycleSeconds, ts.cycleCount, diff)

        # Convert the final image to RGB
        errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_BGR, &self.rawImage, &self.rgbImage))

        # Save it to PNG
        # print "Saving the last image to fc2TestImage.png"
        errcheck(fc2SaveImage( &self.rgbImage, "fc2TestImage.png", FC2_PNG ))

    property timestamping:
        """timestamping property"""
        def __get__(self):
            cdef fc2EmbeddedImageInfo embeddedInfo
            errcheck(fc2GetEmbeddedImageInfo(self._context, &embeddedInfo))
            return embeddedInfo.available and embeddedInfo.timestamp.onOff

        def __set__(self, enableTimeStamp):
            cdef fc2EmbeddedImageInfo embeddedInfo
            errcheck(fc2GetEmbeddedImageInfo(self._context, &embeddedInfo))
            if embeddedInfo.timestamp.available:
                embeddedInfo.timestamp.onOff = enableTimeStamp
            errcheck(fc2SetEmbeddedImageInfo(self._context, &embeddedInfo))

    property gain:
        """gain property"""
        def __get__(self):
            cdef fc2EmbeddedImageInfo embeddedInfo
            errcheck(fc2GetEmbeddedImageInfo(self._context, &embeddedInfo))
            return embeddedInfo.available and embeddedInfo.timestamp.onOff

        def __set__(self, enableTimeStamp):
            cdef fc2EmbeddedImageInfo embeddedInfo
            errcheck(fc2GetEmbeddedImageInfo(self._context, &embeddedInfo))
            if embeddedInfo.timestamp.available:
                embeddedInfo.timestamp.onOff = enableTimeStamp
            errcheck(fc2SetEmbeddedImageInfo(self._context, &embeddedInfo))

    property info:
        """Camera information property"""
        def __get__(self):
            cdef fc2CameraInfo camInfo
            errcheck(fc2GetCameraInfo(self._context, &camInfo))
            return {
                      "serialNumber"       : camInfo.serialNumber,
                      "modelName"          : camInfo.modelName,
                      "vendorName"         : camInfo.vendorName,
                      "sensorInfo"         : camInfo.sensorInfo,
                      "sensorResolution"   : camInfo.sensorResolution,
                      "firmwareVersion"    : camInfo.firmwareVersion,
                      "firmwareBuildTime"  : camInfo.firmwareBuildTime,
                    }

cdef class Context(object):
    """Hey"""
    cdef fc2Context _context
    cdef fc2ContextContainer _container

    def __dealloc__(self):
        errcheck(fc2DestroyContext(self._context))

    def __cinit__(self):
        pass

    def __init__(self):
        """Hey"""
        errcheck(fc2CreateContext(&self._context))
        self._container.as_void = self._context

    def __repr__(self):
        return "pyfly2.Context object at 0x%08X" % id(self)

    property num_cameras:
        """Returns the number of cameras connected to the host"""
        def __get__(self):
            cdef unsigned int num_cameras
            errcheck(fc2GetNumOfCameras(self._context, &num_cameras))
            return num_cameras

    def get_camera(self, unsigned int index):
        """get camera by index.  works differently from flycap 1 api"""
        cdef fc2PGRGuid guid
        errcheck(fc2GetCameraFromIndex(self._context, index, &guid))
        cdef unsigned int c = self._container.as_int
        return Camera(c, guid.value[0], guid.value[1], guid.value[2], guid.value[3])

    def get_mode(self):
        """Get video mode and frame rate."""
        cdef fc2VideoMode videoMode
        cdef fc2FrameRate frameRate
        errcheck(fc2GetVideoModeAndFrameRate(self._context, &videoMode, &frameRate))
        return videoMode, frameRate

    def set_mode(self, videoMode, frameRate):
        """Set video mode and frame rate."""
        cdef fc2VideoMode cVideoMode = videoMode
        cdef fc2FrameRate cFrameRate = frameRate
        errcheck(fc2SetVideoModeAndFrameRate(self._context, cVideoMode, cFrameRate))
