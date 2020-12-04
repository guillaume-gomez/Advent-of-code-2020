defmodule AdventOfCode.Four do
    def read_file do
        File.read!("./assets/4.txt")
        |> String.split("\n\n")
        |> Enum.map(fn x -> String.replace(x, "\n", " ") end)
    end

    def required_fields do
        ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid", "cid"]
    end

    def check_passports do
        Enum.reduce(read_file(), 0, fn line, acc ->
            password_keys = String.split(line, " ")
            |> Enum.map(fn x -> hd(String.split(x, ":"))end)

            diff = required_fields() -- password_keys
            diff_length = length(diff)
            cond do
                diff_length == 0 -> acc + 1
                diff_length == 1 && Enum.member?(diff, "cid") -> acc + 1
                true -> acc
            end
        end)
    end
end

IO.inspect AdventOfCode.Four.check_passports
# |> Map.new(&List.to_tuple/1)