require 'singleton'

class Warehouse
  include Singleton

  def register(products)
    products.each do |key, product|
      warehouse[key] = product
    end
  end

  def product(id)
    warehouse[id]
  end

  private

  def warehouse
    @ware_house ||= {}
  end
end
