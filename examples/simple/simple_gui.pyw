import wx
from PIL import Image
from PIL import ImageDraw
#from PIL import ImageFont
import time
import pyfly2
import os

DIRECTORY = "captures"

class Panel(wx.Panel):
    def __init__(self, parent, camera, font, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.camera = camera
        self.parent = parent
        self.font = font
        self.update_rate = update_rate
        self.count = 0
        self.image_number = 0
        self.fps = 0.0
        self.starttime = time.clock()
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()

    def update_titlebar(self):
        self.parent.SetTitle("PyFly2 - simple example (%.2f fps)" % self.fps)

    def update(self):
        self.Refresh()
        self.Update()
        wx.CallLater(5, self.update)

    def save(self,ext):
        self.image.save(os.path.join(DIRECTORY, "save%03d.%s" % (self.image_number, ext)))
        self.image_number += 1
        print "Saved."

    def create_bitmap(self):
        print "...",
        self.image = self.camera.GrabPILImage()
        print "!",
        
        # resize so it fits on 1080p screen
        image = self.image.resize((int(1280/1.5), int(1024/1.5)), Image.NEAREST)

        width, height = image.size
        data = image.convert('RGB').tostring()
        bitmap = wx.BitmapFromBuffer(width, height, data)

        # timekeeping
        self.count += 1
        now = time.clock()
        elapsed = now - self.starttime
        if elapsed >= self.update_rate:
            self.fps = self.count / elapsed
            self.starttime = now
            self.count = 0
            self.update_titlebar()

        return bitmap

    def on_paint(self, event):
        bitmap = self.create_bitmap()
        self.GetParent().check_size(bitmap.GetSize())
        dc = wx.AutoBufferedPaintDC(self)
        dc.DrawBitmap(bitmap, 0, 0)

class ControlPanel(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent, -1)
        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.auto_button = wx.CheckBox(self, -1, "Auto")
        self.onoff_button = wx.CheckBox(self, -1, "On/Off")
        self.save_png_button = wx.Button(self, -1, "Save PNG")
        self.save_jpg_button = wx.Button(self, -1, "Save JPG")        
        for widget in (self.auto_button, self.onoff_button):
            widget.Disable()
        self.sizer.Add(self.save_png_button, 0, wx.ALIGN_CENTER_VERTICAL, 5)
        self.sizer.Add(self.save_jpg_button, 0, wx.ALIGN_CENTER_VERTICAL, 5)        
        self.sizer.AddStretchSpacer()
        self.sizer.Add(self.auto_button, 0, wx.RIGHT | wx.ALIGN_CENTER_VERTICAL, 5)
        self.sizer.Add(self.onoff_button, 0, wx.RIGHT | wx.ALIGN_CENTER_VERTICAL, 5)
        self.SetSizerAndFit(self.sizer)
        self.SetMinSize((-1, 20))

class Frame(wx.Frame):
    def __init__(self, camera):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'PyFly2 - simple example', style=style)
        self.camera = camera

        self.controlpanel = ControlPanel(self)
        self.controlpanel.save_png_button.Bind(wx.EVT_BUTTON, self.OnSave)
        self.controlpanel.save_jpg_button.Bind(wx.EVT_BUTTON, self.OnSave)        
        #self.controlpanel.auto_button.Bind(wx.EVT_CHECKBOX, self.OnButton)
        #self.controlpanel.onoff_button.Bind(wx.EVT_CHECKBOX, self.OnButton)        

        self.mainsizer = wx.BoxSizer(wx.VERTICAL)
        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        #font = ImageFont.truetype("arial.ttf", 20)
        font = None
        self.p = Panel(self, self.camera, font)
        self.sizer.Add(self.p, 1, wx.EXPAND)
        self.mainsizer.Add(self.sizer, 1, wx.EXPAND)
        self.mainsizer.Add(self.controlpanel, 0, wx.EXPAND)
        
        self.SetSizerAndFit(self.mainsizer)
        self.Bind(wx.EVT_CLOSE, self.OnClose)

        # wait for all wx stuff to successfully init, then turn on the camera        
        self.camera.Connect()
        self.camera.StartCapture()

    def OnSave(self, evt):
        ext = "png" if evt.EventObject == self.controlpanel.save_png_button else "jpg"
        self.p.save(ext)

    def check_size(self, size):
        w,h = size
        size = w, h
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()

    def OnClose(self, event):
        self.camera.StopCapture()    
        self.p.Destroy()
        self.Destroy()

def main():
    if not os.path.exists(DIRECTORY):
        os.makedirs(DIRECTORY)

    context = pyfly2.Context()
    camera = context.get_camera(0)

    # now start the wx GUI
    app = wx.App(None)
    frame = Frame(camera)
    frame.Center()
    frame.Show()

    app.MainLoop()

if __name__ == '__main__':    
    main()