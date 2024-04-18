"""
This script fetches blacklist data from a specified URL API endpoint and writes it to a new CSV file.

Usage:
  python3 script.py --url <url> --output_file <output_file> [--api_token <api_token>] [--header <header>] [--username <username>] [--password <password>] [--body <body>]

Arguments:
  --url <url>               URL of the API endpoint including parameters
  --output_file <output_file>
                            Path to the output CSV file
  --api_token <api_token>   API token for authentication (optional)
  --header <header>         Custom header for the request (optional)
  --username <username>     Username for HTTP Basic Authentication (optional)
  --password <password>     Password for HTTP Basic Authentication (optional)
  --body <body>             Body parameters for POST request (optional)
"""
import os
import shutil
import argparse
import json
import requests


def get_blacklist_data(url, output_file, api_token=None, headers=None, username=None, password=None, body=None):
    """
    Fetches blacklist data from the specified URL and writes it to a new CSV file.

    :param url: URL of the API endpoint including parameters
    :param output_file: Path to the output CSV file
    :param api_token: API token for authentication
    :param headers: Custom headers for the request
    :param username: Username for HTTP Basic Authentication (optional)
    :param password: Password for HTTP Basic Authentication (optional)
    :param body: Body parameters for POST request
    """
    try:
        # Prepare authentication tuple for HTTP Basic Authentication
        auth = None
        if username and password:
            auth = (username, password)

        # Set default headers if not provided
        if not headers:
            headers = {
                "Content-Type": "application/json"
            }
            if api_token:
                headers["Authorization"] = f"Bearer {api_token}"

        if body:
            # Convert body parameter from string to dictionary
            try:
                body_params = json.loads(body)
            except json.JSONDecodeError as e:
                print("Error: Invalid JSON format for body parameter:", e)
                return

            # Send POST request with body parameters
            response = requests.post(url, headers=headers, auth=auth, json=body_params)
        else:
            # Send GET request if no body parameters are provided
            response = requests.get(url, headers=headers, auth=auth)

        # Check if the request was successful
        if response.status_code == 200:
            # Backup existing file if it exists
            if os.path.exists(output_file):
                backup_file = output_file + ".bkp"
                shutil.copy(output_file, backup_file)
                print(f"+ Existing file '{output_file}' backed up as '{backup_file}'")

            # Write data to a new file
            # Write the response content to the output file
            with open(output_file, "w", encoding="utf-8") as file:
                file.write(response.text)
            print("+ Data successfully written to file:", output_file)
        else:
            # Print error message if request was unsuccessful
            print(f"Error: Unable to access the API. Status code: {response.status_code}")
            print("Response content:", response.text)
    except requests.RequestException as e:
        # Print error message if request to the API failed
        print("Error: Request to the API failed:", e)
    except Exception as e:
        # Print error message if an exception occurs
        print("An error occurred:", e)


if __name__ == "__main__":
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Fetches blacklist data from a specified URL API endpoint and writes it to a new CSV file.")
    parser.add_argument("--url", type=str, help="URL of API endpoint including parameters", required=True)
    parser.add_argument("--output_file", type=str, help="Path to the output CSV file", required=True)
    parser.add_argument("--api_token", type=str, help="API token for authentication (optional)", default=None)
    parser.add_argument("--header", type=str, help="Custom header for the request (optional)", default=None)
    parser.add_argument("--username", type=str, help="Username for HTTP Basic Authentication (optional)", default=None)
    parser.add_argument("--password", type=str, help="Password for HTTP Basic Authentication (optional)", default=None)
    parser.add_argument("--body", type=str, help="Body parameters for POST request (optional)", default=None)

    args = parser.parse_args()

    # Call the function to fetch blacklist data
    get_blacklist_data(args.url, args.output_file, args.api_token, args.header, args.username, args.password, args.body)
