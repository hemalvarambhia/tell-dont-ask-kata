# frozen_string_literal: true

class SellItemRequest
  attr_reader :quantity, :product_name

  def initialize(product_name:, quantity:)
    @product_name = product_name
    @quantity = quantity
  end

  def tax_amount(product)
    (product.unitary_tax * quantity).ceil(2)
  end

  def taxed_amount(product)
    (product.unitary_taxed_amount * quantity).ceil(2)
  end
end
