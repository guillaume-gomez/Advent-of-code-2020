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
        { _, _, acc } = instructions |> loop
        acc
    end

    def corrupted_program do
        { instructions, _} = read_file()
        
        {_, _, acc} = find_corrupted_program(instructions, collect_corrupted_command(instructions))
        acc
    end

    def loop(instructions) do
        loop(instructions, 0, 0, [], 1)
    end

    def loop(_, index, acc, _, 650) do
        { :error, index, acc }
    end

    def loop(_, :end, acc, _visited, _max_iteration) do
        { :end, :end, acc }
    end

    def loop(instructions, index, acc, visited, max_iteration) do
        { new_index, new_acc } = Map.get(instructions, index) 
            |> execute(index, acc)
        case new_index in visited do
            true -> {:loop, new_index, new_acc }
            false -> loop(instructions, new_index, new_acc, [new_index | visited], max_iteration + 1)
        end
    end

    def collect_corrupted_command(instructions) do
        Enum.filter(instructions, fn { _key, {instruction, _ }} -> instruction == :nop || instruction == :jmp end)
    end

    def find_corrupted_program(instructions, collect_corrupted_command) do
        Enum.map(collect_corrupted_command, fn {index, instruction} -> 
            instructions_modified = Map.replace(instructions, index, invert_command(instruction))
            loop(instructions_modified, 0, 0, [], 1)
        end)
        |> Enum.find(fn {tuple_result, _, _acc} ->
            tuple_result == :end
        end)
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

    def execute(_instruction, _index, acc) do
        { :end, acc }
    end

    def invert_command({ :nop, arg }) do
        { :jmp, arg }
    end

    def invert_command({ :jmp, arg }) do
        { :nop, arg }
    end


end

IO.puts "first half answer : #{AdventOfCode.Eight.infinite_loop}"
IO.puts "second half answer : #{AdventOfCode.Eight.corrupted_program}"