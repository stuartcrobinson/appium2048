# require "engine2048"





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

def swipeBoard(direction, board)
    if direction == 'right'
        return swipeRight(board)
    elsif direction == 'down'
        return swipeDown(board)
    elsif direction == 'left'
        return swipeLeft(board)
    elsif direction == 'up'
        return swipeUp(board)
    end
end

def display(board)
    puts '-----------------------'
    for r in 0..3 do
        if r > 0 
            puts ''
        end
        for c in 0..3 do
            v = board[r][c]
            if v == nil
                print '%5.4s' % ' '
            else
                print '%5.4s' % v
            end
            print ' '
        end
        puts ''
    end   
    puts '-----------------------'
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

NilsResult = Struct.new(:direction, :array, :lastNil)

def getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)

    maxLen = [nilsRight.length, nilsDown.length, nilsLeft.length, nilsUp.length].max 


    # puts 'maxLen is ' + maxLen.to_s


    right = NilsResult.new
    right.direction = 'right'
    right.array = nilsRight
    right.lastNil = nilsRight[nilsRight.length - 1]
    down = NilsResult.new
    down.direction = 'down'
    down.array = nilsDown
    down.lastNil = nilsDown[nilsDown.length - 1]
    left = NilsResult.new
    left.direction = 'left'
    left.array = nilsLeft
    left.lastNil = nilsLeft[nilsLeft.length - 1]
    up = NilsResult.new
    up.direction = 'up'
    up.array = nilsUp
    up.lastNil = nilsUp[nilsUp.length - 1]

    nilsz = [right, down, left, up]


    # for x in nilsz  
    #     print x
    #     puts ''
    # end


    # x.select{|x| x > 2}
    nilsz = nilsz.select{|x| x[:array].length == maxLen}

    # now all nils arrays are max length
    # now, get array with highest final nil value



    # nilsz.sort{|x| x[:lastNil]}
    nilsz = nilsz.sort {| a, b | a[:lastNil] <=> b[:lastNil] }
    # nilsz = nilsz.sort_by {|l| l.lastNil}


    # puts 'sorted:'

    # for x in nilsz  
    #     print x
    #     puts ''
    # end

    bestNilsResult = nilsz[nilsz.length - 1]
    array = bestNilsResult.array
    finalNumNils = array[array.length - 1]
    direction = bestNilsResult.direction
    # print 'best direction is ' + direction 
    # puts ''
    return bestNilsResult
end


def getNilsPerTurnWithMaxTurns(board, maxTurns, nilsSoFar_input, dir)
    b = board.dup

    numNils = countNils(board)
    nilsSoFar = nilsSoFar_input.dup
    nilsSoFar.push(numNils)

    # puts 'getNilsPerTurnWithMaxTurns'
    # puts dir
    # puts maxTurns 
    # puts 'num nils: ' + numNils.to_s
    # print 'nilsSoFar: ' + nilsSoFar.join(', ')
    # puts ''
    # display(board)

    if maxTurns == 0 || countNils(board) == 0
        # puts 'returning: ' + nilsSoFar.join(', ')
        return nilsSoFar
    else 
        b = placeNewTile(b)
        # puts 'new tile:'
        # display(b)
        maxTurns -= 1

        newB = swipeRight(b)
        if newB != b 
            nilsRight = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'r')
        else
            nilsRight = nilsSoFar
        end

        newB = swipeDown(b)
        if newB != b 
            nilsDown = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'd')
        else
            nilsDown = nilsSoFar
        end
            
        newB = swipeLeft(b)
        if newB != b 
            nilsLeft = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'l')
        else
            nilsLeft = nilsSoFar
        end
            
        newB = swipeUp(b)
        if newB != b 
            nilsUp = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'u')
        else
            nilsUp = nilsSoFar
        end

        # puts 'right'
        # print nilsRight
        # puts ''
        
        # puts 'down'
        # print nilsDown
        # puts ''

        # puts 'left'
        # print nilsLeft
        # puts ''

        # puts 'up'
        # print nilsUp
        # puts ''

        #working until here!


        bestNilsResult = getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)
        # bestdirection = bestNilsResult.direction
        array = bestNilsResult.array
        finalNumNils = array[array.length - 1]
        nilsSoFar_copy = nilsSoFar.dup
        nilsSoFar_copy.push(finalNumNils)
        return array
    end
end


