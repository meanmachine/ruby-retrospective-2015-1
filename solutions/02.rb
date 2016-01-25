def game_field_matrix(dimensions)
  game_field_column = (0...dimensions[:width] ).to_a
  game_field_row    = (0...dimensions[:height]).to_a
  game_field_row.product game_field_column
end

def move_head(snake, direction)
  Array.new(2) { |index| snake.last[index] + direction[index] }
end

def move(snake, direction)
  grow(snake, direction).drop 1
end

def grow(snake, direction)
  snake + [move_head(snake, direction)]
end

def new_food(food, snake, dimensions)
  (game_field_matrix(dimensions) - food - snake).shuffle.first
end

def obstacle_ahead?(snake, direction, dimensions)
  snake_head        = move_head(snake, direction)
  board_matrix      = game_field_matrix(dimensions)
  head_inside_board = board_matrix.include? snake_head
  head_bite_snake   = snake.include? snake_head
  (not head_inside_board) or head_bite_snake
end

def danger?(snake, direction, dimensions)
  snake_head  = move_head(snake, direction)
  first_move  = obstacle_ahead?(snake, direction, dimensions)
  second_move = obstacle_ahead?(snake + [snake_head], direction, dimensions)
  first_move or second_move
end