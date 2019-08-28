puts "hi"



#shifts right for internal nils too.  like after numbers get added together and nil spot is created
def shiftRight(ar)
    newAr = ar.dup
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
    newAr = ar.dup
    #first, move everything to the right until there's no nil on the right OR until we've tried 3 times
    numShifts = 0
    while numShifts <= 4
        newAr = shiftRight(newAr)
        numShifts += 1
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
    return newAr
end


def swipeRight(board)
    newBoard = Array.new(4) { Array.new(4)}

    for r in 0..3 do
        newBoard[r] = collapseRight(board[r])
    end    
    return newBoard
end


def rotateClockwise(board)
    b = board.dup

    newBoard = [[b[3][0], b[2][0], b[1][0], b[0][0]], 
                [b[3][1], b[2][1], b[1][1], b[0][1]], 
                [b[3][2], b[2][2], b[1][2], b[0][2]], 
                [b[3][3], b[2][3], b[1][3], b[0][3]]]
    return newBoard
end



def swipeDown(board)
    newBoard = rotateClockwise(board)
    newBoard = rotateClockwise(newBoard)
    newBoard = rotateClockwise(newBoard)
    newBoard = swipeRight(newBoard)  
    newBoard = rotateClockwise(newBoard)
    return newBoard
end


def swipeLeft(board)
    newBoard = rotateClockwise(board)
    newBoard = rotateClockwise(newBoard)
    newBoard = swipeRight(newBoard)  
    newBoard = rotateClockwise(newBoard)
    newBoard = rotateClockwise(newBoard)
    return newBoard
end


def swipeUp(board)
    newBoard = rotateClockwise(board)
    newBoard = swipeRight(newBoard)  
    newBoard = rotateClockwise(newBoard)
    newBoard = rotateClockwise(newBoard)
    newBoard = rotateClockwise(newBoard)
    return newBoard
end

def display(board)
    puts '---------------'
    for r in 0..3 do
        for c in 0..3 do
            v = board[r][c]
            if v == nil
                print ' '
            else
                print v
            end
            print ' '
        end
        puts ''
    end   
    puts '---------------'
end 


def countNils(board)

    numNils = 0
    for r in 0..3 do    
        for c in 0..3 do
            if board[r][c] == nil
                numNils += 1
            end
        end
    end   
    return numNils
end


def getTwoOrFour()
    x = rand(0..1)
    if x == 0
        return 2
    elsif x == 1
        return 4
    end
end

def placeNewTile(board)
    b = board.dup
    if countNils(b) == 0
        raise 'cant place new tile - board is full'
    end
    success = false
    while success == false do
        r = rand(0..3)
        c = rand(0..3)
        if b[r][c] == nil 
            b[r][c] = getTwoOrFour()
            success = true
        end
    end
    return b
end



def getNilsPerTurnWithMaxTurns(board, maxTurns, nilsSoFar)
    b = board.dup
    b = placeNewTile(b)
    maxTurns -= 1
    nilsRight = getNilsPerTurnWithMaxTurns(swipeRight(b), maxTurns, nilsSoFar)
    nilsDown = getNilsPerTurnWithMaxTurns(swipeDown(b), maxTurns, nilsSoFar)
    nilsLeft = getNilsPerTurnWithMaxTurns(swipeLeft(b), maxTurns, nilsSoFar)
    nilsUp = getNilsPerTurnWithMaxTurns(swipeUp(b), maxTurns, nilsSoFar)

end





def getBestMove(board)
    b = board.dup
    maxTurns = 5
    nilsSoFar = []
    nilsRight = getNilsPerTurnWithMaxTurns(swipeRight(b), maxTurns, nilsSoFar)
    nilsDown = getNilsPerTurnWithMaxTurns(swipeDown(b), maxTurns, nilsSoFar)
    nilsLeft = getNilsPerTurnWithMaxTurns(swipeLeft(b), maxTurns, nilsSoFar)
    nilsUp = getNilsPerTurnWithMaxTurns(swipeUp(b), maxTurns, nilsSoFar)
end

# board = Array.new(4) { Array.new(4)}

board = [   [1, 2, nil, 4], 
            [2, 2, nil, 4], 
            [1, 1, nil, 1], 
            # [nil,nil,nil,nil], 
            [2, 2, nil, nil]]
display(board)
board = placeNewTile(board)
puts "new tile:        /_------------"
display(board)
puts "swipe right:"
display(swipeRight(board))
puts countNils(swipeRight(board))
puts "swipe down:"
display(swipeDown(board))
puts countNils(swipeDown(board))
puts "swipe left:"
display(swipeLeft(board))
puts countNils(swipeLeft(board))
puts "swipe up:"
display(swipeUp(board))
puts countNils(swipeUp(board))


# print shiftRight([1, 1, 1, nil])