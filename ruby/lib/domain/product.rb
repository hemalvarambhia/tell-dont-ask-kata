# frozen_string_literal: true

class Product
  attr_reader :name, :price

  def initialize(name:, price:, category:)
    @name = name
    @price = price
    @category = category
  end

  def unitary_tax
    ((price / 100.0) * category.tax_percentage).ceil(2)
  end

  def unitary_taxed_amount
    (price + unitary_tax).ceil(2)
  end

  private

  attr_reader :category
end
