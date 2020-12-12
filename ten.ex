defmodule AdventOfCode.Ten do
    defp read_file do
        File.read!("./assets/10.txt")
        |> String.split("\n")
        |> Enum.map(fn x -> String.to_integer(x) end)
        |> Enum.sort
    end

    def adapters_differences do
        {_, %{1=> oneDiff, 3=> threeDiff} } = read_file()
        |> Enum.reduce( {0, %{1=>0, 3=>1}}, fn x, {current_charger, map} ->
            key = x - current_charger
            {
              x,
              Map.put(map, key, Map.get(map, key) + 1)
            }
        end)

        oneDiff * threeDiff
    end

    def adapters_combinaison do
        adapters = read_file()
        adaptersWithMax = Enum.concat(adapters, [Enum.max(adapters) + 3])

        {_ , result, _ } = Enum.reduce(adaptersWithMax, {0, 1, 1}, fn x, { current_charger, multiplier, current_combo } ->
            key = x - current_charger
            case key do
                1 -> { x, multiplier, current_combo + 1}
                3 -> { x, multiplier * tribonnacci(current_combo), 1}
            end
        end)
        result
    end

    def tribonnacci(number) do
        tribonnacci_sequence = %{ 1=> 1, 2=> 1, 3=> 2, 4=> 4, 5=> 7, 6=> 13, 7=> 24, 8=> 44, 9=> 81, 10=> 149 }
        Map.get(tribonnacci_sequence, number)
    end
end

IO.puts "first half answer => #{AdventOfCode.Ten.adapters_differences}"
IO.puts "second half answer => #{AdventOfCode.Ten.adapters_combinaison}"