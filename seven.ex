defmodule AdventOfCode.Seven do
    defp read_file do
        File.read!("./assets/7.txt")
        |> String.split("\n")
    end

    def problem do
        rules = read_file()
        |> Enum.reduce(%{}, fn line, map ->
            {color, rule} = parse_rule(line)
            Map.put(map, color, rule)
        end)


        find_parents(rules, "shiny gold")
        |> length

    end

    defp parse_rule(str) do
        [color, "contain " <>rest] = String.split(str, " bags ", parts: 2)
        {color, parse_list(rest)}
    end

    defp parse_list("no other bags.") do
        []
    end

    defp parse_list(list) do
        list
        |> String.trim(".")
        |> String.split(", ")
        |> Enum.map(fn bags ->
            {count, " " <> rest} = Integer.parse(bags)
            [color | _] = rest |> String.split(" bag")

            {count, color}
        end)
    end

    defp find_parents(rules, color) do
        find_parents(rules, color, [], [color])
    end

    defp find_parents(_rules, nil, result, _visited) do
        result
    end

    defp find_parents(rules, bag, result, visited) do
        nodes = Enum.reduce(rules, [], fn {key, list}, acc ->
            Enum.reduce(list, acc, fn x, acc2 ->
                case x do
                    {_, ^bag} -> [key | acc2]
                    _  -> acc2
                end
            end)
        end)
        new_result = Enum.uniq(nodes ++ result)
        new_color = List.first(new_result -- visited)
        find_parents(rules, new_color, new_result, [bag | visited])
    end

    
end
