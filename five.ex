defmodule AdventOfCode.Five do
    defp read_file do
        File.read!("./assets/5.txt")
        |> String.split("\n")
    end

    def binary_to_decimal_bording_pass(boarding_pass) do
        row = String.slice(boarding_pass, 0, 7)
        |> to_charlist
        |> compute(0, 127)
        
        column = String.slice(boarding_pass, 7, 9)
        |> to_charlist
        |> compute(0, 7)
        #IO.inspect "#{row}, #{column}"
        [row, column]
    end

    def convert_binary_boarding do
        Enum.map(read_file(), fn x -> binary_to_decimal_bording_pass(x) end)
    end

    def highest_seat_id do
        Enum.reduce(convert_binary_boarding(), 0, fn [row, column], acc ->
            seat_id = (row * 8 + column)
            if acc < seat_id do
                seat_id
            else
                acc
            end
        end)
    end

    def compute([letter_charlist|[]], min, max) do
        letter = List.to_string([letter_charlist])
        #IO.inspect "#{min}, #{max} -> #{letter}"
        case letter do
            "B" -> max
            "F" -> min
            "L" -> min
            "R" -> max
        end
    end

    def compute([letter_charlist | rest], min, max) do
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
#IO.puts "second half answer : #{AdventOfCode.Five.check_passports_bis}"
