import os
from http.server import BaseHTTPRequestHandler, HTTPServer


class _Handler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        self.send_response(200)
        self.end_headers()


def main() -> None:
    port = int(os.environ.get("PORT", "8081"))
    server = HTTPServer(("", port), _Handler)
    print(f"ezstatus (python) listening on :{port}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
