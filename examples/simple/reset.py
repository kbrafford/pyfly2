"""
   pyfly2
   
   reset

   create a context and exit, allowing the flycap2 "fc2DestroyContext" call to be made

   Sometimes this seems to help when things are gummed up.  but not always
   
"""


import pyfly2

print "Getting pyfly2 context ..."
context = pyfly2.Context()
print "Done."

print "Now quitting."
