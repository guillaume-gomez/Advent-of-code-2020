defmodule AdventOfCode.Two do
    def read_file do
        rx = ~r/(\d+)\-(\d+) (\w): (\w+)/
        Regex.scan(rx, File.read!("./assets/2.txt"))
    end

    def count_password do
        passwords = read_file()
        result = Enum.reduce(passwords, 0, fn line, acc ->
            [_, min, max, letter, password] = line
            <<letter_ascii::utf8>> = letter
            count = Enum.count(String.to_charlist(password), fn x -> x == letter_ascii end)
            if count >= String.to_integer(min) && count <= String.to_integer(max) do
                acc + 1
            else
                acc
            end
        end)
        IO.inspect result
    end

    def count_password_bis do
        passwords = read_file()
        result = Enum.reduce(passwords, 0, fn line, acc ->
            [_, min, max, letter, password] = line
            min_index = String.to_integer(min) - 1
            max_index = String.to_integer(max) - 1
            if (letter == String.at(password, min_index)) != (letter == String.at(password, max_index)) do
                acc + 1
            else
                acc
            end
        end)
        IO.inspect result
    end
end

AdventOfCode.Two.count_password_bis