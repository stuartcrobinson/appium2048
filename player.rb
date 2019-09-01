# puts "hi"



# #shifts right for internal nils too.  like after numbers get added together and nil spot is created
# def shiftRight(ar)
#     newAr = ar.dup
#     i = 3
#     while i >= 1 do
#         if newAr[i] == nil
#             newAr[i] = newAr[i-1]
#             newAr[i-1] = nil
#         end
#         i = i - 1
#     end
#     return newAr
# end


# def collapseRight(ar)
#     newAr = ar.dup
#     #first, move everything to the right until there's no nil on the right OR until we've tried 3 times
#     numShifts = 0
#     while numShifts <= 4
#         newAr = shiftRight(newAr)
#         numShifts += 1
#     end
#     #now add and collapse.  
#     i = 3
#     while i >= 1 do
#         if newAr[i] != nil && newAr[i] == newAr[i-1]
#             newAr[i] = newAr[i] + newAr[i-1]
#             newAr[i-1] = nil
#             newAr = shiftRight(newAr)
#         end
#         i = i - 1
#     end
#     return newAr
# end


# def swipeRight(board)
#     newBoard = Array.new(4) { Array.new(4)}

#     for r in 0..3 do
#         newBoard[r] = collapseRight(board[r])
#     end    
#     return newBoard
# end


# def rotateClockwise(board)
#     b = board.dup

#     newBoard = [[b[3][0], b[2][0], b[1][0], b[0][0]], 
#                 [b[3][1], b[2][1], b[1][1], b[0][1]], 
#                 [b[3][2], b[2][2], b[1][2], b[0][2]], 
#                 [b[3][3], b[2][3], b[1][3], b[0][3]]]
#     return newBoard
# end



# def swipeDown(board)
#     newBoard = rotateClockwise(board)
#     newBoard = rotateClockwise(newBoard)
#     newBoard = rotateClockwise(newBoard)
#     newBoard = swipeRight(newBoard)  
#     newBoard = rotateClockwise(newBoard)
#     return newBoard
# end


# def swipeLeft(board)
#     newBoard = rotateClockwise(board)
#     newBoard = rotateClockwise(newBoard)
#     newBoard = swipeRight(newBoard)  
#     newBoard = rotateClockwise(newBoard)
#     newBoard = rotateClockwise(newBoard)
#     return newBoard
# end


# def swipeUp(board)
#     newBoard = rotateClockwise(board)
#     newBoard = swipeRight(newBoard)  
#     newBoard = rotateClockwise(newBoard)
#     newBoard = rotateClockwise(newBoard)
#     newBoard = rotateClockwise(newBoard)
#     return newBoard
# end

# def swipeBoard(direction, board)
#     if direction == 'right'
#         return swipeRight(board)
#     elsif direction == 'down'
#         return swipeDown(board)
#     elsif direction == 'left'
#         return swipeLeft(board)
#     elsif direction == 'up'
#         return swipeUp(board)
#     end
# end

# def display(board)
#     puts '---------------'
#     for r in 0..3 do
#         for c in 0..3 do
#             v = board[r][c]
#             if v == nil
#                 print '%5.4s' % ' '
#             else
#                 print '%5.4s' % v
#             end
#             print ' '
#         end
#         puts ''
#         puts ''
#     end   
#     puts '---------------'
# end 


# def countNils(board)

#     numNils = 0
#     for r in 0..3 do    
#         for c in 0..3 do
#             if board[r][c] == nil
#                 numNils += 1
#             end
#         end
#     end   
#     return numNils
# end


# def getTwoOrFour()
#     x = rand(0..1)
#     if x == 0
#         return 2
#     elsif x == 1
#         return 4
#     end
# end

# def placeNewTile(board)
#     b = board.dup
#     if countNils(b) == 0
#         raise 'cant place new tile - board is full'
#     end
#     success = false
#     while success == false do
#         r = rand(0..3)
#         c = rand(0..3)
#         if b[r][c] == nil 
#             b[r][c] = getTwoOrFour()
#             success = true
#         end
#     end
#     return b
# end

# NilsResult = Struct.new(:direction, :array, :lastNil)

# def getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)

#     maxLen = [nilsRight.length, nilsDown.length, nilsLeft.length, nilsUp.length].max 


#     # puts 'maxLen is ' + maxLen.to_s


#     right = NilsResult.new
#     right.direction = 'right'
#     right.array = nilsRight
#     right.lastNil = nilsRight[nilsRight.length - 1]
#     down = NilsResult.new
#     down.direction = 'down'
#     down.array = nilsDown
#     down.lastNil = nilsDown[nilsDown.length - 1]
#     left = NilsResult.new
#     left.direction = 'left'
#     left.array = nilsLeft
#     left.lastNil = nilsLeft[nilsLeft.length - 1]
#     up = NilsResult.new
#     up.direction = 'up'
#     up.array = nilsUp
#     up.lastNil = nilsUp[nilsUp.length - 1]

#     nilsz = [right, down, left, up]


#     # for x in nilsz  
#     #     print x
#     #     puts ''
#     # end


#     # x.select{|x| x > 2}
#     nilsz = nilsz.select{|x| x[:array].length == maxLen}

#     # now all nils arrays are max length
#     # now, get array with highest final nil value



#     # nilsz.sort{|x| x[:lastNil]}
#     nilsz = nilsz.sort {| a, b | a[:lastNil] <=> b[:lastNil] }
#     # nilsz = nilsz.sort_by {|l| l.lastNil}


#     # puts 'sorted:'

#     # for x in nilsz  
#     #     print x
#     #     puts ''
#     # end

