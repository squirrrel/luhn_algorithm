class NumberUtil
  attr_accessor :number, :even_indexed_numbers, :odd_indexed_numbers, :doubled_substructed

  def initialize
    ## Reverse the number in order to start the count from the rightmost member.
    #  This is done to ensure it works for both the numbers - with even/odd number of digits
    reversed_num = number.digits
    @even_indexed_numbers = reversed_num.select.with_index {|_,i| i.even? }
    @odd_indexed_numbers = reversed_num.select.with_index {|_,i| i.odd? }
  end

  private

  def get_unit_digit
    calculate_sum % 10
  end

  def get_check_digit
    unit_digit = get_unit_digit
    unit_digit.zero? ? unit_digit : 10 - unit_digit
  end

  def calculate_first_step
    @doubled_substructed ||=
      even_indexed_numbers.map do |item|
        product = item * 2
        product > 9 ? product - 9 : product
      end
  end

  def calculate_second_step
    (doubled_substructed + odd_indexed_numbers).sum
  end

  def calculate_sum
    calculate_first_step
    calculate_second_step
  end
end

class NumberValidator < NumberUtil
  attr_accessor :check_digit

  def initialize number:
    @check_digit = number.to_i%10
    @number = number.to_i/10

    super()
  end

  # Verifies whether a number is valid according to the luhn formula
  def is_partial_luhn_valid?
    get_unit_digit == 0
  end

  ## Verifies whether the full card number last digit is valid against its check digit.
  #  This condition is the only mandatory for the full card number to be valid
  def is_full_luhn_valid?
    get_check_digit == check_digit
  end
end

class NumberGenerator < NumberUtil
  attr_accessor :number

  def initialize number:
    @number = number.to_i

    super()
  end

  def append_check_digit
    eval "#{number}#{get_check_digit}"
  end
end
