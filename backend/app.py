from flask import Flask, request, jsonify
from flask_cors import CORS
import re
from difflib import SequenceMatcher

app = Flask(__name__)
CORS(app)

def parse_custom_rules(rules_text):
    rules = []
    for line in rules_text.split('\n'):
        line = line.strip()
        if line.startswith('-') or line.startswith('*'):
            parts = line[1:].strip().split(':')
            if len(parts) == 2:
                rules.append((parts[0].strip(), parts[1].strip()))
    return sorted(rules, key=lambda x: len(x[0]), reverse=True)

def tokenize(text, rules):
    tokens = []
    i = 0
    while i < len(text):
        matched = False
        for old, new in rules:
            if text.startswith(old, i):
                tokens.append(new)
                i += len(old)
                matched = True
                break
        if not matched:
            tokens.append(text[i])
            i += 1
    return ''.join(tokens)

def clean_text(text, ignore_whitespace=False, ignore_punctuation=False, custom_rules=None):
    if ignore_whitespace:
        text = re.sub(r'\s+', '', text)
    if ignore_punctuation:
        text = re.sub(r'[^\w\s]', '', text)
    if custom_rules:
        text = tokenize(text, custom_rules)
    return text

def compare_texts(text1, text2, ignore_whitespace=False, ignore_punctuation=False, custom_rules=None):
    cleaned_text1 = clean_text(text1, ignore_whitespace, ignore_punctuation, custom_rules)
    cleaned_text2 = clean_text(text2, ignore_whitespace, ignore_punctuation, custom_rules)

    matcher = SequenceMatcher(None, cleaned_text1, cleaned_text2)
    ratio = matcher.ratio()

    result = {
        "similarity": f"{ratio:.2%}",
        "identical": ratio == 1.0,
        "differences": [],
        "cleaned_text1": cleaned_text1,
        "cleaned_text2": cleaned_text2
    }

    if not result["identical"]:
        for tag, i1, i2, j1, j2 in matcher.get_opcodes():
            if tag != 'equal':
                result["differences"].append({
                    "type": tag,
                    "text1": cleaned_text1[i1:i2],
                    "text2": cleaned_text2[j1:j2]
                })

    return result

@app.route('/api/compare', methods=['POST'])
def compare():
    data = request.json
    text1 = data.get('text1', '')
    text2 = data.get('text2', '')
    ignore_whitespace = data.get('ignore_whitespace', False)
    ignore_punctuation = data.get('ignore_punctuation', False)
    use_custom_rules = data.get('use_custom_rules', False)
    custom_rules_text = data.get('custom_rules', '')

    custom_rules = parse_custom_rules(custom_rules_text) if use_custom_rules else None

    result = compare_texts(text1, text2, ignore_whitespace, ignore_punctuation, custom_rules)
    return jsonify(result)

@app.route('/api/compare', methods=['GET'])
def test_api():
    return jsonify({"message": "API is working"}), 200

if __name__ == '__main__':
    app.run(debug=True)