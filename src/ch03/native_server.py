from collections import defaultdict

def map_reduce_ultra_native(my_input, mapper, reducer):
    map_results = map(mapper, my_input)
    
    districutor = defaultdict(list)
    for key, value in map_results:
        districutor[key].append(value)
        
    return map(reducer, districutor.items())

words = 'Python is great Python rocks'.split(' ')

emiter = lambda word: (word, 1)
counter = lambda emitted: (emitted[0], sum(emitted[1]))

a = list(map_reduce_ultra_native(words, emiter, counter))
print(a)