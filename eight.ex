defmodule AdventOfCode.Eight do
    defp read_file do
        File.read!("./assets/8.txt")
        |> String.split("\n")
        |> Enum.reduce( {%{}, 0}, fn line, {acc, index} ->
            [function, arg] = String.split(line, " ")

            {
                Map.put(acc, index , { String.to_atom(function), String.to_integer(arg) }),
                index + 1
            }
        end)
    end

    def infinite_loop do
        { instructions, _} = read_file()
        instructions
        |> loop

    end

    def loop(instructions) do
        loop(instructions, 0, 0, [], 1)
    end

    def loop(_, _, _, _, 650) do
        IO.inspect("infinile loop")
    end


    def loop(instructions, index, acc, visited, max_iteration) do
        { new_index, new_acc } = Map.get(instructions, index) 
            |> execute(index, acc)
        case new_index in visited do
            true -> new_acc
            false -> loop(instructions, new_index, new_acc, [new_index | visited], max_iteration + 1)
        end
    end


    def execute({ :nop, _arg }, index, acc) do
        { index + 1 , acc }
    end

    def execute({ :acc, arg }, index, acc) do
        { index + 1, acc + arg}
    end

    def execute({ :jmp, arg }, index, acc) do
        { index + arg, acc }
    end

end

#AdventOfCode.Eight.infinite_loop