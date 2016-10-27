require 'product'
require 'pry'
class Checkout

  def initialize(options = { })
    @final_price_threshold_for_promotion = options[:total_threshold_promotion]
    @final_price_discount = options[:final_price_discount].to_f / 100
    @final_price = 0
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
      scanned_products[product_code][:price] = product.price
      scanned_products[product_code][:quantity] += 1
    else
      scanned_products[product_code] = { price: product.price, quantity: 1 }
    end
  end

  def total
      @final_price = scanned_products.values.inject(0) do |sum, someth|
        sum += someth[:price] * someth[:quantity]
      end
      (with_promotion).round(2)
  end

  private

  def with_promotion
    return @final_price if @final_price_threshold_for_promotion.nil? || @final_price_discount.nil?
    @final_price > @final_price_threshold_for_promotion ? @final_price - (@final_price_discount * @final_price) : @final_price
  end

  def scanned_products
    @scanned ||= {}
  end

  def is_scanned?(code)
    scanned_products.include?(code)
  end
end
