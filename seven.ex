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

    def problem_bis do
        rules = read_file()
        |> Enum.reduce(%{}, fn line, map ->
            {color, rule} = parse_rule(line)
            Map.put(map, color, rule)
        end)

        count_bags(rules, "shiny gold")
        |> Map.get("shiny gold")
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

    def count_bags(rules, bag) do
        count_bags(rules, bag, %{})
    end

    def count_bags(rules, bag, bags_sizes) do
        { size, new_bags_sizes } = rules
        |> Map.get(bag)
        |> Enum.reduce({ 0, bags_sizes }, fn {count, bag}, { sum, bags_sizes } ->
            { size, new_bags_sizes } =
            case Map.fetch(bags_sizes, bag) do
                {:ok, size} ->  { size, bags_sizes }
                :error ->
                    new_bags_sizes = count_bags(rules, bag, bags_sizes)
                    size = Map.get(new_bags_sizes, bag)
                    { size, new_bags_sizes }
            end

            { count * (1 + size) + sum, new_bags_sizes }
        end)
        Map.put(new_bags_sizes, bag, size)
    end
end

IO.puts "first half answer : #{AdventOfCode.Seven.problem}"
IO.puts "second half answer : #{AdventOfCode.Seven.problem_bis}"
