import http.server
import socketserver
import sys

PORT = 8000
if len(sys.argv) == 2:
    PORT = int(sys.argv[1])


class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header(
            'Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Cross-Origin-Resource-Policy','cross-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        super().end_headers()


Handler = CustomHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()

