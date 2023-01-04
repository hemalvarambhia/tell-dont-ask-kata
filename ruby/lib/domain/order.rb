# frozen_string_literal: true

class Order
  attr_accessor :total, :currency, :items, :tax, :status, :id

  def initialize(id: nil)
    @id = id
  end

  def approve!
    self.status = OrderStatus::APPROVED
  end

  def reject!
    self.status = OrderStatus::REJECTED
  end

  def approved?
    status == OrderStatus::APPROVED
  end

  def shipped?
    status == OrderStatus::SHIPPED
  end

  def rejected?
    status == OrderStatus::REJECTED
  end
end
