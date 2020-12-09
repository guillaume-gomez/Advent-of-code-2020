defmodule AdventOfCode.Nine do
    @size 25

    defp read_file do
        File.read!("./assets/9.txt")
        |> String.split("\n")
        |> Enum.map(fn x -> String.to_integer(x) end)
    end

    def christmas_weakness do
        read_file()
        |> iterate(@size)
    end

    def final_step_christmas_weakness do
        inputs = read_file()
        value = iterate(inputs, @size)
        find_contiguous(inputs, value)
    end

    defp preambles(inputs, size) do
       Enum.take(inputs, size)
    end

    defp calculated_input(inputs, size) do
        [value | _ ] = Enum.drop(inputs, size)
        value
    end

    defp is_sum_of_preamble(preambles, value) do
        Enum.map(preambles, fn x ->
            {x, value - x} 
        end) 
        |> Enum.find(fn {x, y} ->
            y in preambles && y != x && x + y == value
        end)
        |> is_tuple
    end

    defp iterate(inputs, size) do
        iterate(inputs, calculated_input(inputs, size) , size)
    end

    defp iterate([head | tail], value, size) do
        #IO.inspect tail
        case is_sum_of_preamble(preambles([head | tail], size), value) do
            false -> value
            true -> iterate(tail, calculated_input(tail, size), size)
        end
    end

    defp find_contiguous(inputs, value) do
        find_contiguous(inputs, inputs, 0, [], value)
    end

    defp find_contiguous([_inputsHead | inputsTail], _current_list, acc, _visited, value) when acc > value do
        find_contiguous(inputsTail, inputsTail, 0, [], value)
    end

    defp find_contiguous(inputs, [subInputsHead | subInputsTail], acc, visited, value) when acc < value do
        find_contiguous(inputs, subInputsTail, acc + subInputsHead, [subInputsHead | visited], value)
    end

    defp find_contiguous(_inputs, _subInputs,  acc, visited, value) when acc == value do
        Enum.min(visited) + Enum.max(visited)
    end

    defp find_contiguous([], _, _acc, _visited,  _value) do
        {:error}
    end

    defp find_contiguous(_, [], _acc, _visited, _value) do
        {:error}
    end
end

IO.puts "first half answer : #{AdventOfCode.Nine.christmas_weakness}"
IO.puts "second half answer : #{AdventOfCode.Nine.final_step_christmas_weakness}"