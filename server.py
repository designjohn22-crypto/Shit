import os
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        # Ang root at /panel.html ay parehong ibibigay ang panel page
        if self.path.split('?')[0] in ('/', '/panel', '/panel.html'):
            self.path = '/panel.html' + ('?' + self.path.split('?', 1)[1] if '?' in self.path else '')
        return super().do_GET()

    def end_headers(self):
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.send_header('Referrer-Policy', 'no-referrer')
        super().end_headers()

    def log_message(self, fmt, *args):
        pass

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    directory = os.path.dirname(os.path.abspath(__file__))
    os.chdir(directory)
    print(f'VOID panel running on port {port}')
    ThreadingHTTPServer(('0.0.0.0', port), Handler).serve_forever()
