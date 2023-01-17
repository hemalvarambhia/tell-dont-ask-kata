# frozen_string_literal: true

class Order
  attr_accessor :total, :currency, :items, :tax, :status, :id

  def self.created(total:, tax:, currency:)
    new(status: OrderStatus::CREATED, total: total, tax: tax, currency: currency)
  end

  def initialize(id: nil, status: '', total: 0.0, tax: 0.0, currency: 'EUR', items: [])
    @id = id
    @status = status
    @total = total
    @tax = tax
    @currency = currency
  end

  def approve!
    self.status = OrderStatus::APPROVED
  end

  def reject!
    self.status = OrderStatus::REJECTED
  end

  def ship!
    self.status = OrderStatus::SHIPPED
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
