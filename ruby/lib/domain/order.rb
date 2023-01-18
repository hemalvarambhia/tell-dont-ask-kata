# frozen_string_literal: true

class Order
  attr_accessor :total, :currency, :items, :tax, :status, :id

  def self.blank(currency)
    created(total: 0.0, tax: 0.0, currency: currency, items: [])
  end

  def self.created(total:, tax:, currency:, items:)
    new(status: OrderStatus::CREATED, total: total, tax: tax, currency: currency, items: items)
  end

  def initialize(id: nil, status: '', total: 0.0, tax: 0.0, currency: 'EUR', items: [])
    @id = id
    @status = status
    @total = total
    @tax = tax
    @currency = currency
    @items = items
  end

  def <<(order_item)
    self.items << order_item
    self.total += order_item.taxed_amount
    self.tax += order_item.tax
  end

  def create!
    self.status = OrderStatus::CREATED
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
