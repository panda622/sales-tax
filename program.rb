require_relative 'product'

class Program
  def self.run(csv_path)
    Product.import_csv(csv_path)
    Product.export_csv('output.csv')
  end
end


Program.run('input.csv')
