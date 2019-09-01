load 'engine2048.rb'

# board = [   [1, 2, nil, 4], 
#             [2, 2, nil, 4], 
#             [1, 1, nil, 1], 
#             # [nil,nil,nil,nil], 
#             [2, 2, nil, nil]]



#             board = [   
#                 [nil, nil, nil, nil], 
#                 [nil, nil, nil, nil], 
#                 [nil, nil, nil, nil], 
#                 [nil, nil, nil, nil], 
#                 [nil, nil, nil, nil]
#             ]


board = [   
            [nil, nil, 2, 2], 
            [nil, nil, nil, nil], 
            [nil, nil, nil, nil], 
            [nil, nil, nil, nil], 
            [nil, nil, nil, nil]
        ]

        
display(board)


for i in 0..1000 do
   bestDirection = superBestMove(i, board)

    
    puts i.to_s + '. ' + bestDirection
    board = swipeBoard(bestDirection, board)
    board = placeNewTile(board)
    display(board)
end
