class BlockType
  include Mongoid::Document
  field :name, type: String
  field :color, type: String
  field :has_program, type: Mongoid::Boolean
  field :default, type: Boolean, default: false
end
