# frozen_string_literal: true

class SellItemRequest
  attr_accessor :quantity, :product_name

  def initialize(product_name:, quantity:)
    @product_name = product_name
    @quantity = quantity
  end
end
