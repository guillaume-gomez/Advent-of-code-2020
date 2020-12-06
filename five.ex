defmodule AdventOfCode.Five do
    defp read_file do
        File.read!("./assets/5.txt")
        |> String.split("\n")
    end

    defp binary_to_decimal_bording_pass(boarding_pass) do
        row = String.slice(boarding_pass, 0, 7)
        |> to_charlist
        |> compute(0, 127)
        
        column = String.slice(boarding_pass, 7, 9)
        |> to_charlist
        |> compute(0, 7)
        #IO.inspect "#{row}, #{column}"
        [row, column]
    end

    defp seat_id(row, column) do
        (row * 8 + column)
    end

    defp convert_binary_boarding do
        Enum.map(read_file(), fn x -> binary_to_decimal_bording_pass(x) end)
    end

    def highest_seat_id do
        Enum.reduce(convert_binary_boarding(), 0, fn [row, column], acc ->
            seat_id = seat_id(row, column)
            if acc < seat_id do
                seat_id
            else
                acc
            end
        end)
    end

    def find_my_seat do
        seats = Enum.map(convert_binary_boarding(), fn [row, column] -> seat_id(row, column) end)
        
        min_seat_id = Enum.min(seats)
        max_seat_id = Enum.max(seats)
        
        seat_in_charlist = Enum.to_list(min_seat_id..max_seat_id) -- seats
        hd(seat_in_charlist)
    end

    defp compute([letter_charlist|[]], min, max) do
        letter = List.to_string([letter_charlist])
        #IO.inspect "#{min}, #{max} -> #{letter}"
        case letter do
            "B" -> max
            "F" -> min
            "L" -> min
            "R" -> max
        end
    end

    defp compute([letter_charlist | rest], min, max) do
        letter = List.to_string([letter_charlist])
        case letter do
            "B" -> compute(rest, 1 + div(min + max, 2), max)
            "F" -> compute(rest, min,      div(min + max, 2))
            "L" -> compute(rest, min,      div(min + max, 2))
            "R" -> compute(rest, 1 + div(min + max, 2), max)
        end
    end

end

IO.puts "first half answer : #{AdventOfCode.Five.highest_seat_id}"
IO.puts "second half answer : #{AdventOfCode.Five.find_my_seat}"
