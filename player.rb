puts "hi"



#shifts right for internal nils too.  like after numbers get added together and nil spot is created
def shiftRight(ar)
    newAr = ar.dup
    puts "huh"
    i = 3
    while i >= 1 do
        if newAr[i] == nil
            newAr[i] = newAr[i-1]
            newAr[i-1] = nil
        end
        i = i - 1
    end
    return newAr
end


def collapseRight(ar)
    #first, move everything to the right until there's no nil on the right
    newAr = ar.dup
    puts "----------collapse right"
    puts newAr
    while newAr[3] == nil
        # puts newAr
        newAr = shiftRight(newAr)
    end
    #now add and collapse.  
    i = 3
    while i >= 1 do
        if newAr[i] != nil && newAr[i] == newAr[i-1]
            newAr[i] = newAr[i] + newAr[i-1]
            newAr[i-1] = nil
            newAr = shiftRight(newAr)
        end
        i = i - 1
    end
    puts "----------collapse right end:"
    puts newAr
    return newAr
end


def swipeRight(board)
    newBoard = Array.new(4) { Array.new(4)}

    for r in 0..3 do
        newBoard[r] = collapseRight(board[r])
    end    
    return newBoard
end




# board = Array.new(4) { Array.new(4)}

board = [   [1, 2, 3, 4], 
            [2, 2, 4, 4], 
            [1, 1, 1, 1], 
            [2, 2, 3, nil]]

print board
puts ""
print swipeRight(board)
puts ''
print board

# print shiftRight([1, 1, 1, nil])