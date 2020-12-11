defmodule AdventOfCode.Ten do
    defp read_file do
        File.read!("./assets/10.txt")
        |> String.split("\n")
        |> Enum.map(fn x -> String.to_integer(x) end)
        |> Enum.sort
    end

    def adapters_differences do
        {_, %{1=> oneDiff, 3=> threeDiff} } =  read_file()
        |> Enum.reduce( {0, %{1=>0, 3=>1}}, fn x, {current_charger, map} ->
            key = x - current_charger
            {
              x,
              Map.put(map, key, Map.get(map, key) + 1)
            }
        end)
        oneDiff * threeDiff
    end

end

#IO.puts "first half answer : #{AdventOfCode.Ten}"
#IO.puts "second half answer : #{AdventOfCode.Ten}"