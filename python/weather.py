import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/weather', methods=['GET'])
def get_weather():
    # Replace YOUR_API_KEY with your actual API key from https://open-meteo.com/
    api_key = 'YOUR_API_KEY'
    city = 'Washington,DC'

    # Make the API request to get the current weather
    url = f'https://api.open-meteo.com/v1/forecast?city={city}&key={api_key}&hourly=temperature_2m'
    response = requests.get(url)
    data = response.json()

    # Extract the current temperature from the API response
    current_temperature = data['hourly']['temperature_2m'][0]['value']

    # Create the response JSON
    weather_data = {
        'city': city,
        'temperature': current_temperature
    }

    return jsonify(weather_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
