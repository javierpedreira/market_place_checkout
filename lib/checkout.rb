require 'warehouse'
require 'product'
require 'pry'

class Checkout
  def initialize(promotional_rules = {})
    @promotional_rules = promotional_rules
    @final_price = 0
  end

  def scan(product_code)
    product = Warehouse.instance.product(product_code)
    if scanned?(product_code)
      scanned_products[product_code][:price] = product.price
      scanned_products[product_code][:quantity] += 1
    else
      scanned_products[product_code] = { price: product.price, quantity: 1 }
    end
  end

  def total
    scanned_products.each do |key, value|
      price = value[:price]
        if @promotional_rules[:product_promotions].include?(key)
          rule = @promotional_rules[:product_promotions][key]
          price = rule[:new_price] if rule[:min_quantity] <= value[:quantity]          
        end
      @final_price += price * value[:quantity]
    end
    with_promotion.round(2)
  end

  private

  def with_promotion
    return @final_price - reduction(@final_price)
  end

  def scanned_products
    @scanned ||= {}
  end

  def scanned?(code)
    scanned_products.include?(code)
  end

  def reduction(price)
    max_reduction = 0
    @promotional_rules[:total_promotion].each do |promotion|
      max_reduction = promotion[:discount] if promotion[:threshold] <= price && promotion[:discount] >= max_reduction
    end
    price * (max_reduction.to_f / 100)
  end
end
