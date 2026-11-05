import http.server
import socketserver
import os
import sys

PORT = 7070
DIRECTORY = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "build", "web")

class RobustNoCacheHandler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        '': 'application/octet-stream',
        '.html': 'text/html; charset=utf-8',
        '.js': 'application/javascript; charset=utf-8',
        '.mjs': 'application/javascript; charset=utf-8',
        '.json': 'application/json; charset=utf-8',
        '.wasm': 'application/wasm',
        '.css': 'text/css; charset=utf-8',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.svg': 'image/svg+xml',
        '.ttf': 'font/ttf',
        '.otf': 'font/otf',
        '.woff': 'font/woff',
        '.woff2': 'font/woff2',
    }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def address_string(self):
        # FAST: Return raw IP directly without reverse DNS lookup (avoids Windows 5-second hang)
        return str(self.client_address[0])

    def end_headers(self):
        # Anti-cache headers to ensure instant updates without stale code
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200, "OK")
        self.end_headers()

    def log_message(self, format, *args):
        # Ultra fast logging without reverse DNS
        try:
            ip = str(self.client_address[0])
        except Exception:
            ip = "unknown"
        sys.stdout.write(f"[{self.log_date_time_string()}] {ip} {format%args}\n")
        sys.stdout.flush()

    def handle(self):
        try:
            super().handle()
        except (ConnectionResetError, BrokenPipeError, ConnectionAbortedError):
            pass

class ThreadedHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True
    request_queue_size = 64

if __name__ == "__main__":
    server_address = ("0.0.0.0", PORT)
    with ThreadedHTTPServer(server_address, RobustNoCacheHandler) as httpd:
        print(f"==================================================")
        print(f" PundiGo! Multi-Threaded Web Server Running:")
        print(f" -> Local (Cepat): http://127.0.0.1:{PORT}")
        print(f" -> Alternatif:   http://localhost:{PORT}")
        print(f" -> Network:      http://192.168.11.200:{PORT}")
        print(f" Serving directory: {DIRECTORY}")
        print(f"==================================================")
        sys.stdout.flush()
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down server...")
            httpd.server_close()
