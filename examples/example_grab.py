"""
   pyfly2
   
   example_grab

   grab an image from the first camera we find and save it to disk
"""


import pyfly2

def grab(fname):
    print "Getting pyfly2 context ..."
    context = pyfly2.Context()
    print "Done."
    
    if context.num_cameras:
    
        print "Getting camera ...",
        camera = context.get_camera(0)
        print "Done."
        
        print "Connecting to camera ...",
        camera.Connect()
        print "Done."
        
        print "Querying camera information ..."
        for k,v in camera.info.iteritems():
            print k,v
        print "Done."

        print "Starting capture mode ...",
        camera.StartCapture()
        print "Done."
        
        print "Grabbing single image ...",
        camera.GrabImageToDisk(fname)
        print "Done."
        
        print "Stopping capture mode ...",
        camera.StopCapture()
        print "Done."
    
        print "Image saved as", fname    
    else:
        raise ValueError("No cameras found\n")
    
if __name__ == "__main__":
    import sys

    # If the user specified a filename on the command line, then use that,
    # otherwise "Capture.png"
    fname = "Capture.png" if len(sys.argv) <= 1 else sys.argv[1]
    grab(fname)
