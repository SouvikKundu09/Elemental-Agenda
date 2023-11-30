from flask import Flask
from flask import jsonify
from flask import request

from weatherRequestData import predict

app = Flask(__name__)

@app.route("/")
def hello():
  response = {"message": "API Working Successfully"}
  return jsonify(response)

@app.route("/get_prediction", methods=["POST"])
def defineWeather():
  location = request.json['location']
  date = request.json['date']
  prediction = predict(location, date)
  print(location, date)
  return jsonify({"prediction": prediction})

if __name__ == "__main__":
  app.run()
