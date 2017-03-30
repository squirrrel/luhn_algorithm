defmodule Api do
  @callback is_full_luhn_valid(integer) :: tuple
  @callback append_check_digit(integer) :: integer
end
