import requests
import json

def get_countries_by_language(language: str) -> list:
    api_url = f'https://restcountries.com/v3.1/lang/{language}'
    return requests.get(api_url).json()


def format_response_json(countries: list) -> list:
    countries_formatted = []
    for country in countries:
        name = country['name']['common']
        capital = country.get('capital', [])
        continents = country['continents']
        flag = country['flag']
        population = country['population']

        new_country_json = {
            'name': name,
            'capital': capital,
            'continents': continents,
            'flag': flag,
            'population': population,
        }

        countries_formatted.append(new_country_json)

    return countries_formatted


def get_json_formatted(json) -> str:
    return json.dumps(json, default=str, indent=1)


def handler(event, context):
    print('Lambda event = ')
    print(get_json_formatted(event))
    print('Lambda context = ')
    print(context)

    portuguese_countries: list = get_countries_by_language('portuguese')
    portuguese_countries_formatted: list = format_response_json(portuguese_countries)

    print('portuguese_countries_formatted = ')
    print(get_json_formatted(portuguese_countries_formatted))
    return portuguese_countries_formatted
