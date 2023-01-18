# frozen_string_literal: true

class OrderItem
  attr_accessor :product, :quantity, :taxed_amount, :tax

  def initialize(product:, quantity:, taxed_amount:, tax:)
    @product = product
    @quantity = quantity
    @taxed_amount = taxed_amount
    @tax = tax
  end
end
