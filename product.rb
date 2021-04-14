require 'csv'

class Product
  attr_reader :quantity, :name, :price

  @@all = []

  EXEMPT_PRODUCTS = %w(bottle book food medical pill chocolate)
  IMPORT_PRODUCT_TAX = 0.05
  REGULAR_TAX = 0.1
  NO_TAX = 0

  def initialize(quantity, name, price)
    @quantity = quantity.to_i
    @name = name.to_s
    @price = price.to_f
  end

  class << self
    def all
      @@all
    end

    def import_csv(file_path)
      table = CSV.open(file_path, skip_blanks: true, headers: false).reject { |row| row.all?(&:nil?) }
      table.shift #ignore header
      table.each do |row|
        all.push(Product.new(*row))
      end
      all
    end

    def export_csv(file_path)
      CSV.open('output.csv', 'wb') do |csv|
        all.each do |product|
          csv << [product.quantity, product.name, product.calculate_price_after_tax]
          csv << []
        end

        csv << ["Sales Taxes: #{all.inject(0) { |sum, product| sum + product.tax_price }}"]

        csv << []
        csv << ["Total: #{all.inject(0) { |sum, product| sum + product.calculate_price_after_tax }}"]
      end
    end
  end

  def tax_price
    return price * IMPORT_PRODUCT_TAX if imported_product?

    EXEMPT_PRODUCTS.each { |p| return NO_TAX if name.downcase.include?(p) }

    REGULAR_TAX * price
  end

  def tax_type
    return IMPORT_PRODUCT_TAX if imported_product?

    EXEMPT_PRODUCTS.each { |p| return NO_TAX if name.downcase.include?(p) }

    REGULAR_TAX
  end

  def calculate_price_after_tax
    return price if tax_type == NO_TAX

    (tax_price + price).round(2)
  end

  def imported_product?
    name.downcase.include?('import') || name.downcase.include?('imported')
  end
end
