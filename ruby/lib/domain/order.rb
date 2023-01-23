# frozen_string_literal: true

class Order
  attr_reader :total, :currency, :items, :tax, :status, :id
  private_class_method :new

  def self.blank(id:, currency:)
    with(id: id, status: CREATED, currency: currency, items: [])
  end

  def self.created(id:, total:, tax:, currency:, items:)
    new(id: id, status: CREATED, total: total, tax: tax, currency: currency, items: items)
  end

  def self.with(id:, status:, currency:, items:)
    new(
      id: id,
      status: status,
      total: items.sum {|item| item.taxed_amount },
      tax: items.sum { |item| item.tax },
      currency: currency,
      items: items
    )
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

  def unshippable?
    created? || rejected?
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

  def inspect
    "Order: total + tax #{total}, tax: #{tax}"
  end
end
