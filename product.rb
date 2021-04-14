require 'csv'

class Product
  attr_reader :quantity, :name, :price

  @@all = []

  EXEMPT_PRODUCTS = %w(book food medical pill chocolate chocolates)
  IMPORT_PRODUCT_TAX = 5
  REGULAR_TAX = 10
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
          csv << [product.quantity, product.name, product.calculate_price_after_tax.to_f]
          csv << []
        end

        csv << ["Sales Taxes: #{sales_taxes}"]

        csv << []
        csv << ["Total: #{total}"]
      end
    end

    def total
      '%.2f' % all.inject(0) { |sum, product| sum + product.calculate_price_after_tax.to_f }
    end

    def sales_taxes
      '%.2f' % all.inject(0) { |sum, product| sum + product.tax_price }
    end
  end

  def tax_price
    return 0 if tax_value == NO_TAX

    after_tax = price * tax_value / 100
    ((after_tax * 20).round / 20.0) * quantity
  end

  def tax_value
    return IMPORT_PRODUCT_TAX if imported_product? && exempt_tax?

    return IMPORT_PRODUCT_TAX + REGULAR_TAX if imported_product? && !exempt_tax?

    return NO_TAX if exempt_tax?

    REGULAR_TAX
  end

  def calculate_price_after_tax
    '%.2f' % (tax_price + price)
  end

  def imported_product?
    name.downcase.include?('import') || name.downcase.include?('imported')
  end

  private

  def exempt_tax?
    EXEMPT_PRODUCTS.each { |p| return true if name.downcase.include?(p) }
    false
  end
end
