require 'checkout'

describe Checkout do
  subject(:checkout) { Checkout.new }
  subject(:product) { 001 }
  describe '#scan' do
    context "I haven't scanned any product" do
      before do
        checkout.scan(product) 
      end

      it 'increases the total by the product value' do
        expect(checkout.total).to eql(9.25)
      end
    end

    context 'I scan products with a total value over £60' do
      subject(:products) { [001, 002, 003] }
      before do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies a 10% off the purchase' do
        expect(checkout.total).to eql(66.78) 
      end
    end

    context 'I scan Lavender heart 2 or more times' do
      subject(:products) { [001, 003, 001] }
      before do
        products.each do |product|
          checkout.scan(product)
        end
      end

      it 'applies a reduced price to Lavender heart items' do
        expect(checkout.total).to eql(36.95) 
      end
    end
  end

  describe '#total' do
    context "I haven't scanned any product" do
      it 'returns zero' do
        expect(checkout.total).to eql(0)
      end 
    end
  end
end
