defmodule AdventOfCode.Two do
    def count_password do
        rx = ~r/(\d+)\-(\d+) (\w): (\w+)/
        passwords = Regex.scan(rx, File.read!("./assets/2.txt"))
        IO.inspect passwords
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
end

AdventOfCode.Two.count_password