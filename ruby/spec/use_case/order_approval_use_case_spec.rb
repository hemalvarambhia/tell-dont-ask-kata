# frozen_string_literal: true

require 'use_case/order_approval_use_case'
require 'use_case/order_approval_request'
require 'domain/order'
require_relative '../doubles/test_order_repository'

RSpec.describe OrderApprovalUseCase do
  let(:order_repository) { TestOrderRepository.new }
  let(:use_case) { described_class.new(order_repository) }

  let(:initial_order) { Order.new(id: rand(1..1000)) }

  before { order_repository.add_order(initial_order) }

  it 'approves an existing order' do
    request = OrderApprovalRequest.new(order_id: initial_order.id, approved: true)

    use_case.run(request)

    saved_order = order_repository.saved_order
    expect(saved_order.status).to eq(OrderStatus::APPROVED)
  end

  it 'rejects a newly unapproved order' do
    initial_order.status = OrderStatus::CREATED
    request = OrderApprovalRequest.new(order_id: initial_order.id)
    request.approved = false

    use_case.run(request)

    saved_order = order_repository.saved_order
    expect(saved_order.status).to eq(OrderStatus::REJECTED)
  end

  it 'cannot approve a rejected order' do
    initial_order.status = OrderStatus::REJECTED
    request = OrderApprovalRequest.new(order_id: initial_order.id)
    request.approved = true

    expect { use_case.run(request) }.to raise_error(described_class::RejectedOrderCannotBeApprovedError)
  end

  it 'cannot reject an approved order' do
    initial_order.status = OrderStatus::APPROVED
    request = OrderApprovalRequest.new(order_id: initial_order.id)
    request.approved = false

    expect { use_case.run(request) }.to raise_error(described_class::ApprovedOrderCannotBeRejectedError)
  end

  it 'cannot approve shipped orders' do
    initial_order.status = OrderStatus::SHIPPED
    request = OrderApprovalRequest.new(order_id: initial_order.id)
    request.approved = true

    expect { use_case.run(request) }.to raise_error(described_class::ShippedOrdersCannotBeChangedError)
  end
end
