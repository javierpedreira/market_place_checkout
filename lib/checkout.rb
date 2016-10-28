require 'product'

class Checkout
  def initialize(promotional_rules = {})
    @product_promotions = promotional_rules.key?(:product_promotions) ? promotional_rules[:product_promotions] : {}
    @total_promotions = promotional_rules.key?(:total_promotion) ? promotional_rules[:total_promotion] : []
  end

  def scan(product)
    if scanned_products.include?(product.id)
      scanned_products[product.id][:quantity] += 1
      scanned_products[product.id][:price] = calculate_price(product.id)
    else
      scanned_products[product.id] = { price: product.price, quantity: 1 }
    end
  end

  def total
    apply_discount(total_price)
  end

  private

  def calculate_price(product_code)
    if @product_promotions.include?(product_code)
      promotion = @product_promotions[product_code]

      return promotion.value if promotion.applicable?(scanned_products[product_code][:quantity])
    end

    scanned_products[product_code][:price]
  end

  def total_price
    scanned_products.inject(0) { |sum, (_, product)| sum += product[:price] * product[:quantity] }
  end

  def apply_discount(price)
    max_reduction = 0
    @total_promotions.each do |promotion|
      max_reduction = promotion.value if promotion.applicable?(price) && promotion.value >= max_reduction
    end

    (price - (price * (max_reduction.to_f / 100))).round(2)
  end

  def scanned_products
    @scanned ||= {}
  end
end
