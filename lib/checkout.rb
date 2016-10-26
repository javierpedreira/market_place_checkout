require 'product'

class Checkout

  def initialize()
    @total = 0
  end

  def scan(product_code)
    product = case product_code
                when 001
                  Product.new('Lavender heart', 9.25)
                when 002
                  Product.new('Personalised cufflinks', 45.00)
                when 003
                  Product.new('Kids T-shirt', 19.95)
              end
    @total += product.value
  end

  def total
      @total > 60.0 ? @total - (0.1 * @total) : @total
  end
end
