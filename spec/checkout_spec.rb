require 'checkout'
require 'promotion'

describe Checkout do
  subject(:checkout_no_proms) { Checkout.new }
  subject(:checkout) { Checkout.new(total_promotion: [Promotion.new(60, 10)],
                                     product_promotions: { '001' => Promotion.new(2, 8.50) })}

  subject(:product_1) { Product.new('001', 'Lavender heart', 9.25) }
  subject(:product_2) { Product.new('002', 'Personalised cufflinks', 45.0) }
  subject(:product_3) { Product.new('003', 'Kids T-shirt', 19.95) }

  describe '#scan' do
    context 'I have no promotions and I scan products' do
      before do
        checkout_no_proms.scan(product_1) 
      end

      it 'increases the total by the product value' do
        expect(checkout_no_proms.total).to eql(9.25)
      end
    end

    context "I haven't scanned any product" do
      before do
        checkout.scan(product_1)
      end

      it 'increases the total by the product value' do
        expect(checkout.total).to eql(9.25)
      end
    end

    context 'Several promotions for the total price, the best one is applied' do
      subject(:checkout) { Checkout.new(total_promotion: [Promotion.new(60, 10), Promotion.new(80, 40), Promotion.new(70, 15)]) }
      subject(:products) { [product_1, product_2, product_1, product_3] }
      before 'I scan several products' do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies the best promotion' do
        expect(checkout.total).to eql(50.07)
      end
    end

    context 'Several products have promotions' do
      subject(:checkout) { Checkout.new(product_promotions: { '001' => Promotion.new(2, 4.0),
                                                              '002' => Promotion.new(2, 20.0),
                                                              '003' => Promotion.new(1, 10.95) })}

      subject(:products) { [product_1, product_2, product_2, product_2, product_2, product_1, product_3] }
      before 'I scan several products' do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies all the promotions to the products' do
        expect(checkout.total).to eql(107.95)
      end
    end

    context 'I scan products with a total value over £60' do
      subject(:products) { [product_1, product_2, product_3] }
      before do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies the promotion to the total price' do
        expect(checkout.total).to eql(66.78)
      end
    end

    context 'I scan Lavender heart 2 or more times' do
      subject(:products) { [product_1, product_3, product_1] }
      before do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies a reduced price to Lavender heart items' do
        expect(checkout.total).to eql(36.95)
      end
    end

    context '2 different promotions applied to the products and the total prize' do
      subject(:products) { [product_1, product_2, product_1, product_3] }
      before 'I scan several products' do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies both promotions' do
        expect(checkout.total).to eql(73.76)
      end
    end
  end

  describe '#total' do

    context 'I have no promotions and no products' do
      it 'returns zero' do
        expect(checkout_no_proms.total).to eql(0.0)
      end
    end

    context "I haven't scanned any product" do
      it 'returns zero' do
        expect(checkout.total).to eql(0.0)
      end
    end
  end
end
