# frozen_string_literal: true

class Order
  attr_accessor :total, :currency, :items, :tax, :status, :id

  def initialize(id: nil)
    @id = id
  end

  def shipped?
    status == OrderStatus::SHIPPED
  end
end
