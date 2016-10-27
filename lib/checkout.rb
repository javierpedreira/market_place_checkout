require 'warehouse'
require 'product'

class Checkout
  def initialize(options = {})
    @threshold_for_promotion = options[:total_threshold_promotion]
    @discount = options[:total_discount].to_f / 100
    @final_price = 0
  end

  def scan(product_code)
    product = Warehouse.instance.product(product_code)

    if scanned?(product_code)
      scanned_products[product_code][:price] = product_code == '001' ? 8.5 : product.price
      scanned_products[product_code][:quantity] += 1
    else
      scanned_products[product_code] = { price: product.price, quantity: 1 }
    end
  end

  def total
    @final_price = scanned_products.values.inject(0) do |sum, someth|
      sum += someth[:price] * someth[:quantity]
    end
    with_promotion.round(2)
  end

  private

  def with_promotion
    return @final_price if @threshold_for_promotion.nil? || @discount.nil?
    @final_price > @threshold_for_promotion ? @final_price - (@discount * @final_price) : @final_price
  end

  def scanned_products
    @scanned ||= {}
  end

  def scanned?(code)
    scanned_products.include?(code)
  end
end
