defmodule AdventOfCode.Sixteen do

  def read_file do
    [rules_str, ticket_str, other_tickets_str] = File.read!("./assets/16.txt")
    |> String.split("\n\n")

    Map.merge(
      Map.merge(
        parse_rules(rules_str),
        parse_tickets(ticket_str)
      ),
      parse_other_tickets(other_tickets_str)
    )
  end

  def parse_rules(rules_str) do
    rules = String.split(rules_str, "\n")
    |> Enum.reduce(%{}, fn str, acc ->
      [name, a, b, c, d] = String.split(str, [": ", "-", " or "])
      Map.put(acc, name, [
        {
          String.to_integer(a),
          String.to_integer(b)
        },
        {
          String.to_integer(c),
          String.to_integer(d)
        }
      ])
    end)
    %{ rules: rules }
  end

  def parse_tickets(ticket_str) do
    [_, ticket_values] = String.split(ticket_str, "\n")
    ticket_values_integers = String.split(ticket_values, ",")
    |> Enum.map(&String.to_integer/1)

    %{ ticket: ticket_values_integers }
  end

  def parse_other_tickets(other_tickets_str) do
    [_| other_tickets_values] = String.split(other_tickets_str, "\n")
    other_tickets_array = Enum.reduce(other_tickets_values, [], fn x,acc ->
      [
        String.split(x, ",")
        |>  Enum.map(&String.to_integer/1)
        | acc
      ]
    end)
    
    %{ other_tickets: other_tickets_array }
  end



  def problem do
    %{ other_tickets: other_tickets_array, rules: rules } = read_file()
    Enum.reduce(other_tickets_array, 0, fn ticket_array, acc ->
      acc + check_ticket(ticket_array, rules)
    end)
  end

  def check_ticket(ticket_array, rules) do
    Enum.map(ticket_array, fn ticket_value ->
      validate_rules = Enum.map(rules, fn {rule_name, rule_data} ->
        check_rule(ticket_value, rule_data)
      end)

      case Enum.all?(validate_rules, fn state -> state == false end) do
        true -> ticket_value
        false -> 0
      end
    end)
    |> Enum.sum()
  end

  def check_rule(ticket_value, [{min, max}, {min1, max1}] )
    when ticket_value >= min and ticket_value <= max or ticket_value >= min1 and ticket_value <= max1
   do
    true
  end

  def check_rule(_ticket_value, _rule) do
    false
  end

end

#IO.puts "first half answer : #{AdventOfCode.Fourteen.problem}"
