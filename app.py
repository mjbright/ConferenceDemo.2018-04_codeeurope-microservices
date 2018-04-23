
import os, time, json

from redis import Redis
from flask import Flask, request, Response, stream_with_context, jsonify

app = Flask(__name__)
db  = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    db.incr('count')

    #if request.headers
    TEXT=true

    if TEXT:
        return '''Counter value=%s''' % db.get('count')
    
    return '''

<html>
  <head>
    <style>
          body {background-color: powderblue;};
          h1   {color: blue;};
          p    {color: red;};
    </style>
  </head>
  <body>
    <h1> Count is %s.  </h1>
  </body>
</html>

''' % db.get('count')


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