def getBestMove(board, i)
    b = board.dup

    # maxTurns = 4


    if i < 200
        maxTurns = 1
    # elsif i < 350
    #     maxTurns = 3
    elsif i < 400
        maxTurns = 4
    elsif i < 500
        maxTurns = 5
    elsif i < 600
        maxTurns = 6   
    else
        maxTurns = 6
    end
    nilsSoFar = []


    newB = swipeRight(b)
    if newB != b 
        nilsRight = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'r')
    else
        nilsRight = nilsSoFar
    end

    newB = swipeDown(b)
    if newB != b 
        nilsDown = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'd')
    else
        nilsDown = nilsSoFar
    end
        
    newB = swipeLeft(b)
    if newB != b 
        nilsLeft = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'l')
    else
        nilsLeft = nilsSoFar
    end
        
    newB = swipeUp(b)
    if newB != b 
        nilsUp = getNilsPerTurnWithMaxTurns(newB, maxTurns, nilsSoFar, 'u')
    else
        nilsUp = nilsSoFar
    end



    # nilsRight = getNilsPerTurnWithMaxTurns(swipeRight(b), maxTurns, nilsSoFar, 'r')
    # nilsDown = getNilsPerTurnWithMaxTurns(swipeDown(b), maxTurns, nilsSoFar, 'd')
    # nilsLeft = getNilsPerTurnWithMaxTurns(swipeLeft(b), maxTurns, nilsSoFar, 'l')
    # nilsUp = getNilsPerTurnWithMaxTurns(swipeUp(b), maxTurns, nilsSoFar, 'u')

    bestNilsResult = getBestNilsResult(nilsRight, nilsDown, nilsLeft, nilsUp)

    return bestNilsResult.direction
end


################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
def waitForChangeOld(s0, driver)

    puts '---- before'
    puts s0
    puts '---'
    # wait for page to change
    count = 0
    while s0 == driver.find_element(class: "tile-container").text do #driver.page_source driver.page_source do 
        # s0 = driver.page_source
        count += 1
        sleep(0.05)
        if count > 3
            sleep(3)
        end
        puts '---- during'
        puts s0
        puts '---'
    end

    puts '---- after'  
    puts s0
    puts '---'
end


def waitForChangeOld2(b0, driver)

    puts '---- before'
    puts b0
    # wait for page to change
    sleep(0.05)
    count = 0
    while b0 == getBoard(driver) do
        count += 1
        sleep(0.05)
        if count > 3
            sleep(3)
        end
        puts '---- same'
    end
    # b == getBoard(driver)
    puts '---- after'  
    puts display(getBoard(driver))
    puts '---'
end


################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################

require "selenium-webdriver" # load in the webdriver gem to interact with Selenium

# create a driver object.
# This is what you will actually interact with to do things within the automated 
driver = Selenium::WebDriver.for :chrome

# open CrossBrowserTesting.com inside Chrome
driver.navigate.to "http://2048game.com/" 


def getTileClass(r, c)
    return "tile-position-" + c.to_s + "-" + r.to_s
end

def getBoard(driver)
    b = Array.new(4) { Array.new(4)}

    # b = [   [1, 2, nil, 4], 
    #         [2, 2, nil, 4], 
    #         [1, 1, nil, 1], 
    #         [nil,nil,nil,nil], 
    #         [2, 2, nil, nil]]

    for r in 0..3 do
        for c in 0..3 do 
            v = nil
            begin
                # v = driver.find_elements(class: getTileClass(r+1, c+1)).text
                list = driver.find_elements(class: getTileClass(r+1, c+1))
                v = list[list.length - 1].text
                # puts v
                b[r][c] = v
            rescue
                # print ''
            end
        end
    end
    return b
end
                

def uiSwipe(d, driver)

    if d == 'up'
        driver.find_element(:css, 'body').send_keys :arrow_up
    end
    if d == 'down'
        driver.find_element(:css, 'body').send_keys :arrow_down
    end
    if d == 'left'
        driver.find_element(:css, 'body').send_keys :arrow_left
    end
    if d == 'right'
        driver.find_element(:css, 'body').send_keys :arrow_right
    end
end

    

def makeSureBoardIsStill(driver)
    s0 = driver.page_source

    sleep(0.05)
    while driver.page_source != s0 do
        s0 = driver.page_source
        sleep(0.05)
    end
    # return s0
end


def waitForChange(s0, driver)

    puts '---- before'
    puts s0
    # wait for page to change
    sleep(0.01)
    count = 0
    while s0 == driver.find_element(class: "tile-container").attribute("innerHTML") do
        count += 1
        sleep(0.01 * count * count)
        # end
        puts '--------- looping ' + count.to_s
        display(getBoard(driver))
    end
    # b == getBoard(driver)
    puts '---- after'  
    puts driver.find_element(class: "tile-container").attribute("innerHTML")
    puts '---'
end

# driver.find_element(class: "tile-container").attribute("innerHTML")
# driver.find_element(class: "tile-container").text

# sleep(3)
b = getBoard(driver)
display(b)


def superBestMove(i, board)
    arr = [getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i),
        getBestMove(board, i)]

    freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    bestDirection = arr.max_by { |v| freq[v] }
    return bestDirection
end

for i in 0..1000 do 
    direction = superBestMove(i, b)
    puts i.to_s + ") best move: " + direction
    preSource = driver.find_element(class: "tile-container").attribute("innerHTML")
    puts '---- before'
    puts preSource
    # puts 1
    puts '----'
    puts 'about to swipe ' + direction
    uiSwipe(direction, driver)
    puts 2
    waitForChange(preSource, driver)
    puts 3 
    # makeSureBoardIsStill(driver)
    puts 4
    b = getBoard(driver)
    display(b)
end

# puts b 
# print b
# puts ''

display(b)


driver.quit



