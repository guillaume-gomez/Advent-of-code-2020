defmodule AdventOfCode.Twelve do
    defp read_file do
        File.read!("./assets/12.txt")
        |> String.split("\n")
        |> Enum.map(fn x ->
            [letter, number_stringified ] = String.split(x, "", parts: 2, trim: true)
            {String.to_atom(letter), String.to_integer(number_stringified)}
        end)
    end

    def problem do
        { _direction, west, north, east, south} = read_file()
        |> move()
        {x, y} = manhattan_distance(west, north, east, south)
        x + y
    end

    def problem_bis do
        [_, { west, north, east, south }] = read_file()
        |> move_relative()
        {x, y} = manhattan_distance(west, north, east, south)
        x + y
    end

    defp move_relative(instructions) do
        # acc = { waypoint, ship_pos }
        Enum.reduce(instructions, [{ 0, 1, 10, 0 }, {0, 0, 0, 0}], fn instruction, [waypoint, ship_pos] ->
            move_relative(instruction, waypoint, ship_pos)
        end)
    end

    defp move(instructions) do
        # acc = { facing_direction, west, north, east, south }
        Enum.reduce(instructions, { :east, 0, 0, 0, 0 }, fn instruction, acc ->
            move(instruction, acc)
        end)
    end

    defp manhattan_distance(west, north, east, south) do
        { abs(west - east), abs(north - south)}
    end

    defp move( {letter, number}, {facing_direction, west, north, east, south}) do
        case letter do
            :N -> { facing_direction, west, north + number, east, south }
            :S -> { facing_direction, west, north, east, south + number }
            :E -> { facing_direction, west, north, east + number, south }
            :W -> { facing_direction, west + number, north, east, south }
            :L -> { rotate(:L, number, facing_direction), west, north, east, south }
            :R -> { rotate(:R, number, facing_direction), west, north, east, south }
            :F -> 
                { new_west, new_north, new_east, new_south } = forward(facing_direction, number, west, north, east, south)
                { facing_direction, new_west, new_north, new_east, new_south }
        end
    end

    defp move_relative({letter, number}, {west_waypoint, north_waypoint, east_waypoint, south_waypoint}, ship_pos) do
        case letter do
            :N -> [{ west_waypoint, north_waypoint + number, east_waypoint, south_waypoint }, ship_pos]
            :S -> [{ west_waypoint, north_waypoint, east_waypoint, south_waypoint + number }, ship_pos]
            :E -> [{ west_waypoint, north_waypoint, east_waypoint + number, south_waypoint }, ship_pos]
            :W -> [{ west_waypoint + number, north_waypoint, east_waypoint, south_waypoint }, ship_pos]
            :L -> [rotate_waypoint(:L, number, {west_waypoint, north_waypoint, east_waypoint, south_waypoint}), ship_pos]
            :R -> [rotate_waypoint(:R, number, {west_waypoint, north_waypoint, east_waypoint, south_waypoint}), ship_pos]
            :F -> 
                { west, north, east, south } = ship_pos
                [{west_waypoint, north_waypoint, east_waypoint, south_waypoint},
                 { west_waypoint * number + west, north_waypoint * number + north, east_waypoint * number + east, south_waypoint * number + south }
                ]
        end
    end

    defp rotate(:L, 90, :north), do: :west
    defp rotate(:L, 90, :west), do: :south
    defp rotate(:L, 90, :south), do: :east
    defp rotate(:L, 90, :east), do: :north

    defp rotate(:R, 90, :north), do: :east
    defp rotate(:R, 90, :east), do: :south
    defp rotate(:R, 90, :south), do: :west
    defp rotate(:R, 90, :west), do: :north

    defp rotate(:L, 270, direction), do: rotate(:R, 90, direction)
    defp rotate(:R, 270, direction), do: rotate(:L, 90, direction)

    defp rotate(_direction, 180, :north), do: :south
    defp rotate(_direction, 180, :south), do: :north
    defp rotate(_direction, 180, :east), do: :west
    defp rotate(_direction, 180, :west), do: :east


    defp rotate_waypoint(:L, 90, {west, north, east, south}), do: {north, east, south, west}
    defp rotate_waypoint(:R, 90, {west, north, east, south}), do: {south, west, north, east}
    defp rotate_waypoint(_direction, 180, {west, north, east, south}), do: {east, south, west, north}
    defp rotate_waypoint(:L, 270, waypoint), do: rotate_waypoint(:R, 90, waypoint)
    defp rotate_waypoint(:R, 270, waypoint), do: rotate_waypoint(:L, 90, waypoint)



    defp forward(:north, number, west, north, east, south), do: { west, north + number, east, south }
    defp forward(:west, number,  west, north, east, south), do: { west + number, north, east, south }
    defp forward(:east, number,  west, north, east, south), do: { west, north, east + number, south }
    defp forward(:south, number, west, north, east, south), do: { west, north, east, south + number }



end

IO.puts "first half answer : #{AdventOfCode.Twelve.problem}"
IO.puts "second half answer : #{AdventOfCode.Twelve.problem_bis}"