defmodule AdventOfCode.Fourteen do
  use Bitwise

  def problem do
    File.read!("./assets/14.txt")
    |> String.split("\n")
    |> parse()
    |> execute(%{}, [])
    |> Map.values()
    |> Enum.sum()
  end

  def problem_bis do
  end

  defp parse(list) do
    list
    |> Enum.reverse()
    |> Enum.reduce([], fn cmd, acc -> [parse_cmd(cmd) | acc] end)
  end

  defp parse_cmd("mask = " <> mask), do: {:chg_mask, String.graphemes(mask)}

  defp parse_cmd("mem[" <> rest) do
    {ptr, "] = " <> str_val} = Integer.parse(rest)
    {:chg_mem, {ptr, String.to_integer(str_val)}}
  end

  defp execute([], mem, _mask), do: mem

  defp execute([cmd | rest], mem, mask) do
    {mem, mask} = execute_cmd(cmd, mem, mask)

    execute(rest, mem, mask)
  end

  defp execute_cmd({:chg_mask, mask}, mem, _mask), do: {mem, mask}

  defp execute_cmd({:chg_mem, {ptr, raw_val}}, mem, mask) do
    val = apply_mask(mask, raw_val)
    {Map.put(mem, ptr, val), mask}
  end

  defp execute_cmd(_, mem, mask), do: {mem, mask}

  def apply_mask(mask, i) do
    mask
    |> deconstruct(i)
    |> Enum.reduce(0, fn
      {"X", i}, acc -> (acc + i) <<< 1
      {"1", _i}, acc -> (acc + 1) <<< 1
      {"0", _i}, acc -> acc <<< 1
    end) >>> 1
  end

  def deconstruct(mask, i), do: mask |> Enum.reverse() |> deconstruct(i, [])

  def deconstruct([], _i, acc), do: acc
  def deconstruct([h | t], i, acc), do: deconstruct(t, div(i, 2), [{h, rem(i, 2)} | acc])

  def zip(mask, bin) do
  end
end

#IO.puts "first half answer : #{AdventOfCode.Fourteen.problem}"
#IO.puts "second half answer : #{AdventOfCode.Fourteen.find_my_seat}"
