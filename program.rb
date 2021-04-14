require_relative 'product'

class Program
  def self.run(csv_path)
    puts "Calculating..."
    Product.import_csv('input.csv')
    Product.export_csv('output.csv')
    puts "Done"
  end
end


Program.run('input.csv')
