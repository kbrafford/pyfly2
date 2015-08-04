
cdef extern from "C/FlyCapture2_C.h":
    ctypedef void* fc2Context
    ctypedef void* fc2GuiContext
    ctypedef void* fc2ImageImpl
    ctypedef void* fc2AVIContext
    ctypedef void* fc2ImageStatisticsContext

    ctypedef enum fc2Error:
        FC2_ERROR_UNDEFINED = -1
        FC2_ERROR_OK
        FC2_ERROR_FAILED
        FC2_ERROR_NOT_IMPLEMENTED
        FC2_ERROR_FAILED_BUS_MASTER_CONNECTION
        FC2_ERROR_NOT_CONNECTED
        FC2_ERROR_INIT_FAILED
        FC2_ERROR_NOT_INTITIALIZED
        FC2_ERROR_INVALID_PARAMETER
        FC2_ERROR_INVALID_SETTINGS
        FC2_ERROR_INVALID_BUS_MANAGER
        FC2_ERROR_INVALID_BUS_MANAGER
        FC2_ERROR_MEMORY_ALLOCATION_FAILED
        FC2_ERROR_LOW_LEVEL_FAILURE
        FC2_ERROR_NOT_FOUND
        FC2_ERROR_FAILED_GUID
        FC2_ERROR_INVALID_PACKET_SIZE
        FC2_ERROR_INVALID_MODE
        FC2_ERROR_NOT_IN_FORMAT7
        FC2_ERROR_NOT_SUPPORTED
        FC2_ERROR_TIMEOUT
        FC2_ERROR_BUS_MASTER_FAILED
        FC2_ERROR_INVALID_GENERATION
        FC2_ERROR_LUT_FAILED
        FC2_ERROR_IIDC_FAILED
        FC2_ERROR_STROBE_FAILED
        FC2_ERROR_TRIGGER_FAILED
        FC2_ERROR_PROPERTY_FAILED
        FC2_ERROR_PROPERTY_NOT_PRESENT
        FC2_ERROR_REGISTER_FAILED
        FC2_ERROR_READ_REGISTER_FAILED
        FC2_ERROR_WRITE_REGISTER_FAILED
        FC2_ERROR_ISOCH_FAILED
        FC2_ERROR_ISOCH_ALREADY_STARTED
        FC2_ERROR_ISOCH_NOT_STARTED
        FC2_ERROR_ISOCH_START_FAILED
        FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED
        FC2_ERROR_ISOCH_STOP_FAILED
        FC2_ERROR_ISOCH_SYNC_FAILED
        FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED
        FC2_ERROR_IMAGE_CONVERSION_FAILED
        FC2_ERROR_IMAGE_LIBRARY_FAILURE
        FC2_ERROR_BUFFER_TOO_SMALL
        FC2_ERROR_IMAGE_CONSISTENCY_ERROR
        FC2_ERROR_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2BusCallbackType:
        FC2_BUS_RESET
        FC2_ARRIVAL
        FC2_REMOVAL
        FC2_CALLBACK_TYPE_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2GrabMode:
        FC2_DROP_FRAMES
        FC2_BUFFER_FRAMES
        FC2_UNSPECIFIED_GRAB_MODE
        FC2_GRAB_MODE_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2GrabTimeout:
        FC2_TIMEOUT_NONE = 0
        FC2_TIMEOUT_INFINITE = -1
        FC2_TIMEOUT_UNSPECIFIED = -2
        FC2_GRAB_TIMEOUT_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2BandwidthAllocation:
        FC2_BANDWIDTH_ALLOCATION_OFF = 0
        FC2_BANDWIDTH_ALLOCATION_ON = 1
        FC2_BANDWIDTH_ALLOCATION_UNSUPPORTED = 2
        FC2_BANDWIDTH_ALLOCATION_UNSPECIFIED = 3
        FC2_BANDWIDTH_ALLOCATION_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2InterfaceType:
        FC2_INTERFACE_IEEE1394
        FC2_INTERFACE_USB_2
        FC2_INTERFACE_USB_3
        FC2_INTERFACE_GIGE
        FC2_INTERFACE_UNKNOWN
        FC2_INTERFACE_TYPE_FORCE_32BITS = 0x7FFFFFFF


    ctypedef enum fc2DriverType:
        FC2_DRIVER_1394_CAM
        FC2_DRIVER_1394_PRO
        FC2_DRIVER_1394_JUJU
        FC2_DRIVER_1394_VIDEO1394
        FC2_DRIVER_1394_RAW1394
        FC2_DRIVER_USB_NONE
        FC2_DRIVER_USB_CAM
        FC2_DRIVER_USB3_PRO
        FC2_DRIVER_GIGE_NONE
        FC2_DRIVER_GIGE_FILTER
        FC2_DRIVER_GIGE_PRO
        FC2_DRIVER_UNKNOWN = -1
        FC2_DRIVER_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2PropertyType:
        FC2_BRIGHTNESS
        FC2_AUTO_EXPOSURE
        FC2_SHARPNESS
        FC2_WHITE_BALANCE
        FC2_HUE
        FC2_SATURATION
        FC2_GAMMA
        FC2_IRIS
        FC2_FOCUS
        FC2_ZOOM
        FC2_PAN
        FC2_TILT
        FC2_SHUTTER
        FC2_GAIN
        FC2_TRIGGER_MODE
        FC2_TRIGGER_DELAY
        FC2_FRAME_RATE
        FC2_TEMPERATURE
        FC2_UNSPECIFIED_PROPERTY_TYPE
        FC2_PROPERTY_TYPE_FORCE_32BITS = 0x7FFFFFFF


    ctypedef enum fc2FrameRate:
        FC2_FRAMERATE_1_875
        FC2_FRAMERATE_3_75
        FC2_FRAMERATE_7_5
        FC2_FRAMERATE_15
        FC2_FRAMERATE_30
        FC2_FRAMERATE_60
        FC2_FRAMERATE_120
        FC2_FRAMERATE_240
        FC2_FRAMERATE_FORMAT7
        FC2_NUM_FRAMERATES
        FC2_FRAMERATE_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2VideoMode:
        FC2_VIDEOMODE_160x120YUV444
        FC2_VIDEOMODE_320x240YUV422
        FC2_VIDEOMODE_640x480YUV411
        FC2_VIDEOMODE_640x480YUV422
        FC2_VIDEOMODE_640x480RGB
        FC2_VIDEOMODE_640x480Y8
        FC2_VIDEOMODE_640x480Y16
        FC2_VIDEOMODE_800x600YUV422
        FC2_VIDEOMODE_800x600RGB
        FC2_VIDEOMODE_800x600Y8
        FC2_VIDEOMODE_800x600Y16
        FC2_VIDEOMODE_1024x768YUV422
        FC2_VIDEOMODE_1024x768RGB
        FC2_VIDEOMODE_1024x768Y8
        FC2_VIDEOMODE_1024x768Y16
        FC2_VIDEOMODE_1280x960YUV422
        FC2_VIDEOMODE_1280x960RGB
        FC2_VIDEOMODE_1280x960Y8
        FC2_VIDEOMODE_1280x960Y16
        FC2_VIDEOMODE_1600x1200YUV422
        FC2_VIDEOMODE_1600x1200RGB
        FC2_VIDEOMODE_1600x1200Y8
        FC2_VIDEOMODE_1600x1200Y16
        FC2_VIDEOMODE_FORMAT7
        FC2_NUM_VIDEOMODES
        FC2_VIDEOMODE_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2Mode:
        FC2_MODE_0 = 0
        FC2_MODE_1
        FC2_MODE_2
        FC2_MODE_3
        FC2_MODE_4
        FC2_MODE_5
        FC2_MODE_6
        FC2_MODE_7
        FC2_MODE_8
        FC2_MODE_9
        FC2_MODE_10
        FC2_MODE_11
        FC2_MODE_12
        FC2_MODE_13
        FC2_MODE_14
        FC2_MODE_15
        FC2_MODE_16
        FC2_MODE_17
        FC2_MODE_18
        FC2_MODE_19
        FC2_MODE_20
        FC2_MODE_21
        FC2_MODE_22
        FC2_MODE_23
        FC2_MODE_24
        FC2_MODE_25
        FC2_MODE_26
        FC2_MODE_27
        FC2_MODE_28
        FC2_MODE_29
        FC2_MODE_30
        FC2_MODE_31
        FC2_NUM_MODES
        FC2_MODE_FORCE_32BITS = 0x7FFFFFFF


    ctypedef enum fc2PixelFormat:
        FC2_PIXEL_FORMAT_MONO8			= 0x80000000 
        FC2_PIXEL_FORMAT_411YUV8		= 0x40000000 
        FC2_PIXEL_FORMAT_422YUV8		= 0x20000000 
        FC2_PIXEL_FORMAT_444YUV8		= 0x10000000 
        FC2_PIXEL_FORMAT_RGB8			= 0x08000000 
        FC2_PIXEL_FORMAT_MONO16			= 0x04000000 
        FC2_PIXEL_FORMAT_RGB16			= 0x02000000 
        FC2_PIXEL_FORMAT_S_MONO16		= 0x01000000 
        FC2_PIXEL_FORMAT_S_RGB16		= 0x00800000 
        FC2_PIXEL_FORMAT_RAW8			= 0x00400000 
        FC2_PIXEL_FORMAT_RAW16			= 0x00200000 
        FC2_PIXEL_FORMAT_MONO12			= 0x00100000 
        FC2_PIXEL_FORMAT_RAW12			= 0x00080000 
        FC2_PIXEL_FORMAT_BGR			= 0x80000008 
        FC2_PIXEL_FORMAT_BGRU			= 0x40000008 
        FC2_PIXEL_FORMAT_RGB			= FC2_PIXEL_FORMAT_RGB8
        FC2_PIXEL_FORMAT_RGBU			= 0x40000002
        FC2_PIXEL_FORMAT_BGR16			= 0x02000001
        FC2_PIXEL_FORMAT_BGRU16			= 0x02000002
        FC2_PIXEL_FORMAT_422YUV8_JPEG	= 0x40000001
        FC2_NUM_PIXEL_FORMATS			=  20 
        FC2_UNSPECIFIED_PIXEL_FORMAT	= 0 


    ctypedef enum fc2BusSpeed:
        FC2_BUSSPEED_S100 
        FC2_BUSSPEED_S200 
        FC2_BUSSPEED_S400 
        FC2_BUSSPEED_S480 
        FC2_BUSSPEED_S800 
        FC2_BUSSPEED_S1600 
        FC2_BUSSPEED_S3200 
        FC2_BUSSPEED_S5000 
        FC2_BUSSPEED_10BASE_T
        FC2_BUSSPEED_100BASE_T 
        FC2_BUSSPEED_1000BASE_T 
        FC2_BUSSPEED_10000BASE_T 
        FC2_BUSSPEED_S_FASTEST 
        FC2_BUSSPEED_ANY
        FC2_BUSSPEED_SPEED_UNKNOWN = -1 
        FC2_BUSSPEED_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2PCIeBusSpeed:
        FC2_PCIE_BUSSPEED_2_5
        FC2_PCIE_BUSSPEED_5_0
        FC2_PCIE_BUSSPEED_UNKNOWN = -1
        FC2_PCIE_BUSSPEED_FORCE_32BITS = 0x7FFFFFFF


    ctypedef enum fc2ColorProcessingAlgorithm:
        FC2_DEFAULT
        FC2_NO_COLOR_PROCESSING
        FC2_NEAREST_NEIGHBOR_FAST
        FC2_EDGE_SENSING
        FC2_HQ_LINEAR
        FC2_RIGOROUS
        FC2_IPP
        FC2_DIRECTIONAL
        FC2_COLOR_PROCESSING_ALGORITHM_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2BayerTileFormat:
        FC2_BT_NONE
        FC2_BT_RGGB
        FC2_BT_GRBG
        FC2_BT_GBRG
        FC2_BT_BGGR
        FC2_BT_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2ImageFileFormat:
        FC2_FROM_FILE_EXT = -1
        FC2_PGM
        FC2_PPM
        FC2_BMP
        FC2_JPEG
        FC2_JPEG2000
        FC2_TIFF
        FC2_PNG
        FC2_RAW
        FC2_IMAGE_FILE_FORMAT_FORCE_32BITS = 0x7FFFFFFF

    ctypedef enum fc2GigEPropertyType:
        FC2_HEARTBEAT
        FC2_HEARTBEAT_TIMEOUT

    ctypedef enum fc2StatisticsChannel:
        FC2_STATISTICS_GREY
        FC2_STATISTICS_RED
        FC2_STATISTICS_GREEN
        FC2_STATISTICS_BLUE
        FC2_STATISTICS_HUE
        FC2_STATISTICS_SATURATION
        FC2_STATISTICS_LIGHTNESS
        FC2_STATISTICS_FORCE_32BITS = 0x7FFFFFFF
   

    ctypedef enum fc2OSType:
        FC2_WINDOWS_X86
        FC2_WINDOWS_X64
        FC2_LINUX_X86
        FC2_LINUX_X64
        FC2_MAC
        FC2_UNKNOWN_OS
        FC2_OSTYPE_FORCE_32BITS = 0x7FFFFFFF


    ctypedef enum fc2ByteOrder:
        FC2_BYTE_ORDER_LITTLE_ENDIAN
        FC2_BYTE_ORDER_BIG_ENDIAN
        FC2_BYTE_ORDER_FORCE_32BITS = 0x7FFFFFFF

    ctypedef struct fc2Format7PacketInfo:
        unsigned int recommendedBytesPerPacket
        unsigned int maxBytesPerPacket
        unsigned int unitBytesPerPacket
        unsigned int reserved[8]

    ctypedef struct fc2IPAddress:
        unsigned char octets[4]

    ctypedef struct fc2MACAddress:
        unsigned char octets[6]

    ctypedef struct fc2ConfigROM:
        unsigned int nodeVendorId
        unsigned int chipIdHi
        unsigned int chipIdLo
        unsigned int unitSpecId
        unsigned int unitSWVer
        unsigned int unitSubSWVer
        unsigned int vendorUniqueInfo0
        unsigned int vendorUniqueInfo1
        unsigned int vendorUniqueInfo2
        unsigned int vendorUniqueInfo3
        char pszKeyword[ 512 ]
        unsigned int reserved[16]
               
    ctypedef struct fc2CameraInfo:      
        unsigned int serialNumber
        fc2InterfaceType interfaceType
        fc2DriverType driverType
        bint isColorCamera
        char modelName[ 512]
        char vendorName[ 512]
        char sensorInfo[ 512]
        char sensorResolution[ 512]
        char driverName[ 512]
        char firmwareVersion[ 512]
        char firmwareBuildTime[ 512]
        fc2BusSpeed maximumBusSpeed
        fc2PCIeBusSpeed pcieBusSpeed
        fc2BayerTileFormat bayerTileFormat
        unsigned short busNumber
        unsigned short nodeNumber
        unsigned int iidcVer
        fc2ConfigROM configROM
        unsigned int gigEMajorVersion
        unsigned int gigEMinorVersion
        char userDefinedName[ 512]
        char xmlURL1[ 512]
        char xmlURL2[ 512]
        fc2MACAddress macAddress
        fc2IPAddress ipAddress
        fc2IPAddress subnetMask
        fc2IPAddress defaultGateway
        unsigned int reserved[16]

    ctypedef struct fc2Image:
        unsigned int rows
        unsigned int cols
        unsigned int stride
        unsigned char* pData
        unsigned int dataSize
        unsigned int receivedDataSize
        fc2PixelFormat format
        fc2BayerTileFormat bayerFormat
        fc2ImageImpl imageImpl

    ctypedef struct fc2SystemInfo:
        fc2OSType osType
        char osDescription[ 512]
        fc2ByteOrder byteOrder
        size_t	sysMemSize
        char cpuDescription[ 512]
        size_t	numCpuCores
        char driverList[ 512]
        char libraryList[ 512]
        char gpuDescription[ 512]
        size_t screenWidth
        size_t screenHeight
        unsigned int reserved[16]

    ctypedef struct fc2Version:
        unsigned int major
        unsigned int minor
        unsigned int type
        unsigned int build


    ctypedef struct fc2Config:
        unsigned int numBuffers
        unsigned int numImageNotifications
        unsigned int minNumImageNotifications
        int grabTimeout
        fc2GrabMode grabMode 
        fc2BusSpeed isochBusSpeed
        fc2BusSpeed asyncBusSpeed
        fc2BandwidthAllocation bandwidthAllocation
        unsigned int registerTimeoutRetries
        unsigned int registerTimeout
        unsigned int reserved[16]

    ctypedef struct fc2PropertyInfo:
        fc2PropertyType type
        bint present
        bint autoSupported
        bint manualSupported
        bint onOffSupported
        bint onePushSupported
        bint absValSupported
        bint readOutSupported
        unsigned int min
        unsigned int max
        float absMin
        float absMax
        char pUnits[512]
        char pUnitAbbr[512]
        unsigned int reserved[8]
        
    ctypedef struct fc2TriggerDelayInfo:
        fc2PropertyType type
        bint present
        bint autoSupported
        bint manualSupported
        bint onOffSupported
        bint onePushSupported
        bint absValSupported
        bint readOutSupported
        unsigned int min
        unsigned int max
        float absMin
        float absMax
        char pUnits[512]
        char pUnitAbbr[512]
        unsigned int reserved[8]
       

    ctypedef struct fc2Property:
        fc2PropertyType   type
        bint present
        bint absControl
        bint onePush
        bint onOff
        bint autoManualMode
        unsigned int valueA  
        unsigned int valueB 
        float absValue
        unsigned int reserved[8]


    ctypedef struct fc2TriggerDelay:
        fc2PropertyType   type
        bint present
        bint absControl
        bint onePush
        bint onOff
        bint autoManualMode
        unsigned int valueA  
        unsigned int valueB 
        float absValue
        unsigned int reserved[8]

    ctypedef struct fc2TriggerModeInfo:
        bint present
        bint readOutSupported
        bint onOffSupported
        bint polaritySupported
        bint valueReadable
        unsigned int sourceMask
        bint softwareTriggerSupported
        unsigned int modeMask
        unsigned int reserved[8]

    ctypedef struct fc2TriggerMode:
        bint onOff
        unsigned int polarity
        unsigned int source
        unsigned int mode
        unsigned int parameter      
        unsigned int reserved[8]

    ctypedef struct fc2StrobeInfo:
        unsigned int source
        bint present
        bint readOutSupported
        bint onOffSupported
        bint polaritySupported
        float minValue
        float maxValue
        unsigned int reserved[8]

    ctypedef struct fc2StrobeControl:
        unsigned int source
        bint onOff
        unsigned int polarity
        float delay
        float duration
        unsigned int reserved[8]

    ctypedef struct fc2Format7ImageSettings:
        fc2Mode mode
        unsigned int offsetX
        unsigned int offsetY
        unsigned int width
        unsigned int height
        fc2PixelFormat pixelFormat
        unsigned int reserved[8]


    ctypedef struct fc2Format7Info:
        fc2Mode         mode

        unsigned int maxWidth
        unsigned int maxHeight
        unsigned int offsetHStepSize
        unsigned int offsetVStepSize
        unsigned int imageHStepSize
        unsigned int imageVStepSize
        unsigned int pixelFormatBitField
        unsigned int vendorPixelFormatBitField
        unsigned int packetSize
        unsigned int minPacketSize
        unsigned int maxPacketSize
        float percentage
        unsigned int reserved[16]

    ctypedef struct fc2GigEProperty:
        fc2GigEPropertyType propType        
        bint isReadable
        bint isWritable
        unsigned int min
        unsigned int max
        unsigned int value

        unsigned int reserved[8]

    ctypedef struct fc2GigEStreamChannel:
        unsigned int networkInterfaceIndex
        unsigned int hostPost
        bint doNotFragment
        unsigned int packetSize
        unsigned int interPacketDelay      
        fc2IPAddress destinationIpAddress
        unsigned int sourcePort

        unsigned int reserved[8]


    ctypedef struct fc2GigEConfig:
        bint enablePacketResend
        unsigned int timeoutForPacketResend
        unsigned int maxPacketsToResend
        unsigned int reserved[8]

    ctypedef struct fc2GigEImageSettingsInfo:
        unsigned int maxWidth
        unsigned int maxHeight
        unsigned int offsetHStepSize
        unsigned int offsetVStepSize
        unsigned int imageHStepSize
        unsigned int imageVStepSize
        unsigned int pixelFormatBitField
        unsigned int vendorPixelFormatBitField
        unsigned int reserved[16]


    ctypedef struct fc2GigEImageSettings:
        unsigned int offsetX
        unsigned int offsetY
        unsigned int width
        unsigned int height
        fc2PixelFormat pixelFormat
        unsigned int reserved[8]

    ctypedef struct fc2TimeStamp:
        long long seconds
        unsigned int microSeconds
        unsigned int cycleSeconds
        unsigned int cycleCount
        unsigned int cycleOffset
        unsigned int reserved[8]

    ctypedef struct fc2CameraInfo:
        unsigned int serialNumber
        fc2InterfaceType interfaceType
        fc2DriverType driverType
        bint isColorCamera
        char modelName[ 512]
        char vendorName[ 512]
        char sensorInfo[ 512]
        char sensorResolution[ 512]
        char driverName[ 512]
        char firmwareVersion[ 512]
        char firmwareBuildTime[ 512]
        fc2BusSpeed maximumBusSpeed
        fc2PCIeBusSpeed pcieBusSpeed
        fc2BayerTileFormat bayerTileFormat
        unsigned short busNumber
        unsigned short nodeNumber
        unsigned int iidcVer
        fc2ConfigROM configROM
        unsigned int gigEMajorVersion
        unsigned int gigEMinorVersion
        char userDefinedName[ 512]
        char xmlURL1[ 512]
        char xmlURL2[ 512]
        fc2MACAddress macAddress
        fc2IPAddress ipAddress
        fc2IPAddress subnetMask
        fc2IPAddress defaultGateway

        unsigned int reserved[16]

    ctypedef struct fc2EmbeddedImageInfoProperty:
        bint available
        bint onOff


    ctypedef struct fc2EmbeddedImageInfo:
        fc2EmbeddedImageInfoProperty timestamp
        fc2EmbeddedImageInfoProperty gain
        fc2EmbeddedImageInfoProperty shutter
        fc2EmbeddedImageInfoProperty brightness
        fc2EmbeddedImageInfoProperty exposure
        fc2EmbeddedImageInfoProperty whiteBalance
        fc2EmbeddedImageInfoProperty frameCounter
        fc2EmbeddedImageInfoProperty strobePattern
        fc2EmbeddedImageInfoProperty GPIOPinState
        fc2EmbeddedImageInfoProperty ROIPosition

    ctypedef struct fc2ImageMetadata:
        unsigned int embeddedTimeStamp
        unsigned int embeddedGain
        unsigned int embeddedShutter
        unsigned int embeddedBrightness
        unsigned int embeddedExposure
        unsigned int embeddedWhiteBalance
        unsigned int embeddedFrameCounter
        unsigned int embeddedStrobePattern
        unsigned int embeddedGPIOPinState
        unsigned int embeddedROIPosition        
        unsigned int reserved[31]

    ctypedef struct fc2LUTData:
        bint supported
        bint enabled
        unsigned int numBanks
        unsigned int numChannels
        unsigned int inputBitDepth
        unsigned int outputBitDepth
        unsigned int numEntries
        unsigned int reserved[8]

    ctypedef struct fc2PNGOption:
        bint interlaced 
        unsigned int compressionLevel
        unsigned int reserved[16]

    ctypedef struct fc2PPMOption:
        bint binaryFile
        unsigned int reserved[16]

    ctypedef struct fc2PGMOption:
        bint binaryFile
        unsigned int reserved[16]

    ctypedef enum fc2TIFFCompressionMethod:
        FC2TIFFNONE = 1,
        FC2TIFFPACKBITS,
        FC2TIFFDEFLATE,
        FC2TIFFADOBEDEFLATE,
        FC2TIFFCCITTFAX3,
        FC2TIFFCCITTFAX4,
        FC2TIFFLZW,
        FC2TIFFJPEG,

    ctypedef struct fc2TIFFOption:
        fc2TIFFCompressionMethod compression 
        unsigned int reserved[16]

    ctypedef struct fc2JPEGOption:
        bint progressive 
        unsigned int quality
        unsigned int reserved[16]

    ctypedef struct fc2JPG2Option:
        unsigned int quality
        unsigned int reserved[16]

    ctypedef struct fc2AVIOption:
       float frameRate
       unsigned int reserved[256]


    ctypedef struct fc2MJPGOption:
        float frameRate
        unsigned int quality
        unsigned int reserved[256]


    ctypedef struct fc2H264Option:
        float frameRate
        unsigned int width
        unsigned int height
        unsigned int bitrate
        unsigned int reserved[256]


    ctypedef struct fc2PGRGuid:
        unsigned int value[4]


    fc2Error fc2GetLibraryVersion( fc2Version* pVersion )
    fc2Error fc2CreateContext( fc2Context* pContext )
    fc2Error fc2DestroyContext( fc2Context pContext )    
    fc2Error fc2GetNumOfCameras ( fc2Context, unsigned int *pNumCameras )
    fc2Error fc2GetCameraFromIndex ( fc2Context, unsigned int index, fc2PGRGuid* pGuid )
    fc2Error fc2GetCameraInfo( fc2Context, fc2CameraInfo* pCameraInfo )
    fc2Error fc2Connect ( fc2Context, fc2PGRGuid* pGuid )
    fc2Error fc2GetEmbeddedImageInfo ( fc2Context, fc2EmbeddedImageInfo* pInfo )
    fc2Error fc2SetEmbeddedImageInfo ( fc2Context, fc2EmbeddedImageInfo* pInfo )
    fc2Error fc2StartCapture( fc2Context )
    fc2Error fc2StopCapture( fc2Context )    
    fc2Error fc2RetrieveBuffer (fc2Context, fc2Image* pImage )
    fc2Error fc2ConvertImageTo( fc2PixelFormat format, fc2Image* pImageIn, fc2Image* pImageOut )
    fc2Error fc2SaveImage( fc2Image* pImage, char* pFilename, fc2ImageFileFormat format )
    fc2Error fc2DestroyImage( fc2Image* image )
    fc2Error fc2CreateImage( fc2Image* pImage )

    fc2TimeStamp fc2GetImageTimeStamp( fc2Image* pImage )

    fc2Error fc2GetVideoModeAndFrameRate(fc2Context, fc2VideoMode *pvideoMode, fc2FrameRate *pframeRate)
    fc2Error fc2SetVideoModeAndFrameRate(fc2Context, fc2VideoMode pvideoMode, fc2FrameRate pframeRate)

    fc2Error fc2GetPropertyInfo(fc2Context, fc2PropertyInfo *propInfo)
    fc2Error fc2GetProperty(fc2Context, fc2Property *prop)
    fc2Error fc2SetProperty(fc2Context, fc2Property *prop)

