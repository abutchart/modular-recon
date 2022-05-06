import requests, sys

url = open('webhook_url.secret', 'r').readlines()[0].strip()
body = {'content': sys.argv[1]}
result = requests.post(url, json=body)
print(result.text)
