#!/usr/bin/python3
import gi
gi.require_version('Gst', '1.0')
from gi.repository import GObject, Gst


GObject.threads_init()
Gst.init(None)

pipe = Gst.Pipeline()

vts = Gst.ElementFactory.make("videotestsrc","snow")
vts.set_property("pattern", "snow")
ffcs = Gst.ElementFactory.make("ffmpegcolorspace","ffm")
xvi = Gst.ElementFactory.make("xvimagesink","ffm")
pipe.add(vts)
#pipe.add(ffcs)
pipe.add(xvi)
vts.link(xvi)
#ffcs.link(xvi)
pipe.set_state(Gst.State.PLAYING)

#ats = Gst.ElementFactory.make("audiotestsrc", "audio")
#pipe.add(ats)

#sink = Gst.ElementFactory.make("alsasink", "sink")
#pipe.add(sink)

#ats.link(sink)

#pipe.set_state(Gst.State.PLAYING)
while True:
    pass



