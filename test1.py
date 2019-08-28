

def findNumber(arr, k):
    if len(arr) < 3:
        return 'NO'

    # k = arr[len(arr) - 1]
    del arr[len(arr) - 1]
    del arr[0]
    for i in arr:
        if i == k:
            return 'YES'
    return 'NO'


print(findNumber([5,
                  1,
                  2,
                  3,
                  4,
                  5,
                  1], 1))
