require 'product'

class Checkout
  attr_reader :total

  def initialize()
    @total = 0
  end

  def scan(product_value)

    @total += product_value
  end
end
