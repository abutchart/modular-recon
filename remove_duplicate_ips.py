import socket, sys
from queue import Queue
from threading import Thread

q = Queue(maxsize=0)

file = open(sys.argv[1], 'r')
urls = [x.strip() for x in file.readlines()]
results = {}

for i, url in enumerate(urls):
    q.put(url)

def get_host(q, result):
    while not q.empty():
        work = q.get()
        try:
            result[work] = socket.gethostbyname(work)
        except Exception as e:
            #if 'idna' not in e:
            #    print(work)
            print(work)
        q.task_done()
    return True

num_threads = min(10, len(urls))

for i in range(num_threads):
    worker = Thread(target=get_host, args=(q,results), daemon=True)
    worker.start()

q.join()

seen = []
for key, value in results.items():
    if value not in seen:
        print(key)
        seen.append(value)
    
