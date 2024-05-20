from flask import Flask
import uuid

app_id = str(uuid.uuid4())

app = Flask(__name__)


@app.route('/')
def hello_world():
  return "Hello, World!"+"app id:"+app_id

if __name__ == '__main__':
  app.run(host='0.0.0.0',port='8080')