#     bestNilsResult = nilsz[nilsz.length - 1]
#     array = bestNilsResult.array
#     finalNumNils = array[array.length - 1]
#     direction = bestNilsResult.direction
#     # print 'best direction is ' + direction 
#     # puts ''
#     return bestNilsResult
# end


# def getNilsPerTurnWithMaxTurns(board, maxTurns, nilsSoFar_input, dir)
#     b = board.dup

#     numNils = countNils(board)
#     nilsSoFar = nilsSoFar_input.dup
#     nilsSoFar.push(numNils)

#     # puts 'getNilsPerTurnWithMaxTurns'
#     # puts dir
#     # puts maxTurns 
#     # puts 'num nils: ' + numNils.to_s
#     # print 'nilsSoFar: ' + nilsSoFar.join(', ')
#     # puts ''
#     # display(board)

#     if maxTurns == 0 || countNils(board) == 0
#         # puts 'returning: ' + nilsSoFar.join(', ')
#         return nilsSoFar
#     else 
#         b = placeNewTile(b)
#         # puts 'new tile:'
#         # display(b)
#         maxTurns -= 1

#         newB = swipeRight(b)
#         if newB != b 
#             nilsRight = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'r')
#         else
#             nilsRight = nilsSoFar
#         end

#         newB = swipeDown(b)
#         if newB != b 
#             nilsDown = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'd')
#         else
#             nilsDown = nilsSoFar
#         end
            
#         newB = swipeLeft(b)
#         if newB != b 
#             nilsLeft = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'l')
#         else
#             nilsLeft = nilsSoFar
#         end
            
#         newB = swipeUp(b)
#         if newB != b 
#             nilsUp = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'u')
#         else
#             nilsUp = nilsSoFar
#         end

#         # puts 'right'
#         # print nilsRight
#         # puts ''
        
#         # puts 'down'
#         # print nilsDown
#         # puts ''

#         # puts 'left'
#         # print nilsLeft
#         # puts ''

#         # puts 'up'
#         # print nilsUp
#         # puts ''

#         #working until here!


#         bestNilsResult = getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)
#         # bestdirection = bestNilsResult.direction
#         array = bestNilsResult.array
#         finalNumNils = array[array.length - 1]
#         nilsSoFar_copy = nilsSoFar.dup
#         nilsSoFar_copy.push(finalNumNils)
#         return array
#     end
# end


# def getBestMove(board, i)
#     b = board.dup

#     # maxTurns = 4


#     if i < 275
#         maxTurns = 2
#     elsif i < 500
#         maxTurns = 3
#     elsif i < 600
#         maxTurns = 4   
#     else
#         maxTurns = 5
#     end
#     nilsSoFar = []


#     newB = swipeRight(b)
#     if newB != b 
#         nilsRight = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'r')
#     else
#         nilsRight = nilsSoFar
#     end

#     newB = swipeDown(b)
#     if newB != b 
#         nilsDown = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'd')
#     else
#         nilsDown = nilsSoFar
#     end
        
#     newB = swipeLeft(b)
#     if newB != b 
#         nilsLeft = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'l')
#     else
#         nilsLeft = nilsSoFar
#     end
        
#     newB = swipeUp(b)
#     if newB != b 
#         nilsUp = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'u')
#     else
#         nilsUp = nilsSoFar
#     end



#     # nilsRight = getNilsPerTurnWithMaxTurns(swipeRight(b), maxTurns, nilsSoFar, 'r')
#     # nilsDown = getNilsPerTurnWithMaxTurns(swipeDown(b), maxTurns, nilsSoFar, 'd')
#     # nilsLeft = getNilsPerTurnWithMaxTurns(swipeLeft(b), maxTurns, nilsSoFar, 'l')
#     # nilsUp = getNilsPerTurnWithMaxTurns(swipeUp(b), maxTurns, nilsSoFar, 'u')

#     bestNilsResult = getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)

#     return bestNilsResult.direction
# end

# def superBestMove(i, board)
#     arr = [getBestMove(board, i),
#         getBestMove(board, i),
#         getBestMove(board, i),
#         getBestMove(board, i),
#         getBestMove(board, i),
#         getBestMove(board, i),
#         getBestMove(board, i)]

#     freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
#     bestDirection = arr.max_by { |v| freq[v] }
#     return bestDirection
# end

# require 'ostruct'

# person = OpenStruct.new


# board = Array.new(4) { Array.new(4)}

# board = placeNewTile(board)
# puts "new tile:        /_------------"
# display(board)
# puts "swipe right:"
# display(swipeRight(board))
# puts countNils(swipeRight(board))
# puts "swipe down:"
# display(swipeDown(board))
# puts countNils(swipeDown(board))
# puts "swipe left:"
# display(swipeLeft(board))
# puts countNils(swipeLeft(board))
# puts "swipe up:"
# display(swipeUp(board))
# puts countNils(swipeUp(board))

# puts '=================================================='
# display(board)

# puts ''
# bestDirection = getBestMove(board)
# puts bestDirection
# board = swipeBoard(bestDirection, board)
# board = placeNewTile(board)
# display(board)

board = [   [1, 2, nil, 4], 
            [2, 2, nil, 4], 
            [1, 1, nil, 1], 
            # [nil,nil,nil,nil], 
            [2, 2, nil, nil]]
display(board)




for i in 0..1000 do
   bestDirection = superBestMove(i, board)

    
    puts i.to_s + '. ' + bestDirection
    board = swipeBoard(bestDirection, board)
    board = placeNewTile(board)
    display(board)
end

# display(board)



# print shiftRight([1, 1, 1, nil])