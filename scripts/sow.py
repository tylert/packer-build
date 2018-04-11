#!/usr/bin/env python3

# sow.py

# Create a temporary HTTP server for hosting files

# https://docs.python.org/3/library/http.server.html
# https://docs.python.org/2/library/simplehttpserver.html

from __future__ import print_function

import sys

# Make sure this'll run with python 2.x and 3.x
if sys.version_info[:1] == (2,):
    import SimpleHTTPServer
    import SocketServer
else:
    import http.server
    import socketserver


PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(('', PORT), Handler)

print('Serving at port {0}'.format(PORT))
httpd.serve_forever()
