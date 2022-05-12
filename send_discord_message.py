import requests, sys

url = open('webhook_url.secret', 'r').readlines()[0].strip()
content = ' '.join(sys.argv[1:])
content = content.replace('\\n', '\n')
body = {'content': content}
result = requests.post(url, json=body)
print(result.text)
