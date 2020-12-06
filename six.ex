defmodule AdventOfCode.Six do
    defp read_file do
        File.read!("./assets/6.txt")
        |> String.split("\n\n")
    end

    defp count_group_answers(group) do
        String.replace(group, "\n", "")
        |> to_charlist
        |> Enum.uniq
        |> length
    end

    defp count_group_answers_fulfill(group) do
        Enum.map(String.split(group, "\n"), fn x ->
            MapSet.new(to_charlist(x))
        end)
        |> Enum.reduce(&MapSet.intersection/2)
        |> MapSet.size
    end


    def sum_of_groups_answers do
        Enum.reduce(read_file(), 0, fn group, acc -> 
            acc + count_group_answers(group)
        end)
    end

    def sum_of_groups_answers_bis do
        Enum.map(read_file(), fn group ->
            count_group_answers_fulfill(group)
        end)
        |> Enum.sum
    end


end

IO.puts "first half answer : #{AdventOfCode.Six.sum_of_groups_answers}"
IO.puts "second half answer : #{AdventOfCode.Six.sum_of_groups_answers_bis}"