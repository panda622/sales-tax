require 'spec_helper'
require_relative '../product'

RSpec.describe Product do
  let(:quantity) { 2 }
  let(:name) { 'Harry Potter Book' }
  let(:price) { 14.99 }

  describe '.new' do
    subject { described_class.new(quantity, name, price) }

    it 'instantiates the class with 3 arguments' do
      expect(subject).to be_an_instance_of(Product)
    end

    it 'set quantity to 1st arguments' do
      expect(subject.quantity).to eq(quantity)
    end

    it 'set name to 2nd arguments' do
      expect(subject.name).to eq(name)
    end

    it 'set name to 3rd arguments' do
      expect(subject.price).to eq(price)
    end
  end

  describe '.import_csv' do
    it 'return list of products' do
      csv_path = 'input_test.csv'
      expect(described_class.import_csv(csv_path)).to be_an_instance_of(Array)
    end

    it 'return exact list product' do
      csv_path = 'input_test.csv'
      expect(described_class.import_csv(csv_path)[0].name).to eq('book')
      expect(described_class.import_csv(csv_path)[1].name).to eq('music CD')
      expect(described_class.import_csv(csv_path)[2].name).to eq('chocolate bar')
    end
  end

  describe '#imported_product?' do
    context 'when is a imported product' do
      name_imported = 'Harry potter import from viet nam'
      subject { described_class.new(quantity,name_imported, price) }

      it 'should return true' do
        expect(subject.imported_product?).to be(true)
      end
    end

    context 'when is a local product' do
      local_product = 'Harry potter from here'
      subject { described_class.new(quantity,local_product, price) }

      it 'should return false' do
        expect(subject.imported_product?).to be(false)
      end
    end
  end

  describe '#tax_type' do
    context 'when is a imported product' do
      name_imported = 'Harry potter book imported from viet nam'
      subject { described_class.new(quantity, name_imported, price) }

      it 'should return true' do
        expect(subject.tax_type).to eq(0.05)
      end
    end

    context 'when is a local product' do
      local_product = 'chocolate bars'
      subject { described_class.new(quantity,local_product, price) }

      it 'no tax for local food' do
        expect(subject.tax_type).to eq(0)
      end

      it 'tax for music cd' do
        local_product = 'music cd'
        subject { described_class.new(quantity,local_product, price) }
        expect(subject.tax_type).to eq(0.1)
      end
    end
  end

  describe '#calculate_price_after_tax' do
    context 'local un-exempt tax product' do
      music_cd = 'music cd'
      subject { described_class.new(quantity, music_cd, 14.99) }

      it 'should return 16.49' do
        expect(subject.calculate_price_after_tax).to eq(16.49)
      end
    end

    context 'local exempt tax product' do
      book = 'Harry potter book'
      subject { described_class.new(quantity, book, 12.49) }

      it 'should return 16.49' do
        expect(subject.calculate_price_after_tax).to eq(12.49)
      end
    end

    context 'imported product' do
      choco = ' box of imported chocolates'
      subject { described_class.new(quantity, choco, 11.25) }

      it 'should return 11.85' do
        expect(subject.calculate_price_after_tax).to eq(11.81)
      end
    end
  end
end
