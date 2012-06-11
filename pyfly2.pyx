# -*- coding: latin-1 -*-
"""
.. module:: pflycapture2_C
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture2 C API from Point Grey Research

.. moduleauthor:: Keith Brafford
"""


error_dict = {
    FC2_ERROR_UNDEFINED :  "Undefined",
    FC2_ERROR_OK :              "Function returned with no errors.",
    FC2_ERROR_FAILED :           "General failure.",
    FC2_ERROR_NOT_IMPLEMENTED :  "Function has not been implemented.",
    FC2_ERROR_FAILED_BUS_MASTER_CONNECTION :  "Could not connect to Bus Master.",
    FC2_ERROR_NOT_CONNECTED :  "Camera has not been connected.",
    FC2_ERROR_INIT_FAILED :    "Initialization failed.",
    FC2_ERROR_NOT_INTITIALIZED :  "Camera has not been initialized.",
    FC2_ERROR_INVALID_PARAMETER :  "Invalid parameter passed to function.",
    FC2_ERROR_INVALID_SETTINGS :  "Setting set to camera is invalid.",         
    FC2_ERROR_INVALID_BUS_MANAGER :  "Invalid Bus Manager object.",
    FC2_ERROR_MEMORY_ALLOCATION_FAILED :  "Could not allocate memory.",
    FC2_ERROR_LOW_LEVEL_FAILURE :  "Low level error.",
    FC2_ERROR_NOT_FOUND :  "Device not found.",
    FC2_ERROR_FAILED_GUID :  "GUID failure.",
    FC2_ERROR_INVALID_PACKET_SIZE :      "Packet size set to camera is invalid.",
    FC2_ERROR_INVALID_MODE :      "Invalid mode has been passed to function.",
    FC2_ERROR_NOT_IN_FORMAT7 :      "Error due to not being in Format7.",
    FC2_ERROR_NOT_SUPPORTED :      "This feature is unsupported.",
    FC2_ERROR_TIMEOUT :      "Timeout error.",
    FC2_ERROR_BUS_MASTER_FAILED :      "Bus Master Failure.",
    FC2_ERROR_INVALID_GENERATION :      "Generation Count Mismatch.",
    FC2_ERROR_LUT_FAILED :      "Look Up Table failure.",
    FC2_ERROR_IIDC_FAILED :      "IIDC failure.",
    FC2_ERROR_STROBE_FAILED :      "Strobe failure.",
    FC2_ERROR_TRIGGER_FAILED :      "Trigger failure.",
    FC2_ERROR_PROPERTY_FAILED :      "Property failure.",
    FC2_ERROR_PROPERTY_NOT_PRESENT :      "Property is not present.",
    FC2_ERROR_REGISTER_FAILED :      "Register access failed.",
    FC2_ERROR_READ_REGISTER_FAILED :      "Register read failed.",
    FC2_ERROR_WRITE_REGISTER_FAILED :      "Register write failed.",
    FC2_ERROR_ISOCH_FAILED :      "Isochronous failure.",
    FC2_ERROR_ISOCH_ALREADY_STARTED :      "Isochronous transfer has already been started.",
    FC2_ERROR_ISOCH_NOT_STARTED :      "Isochronous transfer has not been started.",
    FC2_ERROR_ISOCH_START_FAILED :      "Isochronous start failed.",
    FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED :      "Isochronous retrieve buffer failed.",
    FC2_ERROR_ISOCH_STOP_FAILED :      "Isochronous stop failed.",
    FC2_ERROR_ISOCH_SYNC_FAILED :      "Isochronous image synchronization failed.",
    FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED :      "Isochronous bandwidth exceeded.",
    FC2_ERROR_IMAGE_CONVERSION_FAILED :      "Image conversion failed.",
    FC2_ERROR_IMAGE_LIBRARY_FAILURE :      "Image library failure.",
    FC2_ERROR_BUFFER_TOO_SMALL :      "Buffer is too small.",
    FC2_ERROR_IMAGE_CONSISTENCY_ERROR :      "There is an image consistency error.",
    } 

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
    """"""
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

    def __dealloc__(self):
        pass
    
    def __cinit__(self):
        pass

    def __init__(self, my_context_int, v0,v1, v2, v3):
        self._container.as_int = my_context_int
        self._context = self._container.as_void        
        self.guid.value[0] = v0
        self.guid.value[1] = v1
        self.guid.value[2] = v2
        self.guid.value[3] = v3

    def Connect(self):
        errcheck(fc2Connect(self._context, &self.guid))

    def StartCapture(self):
        errcheck(fc2StartCapture(self._context))

    def StopCapture(self):
        errcheck(fc2StopCapture(self._context))

    def GrabImageToDisk(self, filename, format="ext"):
        cdef fc2Image rawImage
        cdef fc2Image convertedImage
                       
        errcheck(fc2CreateImage( &rawImage ))
        errcheck(fc2CreateImage( &convertedImage ))        

        # Retrieve the image
        errcheck(fc2RetrieveBuffer( self._context, &rawImage ))
        
        # Convert the mage to RGB
        errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_BGR, &rawImage, &convertedImage))        
        
        # Save it
        image_format = self.image_format_map[format]
        errcheck(fc2SaveImage( &convertedImage, filename, image_format))
        
        # clean up
        errcheck(fc2DestroyImage( &rawImage ))
        errcheck(fc2DestroyImage( &convertedImage ))

    def GrabImageToMemory(self, format="BMP"):
        cdef fc2Image rawImage
        cdef fc2Image convertedImage
                
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
    
    def GrabWxBitmap(self, format = "BMP"):
        import wx        
        import cStringIO
        image = wx.ImageFromStream(cStringIO.StringIO(self.GrabImageToMemory(format)))
        return image.ConvertToBitmap()

    def GrabWxImage(self, format = "BMP"):
        import wx
        import cStringIO
        image = wx.ImageFromStream(cStringIO.StringIO(self.GrabImageToMemory(format)))
        return image

    def DemoGrabImages(self, numImagesToGrab):
        cdef fc2Image rawImage
        cdef fc2Image convertedImage
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

        errcheck(fc2CreateImage( &rawImage ))
        errcheck(fc2CreateImage( &convertedImage ))        

        # If externally allocated memory is to be used for the converted image,
        # simply assigning the pData member of the fc2Image structure is
        # insufficient. fc2SetImageData() should be called in order to populate
        # the fc2Image structure correctly. This can be done at this point,
        # assuming that the memory has already been allocated.

        for i in range(numImagesToGrab):
            # Retrieve the image
            errcheck(fc2RetrieveBuffer( self._context, &rawImage ))
            
            # Get and print out the time stamp
            ts = fc2GetImageTimeStamp( &rawImage)
            diff = (ts.cycleSeconds - prevTimestamp.cycleSeconds) * 8000 \
                        + (ts.cycleCount - prevTimestamp.cycleCount)
            prevTimestamp = ts
            print "timestamp [%d %d] - %d" % (ts.cycleSeconds, ts.cycleCount, diff)

        # Convert the final image to RGB
        errcheck(fc2ConvertImageTo(FC2_PIXEL_FORMAT_BGR, &rawImage, &convertedImage))
        
        # Save it to PNG
        print "Saving the last image to fc2TestImage.png"
        errcheck(fc2SaveImage( &convertedImage, "fc2TestImage.png", FC2_PNG ))
        errcheck(fc2DestroyImage( &rawImage ))
        errcheck(fc2DestroyImage( &convertedImage ))

    property timestamping:
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
    """"""
    cdef fc2Context _context
    cdef fc2ContextContainer _container        

    def __dealloc__(self):
        errcheck(fc2DestroyContext(self._context))

    def __cinit__(self):
        pass

    def __init__(self):
        """"""        
        errcheck(fc2CreateContext(&self._context))
        self._container.as_void = self._context
   
    def __repr__(self):
        return "pyflycapture2_C.Context object at 0x%08X" % id(self)

    property num_cameras:
        """"""
        def __get__(self):
            cdef unsigned int num_cameras
            errcheck(fc2GetNumOfCameras(self._context, &num_cameras))
            return num_cameras

    def get_camera(self, unsigned int index):   
        cdef fc2PGRGuid guid
        errcheck(fc2GetCameraFromIndex(self._context, index, &guid))        
        cdef unsigned int c = self._container.as_int
        
        return Camera(c, guid.value[0], guid.value[1], guid.value[2], guid.value[3])