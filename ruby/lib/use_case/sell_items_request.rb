# frozen_string_literal: true

class SellItemsRequest
  attr_reader :requests

  def initialize(requests: [])
    @requests = requests
  end

  def each_item(&block)
    @requests.each(&block)
  end
end
