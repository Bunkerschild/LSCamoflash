import os

# HTTP-Header ausgeben
print("Content-Type: text/html\n")

# HTML-Seite generieren
print("<html><head><title>Python CGI Test</title></head><body>")
print("<h1>Python CGI funktioniert!</h1>")
print("<p>Request Method: {}</p>".format(os.environ.get('REQUEST_METHOD', 'Unknown')))
print("<p>Query String: {}</p>".format(os.environ.get('QUERY_STRING', 'None')))
print("<p>Server Software: {}</p>".format(os.environ.get('SERVER_SOFTWARE', 'Unknown')))
print("</body></html>")
