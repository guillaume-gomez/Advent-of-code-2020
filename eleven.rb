class Eleven

    OCCUPIED = "#"
    FREE = "L"
    FLOOR = "."

    def initialize(path)
        file = File.open(path)
        @board = file.read.split.map do |line|
            line.split('')
        end
        file.close
        @width = @board[0].count
        @height = @board.count
    end

    def get_adjacents(x, y)
        {
            up: y - 1 >= 0 ? @board[y-1][x] : nil,
            down: y + 1 < @height ? @board[y+1][x] : nil,
            left: x -1 >= 0 ? @board[y][x-1] : nil,
            right: x + 1 < @width ? @board[y][x+1] : nil,
            up_left: y-1 >= 0 && x-1 >= 0 ? @board[y-1][x-1] : nil,
            up_right: y-1 >= 0 && x +1 < @width ? @board[y-1][x+1] : nil,
            down_left: y + 1 < @height && x - 1 >= 0 ? @board[y+1][x-1] : nil,
            down_right: y + 1 < @height && x + 1 < @width ? @board[y+1][x+1] : nil,
        }
    end

    def get_adjacents_ray(x, y)
        {
            up: y - 1 >= 0 ? run_ray(x, y, 0, -1) : nil,
            down: y + 1 < @height ? run_ray(x, y, 0, 1) : nil,
            left: x -1 >= 0 ? run_ray(x, y, -1, 0) : nil,
            right: x + 1 < @width ? run_ray(x, y, 1, 0) : nil,
            up_left: y-1 >= 0 && x-1 >= 0 ? run_ray(x, y, -1, -1) : nil,
            up_right: y-1 >= 0 && x +1 < @width ? run_ray(x, y, 1, -1) : nil,
            down_left: y + 1 < @height && x - 1 >= 0 ? run_ray(x, y, -1, 1) : nil,
            down_right: y + 1 < @height && x + 1 < @width ? run_ray(x, y, 1, 1) : nil,
        }
    end

    def move(pb_version)
        rule = pb_version == 1 ? 4 : 5
        new_board = @board.map.with_index do |lines, y|
            lines.map.with_index do | letter, x |
                adjacents = (pb_version == 1) ? get_adjacents(x, y) : get_adjacents_ray(x, y)
                case letter
                when OCCUPIED
                    occupied_to_empty?(x, y, adjacents, rule) ? FREE : OCCUPIED
                when FREE
                    empty_to_occupied?(x, y, adjacents) ? OCCUPIED : FREE
                else
                    letter
                end
            end
        end
    end

    def moves(pb_version)
        nb_move = -1
        has_chaos = true
        while(has_chaos) do
            new_board = move(pb_version)
            has_chaos = !no_more_chaos(@board, new_board)
            @board = new_board
            nb_move = nb_move + 1
        end
        puts "nb_move :  #{nb_move}"
    end

    def move_with_print(pb_version)
        print_board(move(pb_version))
    end

    def empty_to_occupied?(x, y, adjacents)
        have_occupied = adjacents.values.any?{ |adj| adj == OCCUPIED}
        !have_occupied
    end

    def occupied_to_empty?(x, y, adjacents, rule)
        number_of_occupied = adjacents.values.count{ | adj| adj == OCCUPIED}
        number_of_occupied >= rule
    end

    def print_board(board = @board)
        puts "---------------"
        board.each do |lines|
            puts lines.join()
        end
        puts "---------------"
    end

    def no_more_chaos(arr1, arr2)
        arr1.select.each_with_index { |item, index|
          arr2[index] != item
        }.count == 0
    end

    def nb_occupied()
        @board.flatten.select { |c| c == OCCUPIED}.count
    end

    def run_ray(x,y, direction_x, direction_y)
        current_x = x
        current_y = y
        current_observed_value = FLOOR
        while current_observed_value != nil &&
              current_observed_value != OCCUPIED &&
              current_observed_value != FREE &&
              current_observed_value == FLOOR do
            if (current_y + direction_y) >= 0 && (current_y + direction_y) < @height &&
               (current_x + direction_x) >= 0 && (current_x + direction_x) < @width
                current_observed_value = @board[current_y + direction_y][current_x + direction_x]
            else
                current_observed_value = nil
            end
            current_x = current_x + direction_x
            current_y = current_y + direction_y
        end
        current_observed_value
    end

end

instance = Eleven.new("assets/11.txt")
instance.moves(1)
instance.print_board
puts "first half answer : #{instance.nb_occupied}"

instance = Eleven.new("assets/11.txt")
instance.moves(2)
instance.print_board
puts "second half answer : #{instance.nb_occupied}"
