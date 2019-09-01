
def getTileClass(r, c)
    return "tile-position-" + c.to_s + "-" + r.to_s
end

def getBoard(driver)
    b = Array.new(4) { Array.new(4)}

    for r in 0..3 do
        for c in 0..3 do 
            v = nil
            begin
                # v = driver.find_elements(class: getTileClass(r+1, c+1)).text
                list = driver.find_elements(class: getTileClass(r+1, c+1))
                v = list[list.length - 1].text
                # puts v
                b[r][c] = v.to_i
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


def waitForChange(s0, b, driver)
    sleep(0.01)

    # count = 0
    # while s0 == driver.find_element(class: "tile-container").attribute("innerHTML") do
    #     count += 1
    #     puts 'waiting source'
    #     sleep(0.1 * count * count)
    # end

    count = 0
    while contains(b, 0) do
        count += 1
        puts 'waiting no 0'
        sleep(0.1 * count * count)
        b = getBoard(driver)
    end

    return b
    # count = 0
    # while b0 == getBoard(driver) do
    #     count += 1
    #     puts 'waiting board change'
    #     sleep(0.1 * count * count)
    # end

    # count = 0
    # while s0 == driver.find_element(class: "tile-container").attribute("innerHTML") do
    #     count += 1
    #     puts 'waiting source'
    #     sleep(0.1 * count * count)
    # end

    # count = 0
    # while contains(getBoard(driver), 0) do
    #     count += 1
    #     puts 'waiting no 0'
    #     sleep(0.1 * count * count)
    # end

    # count = 0
    # while b0 == getBoard(driver) do
    #     count += 1
    #     puts 'waiting board change'
    #     sleep(0.1 * count * count)
    # end

    # puts 'board now in waitForChange'
    # display(getBoard(driver))
end

# driver.find_element(class: "tile-container").attribute("innerHTML")
# driver.find_element(class: "tile-container").text

def newBoardLooksRight(b0, bA, direction, driver)


    b1 = swipeBoard(direction, b0)

    puts ' in newBoardLooksRight '
    puts 'b0:'
    print b0 
    puts ''
    display(b0)
    puts 'b1:'
    print b1
    puts ''
    display(b1)
    puts 'bA:'
    print bA 
    puts ''
    display(bA)
    puts 'direction:'
    puts direction

    puts b0 == bA

    count = 0
    newValue = 0

    for r in 0..3 do
        for c in 0..3 do
            v1 = b1[r][c]
            vA = bA[r][c]
            if v1 != vA
                if v1 != nil 
                    puts 'ERROR ERROR ERROR'
                    puts 'wtf values are diff but v1 not nil'
                    puts 'current board:'
                    sleep(0.1)
                    newBoard = getBoard(driver)
                    display(newBoard)
                    return newBoard
                end
                count += 1
                newValue = vA 
            end
        end
    end
    if count > 1
        puts 'ERROR ERROR ERROR'
        puts 'count > 1 !!!'
        puts 'current board:'
        sleep(1)
        newBoard = getBoard(driver)
        display(newBoard)
        # raise 'count > 1 !!!'
        return newBoard
    end
    # return newValue
    return bA
end
