# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    include Mutations::ChannelMutations
    include Mutations::VideoMutations
  end
end
