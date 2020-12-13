class Eleven
    def initialize(path)
        file = File.open(path)
        @board = file.read.split.map do |line|
            line.split('')
        end
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

    def move()
        new_board = @board.map.with_index do |lines, y|
            lines.map.with_index do | letter, x |
                case letter
                when "#"
                    occupied_to_empty?(x, y) ? "L" : "#"
                when "L"
                    empty_to_occupied?(x, y) ? "#" : "L"
                else
                    letter
                end
            end
        end
    end

    def moves
        nb_move = -1
        has_chaos = true
        while(has_chaos) do
            new_board = move()
            has_chaos = !no_more_chaos(@board, new_board)
            @board = new_board
            nb_move = nb_move + 1
        end
        puts "nb_move :  #{nb_move}"
    end

    def move_with_print()
        move()
        print_board()
    end

    def empty_to_occupied?(x, y)
        adjacents = get_adjacents(x, y)
        have_occupied = adjacents.values.any?{ |adj| adj == "#"}
        !have_occupied
    end

    def occupied_to_empty?(x, y)
        adjacents = get_adjacents(x, y)
        number_of_occupied = adjacents.values.count{ | adj| adj == "#"}
        number_of_occupied >= 4
    end

    def print_board()
        puts "---------------"
        @board.each do |lines|
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
        @board.flatten.select { |c| c =="#"}.count
    end

end

instance = Eleven.new("assets/11.txt")
instance.moves
instance.print_board
instance.nb_occupied