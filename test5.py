# {
#     "hits": [
#         {
#             "title": "Moneyball",
#             "score": 12.5,
#             "releaseDate": 1316750400
#         },
#         {
#             "title": "Back To The Future",
#             "score": 1.21,
#             "releaseDate": 489211200
#         },
#         {
#             "title": "Hitchhiker's Guide To The Galaxy",
#             "score": 42,
#             "releaseDate": 1114747200
#         },
#         {
#             "title": "Skyfall",
#             "score": 0.07,
#             "releaseDate": 1352437200
#         }
#     ]
# }
import json
import time

with open('json_data.json') as json_file:
    hits = json.load(json_file)['hits']

    with open('1_title_values.txt', 'a') as out:
        for h in hits:
            out.write(h['title'] + '\n')

    hitsSorted = sorted(hits, key=lambda i: int(i['score']*100))
    with open('2_sorted_title_values.txt', 'a') as out:
        for h in hitsSorted:
            out.write(h['title'] + '\n')

    with open('3_title_values.txt', 'a') as out:
        for h in hits:
            out.write("%s,%s\n" % (h['title'], time.strftime('%B %d, %Y', time.localtime(h['releaseDate']))))
