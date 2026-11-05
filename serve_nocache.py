import http.server
import socketserver
import os
import functools

class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

if __name__ == '__main__':
    web_dir = os.path.join(os.getcwd(), 'build', 'web')
    handler = functools.partial(NoCacheHandler, directory=web_dir)
    port = 7700
    with socketserver.TCPServer(('', port), handler) as httpd:
        print(f'Serving on http://localhost:{port} with No-Cache...')
        httpd.serve_forever()

