defmodule AdventOfCode.Fifteen do
    defp read_file do
        File.read!("./assets/15.txt")
        |> String.split(",")
        |> Enum.map(fn x -> String.to_integer(x) end)
    end

    def find2020th do
        input = read_file()
        # setting the input number at starting number
        numbers_map = Enum.with_index(input, 1)
        |> Enum.reduce(%{}, fn {x, index}, acc ->
            Map.put(acc, x, index)
        end)

        find2020th(numbers_map, length(input)+1, List.last(input))
    end

    defp find2020th(_numbers_map, 2021, spoken) do
        spoken
    end

    defp find2020th(numbers_map, turn, spoken) do
        { new_spoken, new_numbers_map } = play_turn(numbers_map, turn, spoken)
        find2020th(new_numbers_map, turn + 1, new_spoken)
    end

    def find3000000th do
        input = read_file()
        # setting the input number at starting number
        numbers_map = Enum.with_index(input, 1)
        |> Enum.reduce(%{}, fn {x, index}, acc ->
            Map.put(acc, x, index)
        end)

        find3000000th(numbers_map, length(input)+1, List.last(input))
    end

    defp find3000000th(numbers_map, turn, spoken) do
        { new_spoken, new_numbers_map } = play_turn(numbers_map, turn, spoken)
        find3000000th(new_numbers_map, turn + 1, new_spoken)
    end
    
    defp find3000000th(_numbers_map, 30000001, spoken) do
        spoken
    end

    defp play_turn(numbers_map, turn, spoken) do
        case Map.fetch(numbers_map, spoken) do
            :error -> {
                0,
                Map.put(numbers_map, spoken, turn - 1)
            }
            {:ok, last_spoken_number } -> 
                {
                turn - 1 - last_spoken_number,
                Map.put(numbers_map, spoken, turn - 1)
            }
        end
    end

end

IO.puts "first half answer => #{AdventOfCode.Fifteen.find2020th}"
IO.puts "second half answer => #{AdventOfCode.Fifteen.find3000000th}"