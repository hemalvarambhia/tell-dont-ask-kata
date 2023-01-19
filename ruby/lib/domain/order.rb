# frozen_string_literal: true

class Order
  attr_reader :total, :currency, :items, :tax, :status, :id

  def self.blank(id:, currency: 'EUR')
    created(id: id, total: 0.0, tax: 0.0, currency: currency, items: [])
  end

  def self.created(id:, total:, tax:, currency:, items:)
    new(id: id, status: CREATED, total: total, tax: tax, currency: currency, items: items)
  end

  def initialize(id:, status: '', total:, tax:, currency:, items:)
    @id = id
    @status = status
    @total = total
    @tax = tax
    @currency = currency
    @items = items
  end

  def <<(order_item)
    @items << order_item
    @total += order_item.taxed_amount
    @tax += order_item.tax
  end

  def create!
    @status = CREATED
  end

  def approve!
    @status = APPROVED
  end

  def reject!
    @status = REJECTED
  end

  def ship!
    @status = SHIPPED
  end

  def created?
    status == CREATED
  end

  def approved?
    status == APPROVED
  end

  def shipped?
    status == SHIPPED
  end

  def rejected?
    status == REJECTED
  end

  APPROVED = :approved
  SHIPPED = :shipped
  REJECTED = :rejected
  CREATED = :created

  private_constant :APPROVED, :SHIPPED, :REJECTED, :CREATED
end
