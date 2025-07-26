def convert_string_numbers_to_integers(data):
    if isinstance(data, dict):
        return {k: convert_string_numbers_to_integers(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [convert_string_numbers_to_integers(i) for i in data]
    elif isinstance(data, str) and data.isdigit():
        return int(data)
    else:
        return data
