require "selenium-webdriver" # load in the webdriver gem to interact with Selenium
load 'engine2048.rb'
load 'engineWeb.rb'
driver = Selenium::WebDriver.for :chrome

driver.navigate.to "http://2048game.com/" 

display(getBoard(driver))

# sleep(3)
b = getBoard(driver)
display(b)

twos = 0
fours = 0

for i in 0..1000 do 
    b0 = b.dup
    direction = superBestMove(i, b)
    puts i.to_s + ") best move: " + direction
    preSource = driver.find_element(class: "tile-container").attribute("innerHTML")
    # puts '---- before'
    # puts preSource
    # puts 1
    puts '----'
    puts 'about to swipe ' + direction
    uiSwipe(direction, driver)
    # puts 2


    b = getBoard(driver)

    b = waitForChange(preSource, b, driver)
    # puts 3 
    makeSureBoardIsStill(driver)
    # # puts 4




    # if contains(b, 0)
    #     puts 'found a 0 wtf!!!!!!!!!!!!!!!!!!!!'
    #     display(b)
    #     sleep(3)
    #     puts 'board after waiting'
    #     b = getBoard(driver)
    #     display(b)
    # end


    b = newBoardLooksRight(b0, b, direction, driver)
    # if newTile.to_i == 2
    #     twos += 1
    # elsif newTile.to_i == 4
    #     fours += 1
    # else
    #     raise 'new tile is !!!! ' + newTile.to_s
    # end

    # puts 'twos: ' + twos.to_s
    # puts 'fours: ' + fours.to_s 
    display(b)
end

# puts b 
# print b
# puts ''

display(b)


driver.quit



