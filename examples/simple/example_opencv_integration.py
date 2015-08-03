"""
   pyfly2
   
   example_opencv_integration

   continually grab images from a camera and display them using OpenCV's
   HighGui module, until the user presses a key
"""

import cv2
import pyfly2


def main(cameraIndex=0, format='bgr', scale=1.0, windowName='Live Video'):
    context = pyfly2.Context()
    if context.num_cameras < 1:
        raise ValueError('No cameras found')
    camera = context.get_camera(cameraIndex)
    camera.Connect()
    camera.StartCapture()
    while cv2.waitKey(1) == -1:
        image = camera.GrabNumPyImage(format)
        if scale != 1.0:
            image = cv2.resize(image, (0, 0), fx=scale, fy=scale)
        cv2.imshow(windowName, image)
    camera.StopCapture()


if __name__ == "__main__":
    main()
