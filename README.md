# Threat Collector

This Python script fetches blacklist data from a specified API endpoint and writes it to a new CSV file. It is designed to facilitate automated data retrieval and file operations through APIs.

## Features

- Fetching data from APIs
- Support for HTTP Basic Authentication
- Authentication using API tokens
- Sending JSON body parameters for POST requests
- Backing up existing output files

## Usage

The script can be run with the following parameters:

```
python3 script.py --url <url> --output_file <output_file> [--api_token <api_token>] [--header <header>] [--username <username>] [--password <password>] [--body <body>]
```

### Parameters

- `--url <url>`: URL of the API endpoint including query parameters.
- `--output_file <output_file>`: Path to the output CSV file.
- `--api_token <api_token>`: (Optional) Token for API authentication.
- `--header <header>`: (Optional) Custom header for the request.
- `--username <username>`: (Optional) Username for HTTP Basic Authentication.
- `--password <password>`: (Optional) Password for HTTP Basic Authentication.
- `--body <body>`: (Optional) JSON formatted body for POST requests.

## Example Usage

To fetch data from an API:

```
python3 script.py --url "https://api.example.com/data" --output_file "output.csv"
```

If an API token is required:

```
python3 script.py --url "https://api.example.com/data" --output_file "output.csv" --api_token "your_api_token"
```

Using HTTP Basic Authentication:

```
python3 script.py --url "https://api.example.com/data" --output_file "output.csv" --username "user" --password "password"
```

## Installation

Before using this script, you need to install the required libraries:

```bash
pip install requests

```

## License

This project is licensed under the MIT License. For more information, see the `LICENSE` file.

## Contributing

Contributions are welcome and appreciated. If you have major changes to propose, please open an issue to discuss what you would like to change before making a pull request.
```

Bu README dosyası, projenizin temel bir açıklamasını, nasıl kullanılacağını ve gerekli bağımlılıkları içerir. Ek olarak, katkıda bulunma ve lisanslama hakkında bilgiler de yer alır. Dilerseniz projenize özel ek bilgiler ekleyerek genişletebilirsiniz.