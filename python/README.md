# Weather Service

This repository contains a simple microservice implemented in Python that retrieves the current temperature for Washington, DC from the Open-Meteo API.

## Prerequisites

Before running this microservice, ensure that you have the following:

- Python installed on your system.
- An API key obtained from [Open-Meteo](https://open-meteo.com/). Replace 'YOUR_API_KEY' in the code with your actual API key.

## Installation

1. Clone this repository or download the `weather_service.py` file.

2. Install the necessary dependencies by running the following command:

   ```shell
   $ pip install flask requests

Usage
-----

1.  Save the code in a file named `weather_service.py`.

2.  In the `weather_service.py` file, replace 'YOUR_API_KEY' with your actual Open-Meteo API key.

3.  Run the microservice by executing the following command:

    `$ python weather_service.py`

4.  The microservice will run on `http://localhost:5000/weather`.

Endpoint
--------

When accessing the `http://localhost:5000/weather` endpoint, the microservice will make a GET request to the Open-Meteo API using your API key. It will retrieve the current temperature for Washington, DC and return a JSON response containing the city and temperature.

Feel free to modify the code or integrate it into your own projects as needed.

Note: Ensure that you comply with the terms and conditions of the Open-Meteo API when using their service.

For more information and API documentation, please refer to the [Open-Meteo website](https://open-meteo.com/).