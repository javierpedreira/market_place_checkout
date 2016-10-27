require 'product'

class Checkout

  def initialize()
    @total = 0
  end

  def scan(product_code)

    product = case product_code
                when 001
                  product_price = scanned_products.key?(product_code) ? 8.50 : 9.25
                  Product.new('Lavender heart', product_price)
                when 002
                  Product.new('Personalised cufflinks', 45.00)
                when 003
                  Product.new('Kids T-shirt', 19.95)
              end
    if scanned_products.key?(product_code)
      scanned_products[product_code][:p] = product.price
      scanned_products[product_code][:q] += 1
    else
      scanned_products[product_code] = { p: product.price, q: 1 }
    end
  end

  def total
      final_price = scanned_products.values.inject(0) do |sum, someth|
        sum += someth[:p] * someth[:q]
      end
      final_price > 60.0 ? (final_price - (0.1 * final_price)).round(2) : final_price
  end

  private

  def scanned_products
    @scanned ||= {}
  end

  def is_scanned?(code)
    scanned_products.include?(code)
  end
end
