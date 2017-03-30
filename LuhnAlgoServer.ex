defmodule LuhnAlgoServer do
  @moduledoc """
  Provides a function `start/0` to spawn an asyncronous process running in server mode.
  It can respond to two types of messages:
    {:is_full_luhn_valid, number},
    {:append_check_digit, number}

  Implements corresponding functions:
    `is_full_luhn_valid/1` - to validate a number against the algorithm,
    `append_check_digit/1` - complement a number with its corresponding check digit
  """
  @behaviour Api

  import Integer

  def start do
    spawn(&handle_messages/0)
  end

  defp handle_messages do
    receive do
      {destination, number} -> LuhnAlgoServer |> apply(destination, [number]) |> IO.inspect
    end

    handle_messages
  end

  # @spec is_full_luhn_valid(integer) :: tuple
  def is_full_luhn_valid(number) when is_integer(number) do
    expected_check_digit = rem(number, 10)

    try do
      ^expected_check_digit = div(number, 10) |> get_check_digit
      {:ok, true, expected_check_digit}
    rescue
      e -> {:error, false, e}
    end
  end

  # @spec append_check_digit(integer) :: integer
  def append_check_digit(number) when is_integer(number) do
    with prefix    <- number |> Integer.digits,
         suffix    <- number |> get_check_digit,
         full_list <- List.insert_at(prefix, -1, suffix),
         do: full_list |> Integer.undigits
  end

  defp get_check_digit(number) when is_integer(number) do
    number             |>
    Integer.digits     |>
    Enum.reverse       |>
    Enum.with_index    |>
    compute_sum        |>
    compute_unit_digit |>
    compute_check_digit
  end

  defp compute_sum(keyword_list) do
    with odd  <- keyword_list |> get_odd_list,
         even <- keyword_list |> get_even_list,
         do: odd ++ even |> Enum.sum
  end

  defp get_even_list(keyword_list) do
    for {key, val} <- keyword_list, is_even(val) do
      with product <- key*2 do
        cond do
          product > 9 -> product - 9
          true -> product
        end
      end
    end
  end

  defp get_odd_list(keyword_list), do: for {key, val} <- keyword_list, is_odd(val), do: key

  defp compute_unit_digit(sum_number), do: sum_number |> rem(10)

  defp compute_check_digit(unit_digit) when is_integer(unit_digit) do
    cond do
      unit_digit == 0 -> unit_digit
      true -> 10 - unit_digit
    end
  end
end

# server_pid = LuhnAlgoServer.start()
# send(server_pid, {:is_full_luhn_valid, 1111111111111111})
# Process.sleep(1000)
# send(server_pid, {:append_check_digit, 111111111111111})
