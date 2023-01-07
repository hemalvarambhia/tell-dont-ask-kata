# frozen_string_literal: true

class Product
  attr_accessor :name, :price, :category

  def initialize(name: '', price: 0.0, category: nil)
    @name = name
    @price = price
    @category = category
  end
end
