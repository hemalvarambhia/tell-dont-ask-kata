# frozen_string_literal: true

class OrderItem
  attr_accessor :product, :quantity, :taxed_amount, :tax

  def initialize(product: nil, quantity: 0, taxed_amount: 0.0, tax: 0.0)
    @product = product
    @quantity = quantity
    @taxed_amount = taxed_amount
    @tax = tax
  end
end
