defmodule AdventOfCode.Thirteen do
    defp read_file do
        File.read!("./assets/13.txt")
        |> String.split("\n")
    end

    def problem do
        [timestamp, notes] = read_file()

        bus_ids = String.split(notes, ",") |>
        Enum.filter(fn x -> x != "x" end) |>
        Enum.map(fn x -> String.to_integer(x) end)
        
        timestamp_number = String.to_integer(timestamp)
        
        [bus_timestamp, bus_id] = Enum.map(bus_ids, fn note ->
            find_next_timestamp(note, timestamp_number)
        end)
        |> Enum.min

        bus_id * (bus_timestamp - timestamp_number)
    end

    def find_next_timestamp(bus_id, timestamp)  do
        [bus_id * div(timestamp, bus_id) + bus_id, bus_id]
    end


    def problem_bis do
        [timestamp, notes] = read_file()

        busses = String.split(notes, ",")
        |> Enum.map(fn x ->
            case x do
                "x" -> x
                _ -> String.to_integer(x)
            end
        end)

        next_sequence(busses)
    end

    def remainder(mods, remainders) do
        max = Enum.reduce(mods, fn x,acc -> x*acc end)
        Enum.zip(mods, remainders)
        |> Enum.map(fn {m,r} -> Enum.take_every(r..max, m) |> MapSet.new end)
        |> Enum.reduce(fn set,acc -> MapSet.intersection(set, acc) end)
        |> MapSet.to_list
    end


    def next_sequence(busses) do
        busses
        |> Enum.with_index()
        |> Enum.reduce({0, 1}, &add_to_sequence/2)
        |> elem(0)
    end

    defp add_to_sequence({"x", _index}, state), do: state
    
    defp add_to_sequence({bus, index}, {t, step}) do
        if Integer.mod(t + index, bus) == 0 do
          {t, lcm(step, bus)}
        else
          add_to_sequence({bus, index}, {t + step, step})
        end
    end

    defp lcm(a, b) do
        div(a * b, Integer.gcd(a, b))
    end



end

# IO.puts "first half answer : #{AdventOfCode.Thirteen.problem}"
# IO.puts "second half answer : #{AdventOfCode.Thirteen.problem_bis}"