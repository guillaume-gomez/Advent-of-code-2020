defmodule AdventOfCode.Four do
    defp read_file do
        File.read!("./assets/4.txt")
        |> String.split("\n\n")
        |> Enum.map(fn x -> String.replace(x, "\n", " ") end)
    end

    defp required_fields do
        ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid", "cid"]
    end

    defp password_string_to_map(password_string) do
        password_array = Enum.map(password_string, fn x ->
            [key, value] = String.split(x, ":")
            {String.to_atom(key), value }
        end)
        Enum.into(password_array, %{})
    end

    defp check_passport_values(password_map) do
        check_byr(String.to_integer(password_map[:byr]))
        &&
        check_iyr(String.to_integer(password_map[:iyr]))
        &&
        check_eyr(String.to_integer(password_map[:eyr]))
        &&
        check_hgt(password_map[:hgt])
        &&
        check_hcl(password_map[:hcl])
        &&
        check_ecl(password_map[:ecl])
        &&
        check_passport_id(password_map[:pid])
    end

    defp check_byr(value) do
        value >= 1920 && value <= 2002
    end

    defp check_iyr(value) do
        value >= 2010 && value <= 2020
    end

    defp check_eyr(value) do
        value >= 2020 && value <= 2030
    end

    defp check_hgt(value) do
        [[ _, height, dimension]] = Regex.scan(~r/(\d+)(\w+)/, value)
        height_to_i = String.to_integer(height)
        case dimension do
            "in" -> height_to_i >= 59 && height_to_i <= 76
            "cm" -> height_to_i >= 150 && height_to_i <= 193
            _ -> false
        end
    end

    defp check_hcl(value) do
        Regex.match?(~r/^#[0-9a-f]{6}$/, value)
    end

    defp check_ecl(value) do
        Regex.match?(~r/amb|blu|brn|gry|grn|hzl|oth/, value)
    end

    defp check_passport_id(value) do
        Regex.match?(~r/^\d{9}$/, value)
    end

    defp passwords_with_required_fields() do
        Enum.filter(read_file(), fn line -> 
            password_keys = String.split(line, " ")
            |> Enum.map(fn x -> hd(String.split(x, ":"))end)

            diff = required_fields() -- password_keys
            diff_length = length(diff)

            diff_length == 0 || diff_length == 1 && Enum.member?(diff, "cid")
        end)
    end

    defp password_with_checked_values do
        Enum.filter(passwords_with_required_fields(), fn line ->
            password_map = String.split(line, " ")
            |> password_string_to_map
            check_passport_values(password_map)
        end)
    end

    def check_passports do
        length(passwords_with_required_fields())
    end

    def check_passports_bis do
        length(password_with_checked_values())
    end
end

IO.puts "first half answer : #{AdventOfCode.Four.check_passports}"
IO.puts "second half answer : #{AdventOfCode.Four.check_passports_bis}"