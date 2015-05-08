class Block
  include Mongoid::Document
  field :name, type: String
  field :block_type, type:BlockType
  field :date, type: Integer
  field :start, type: String
  field :duration, type: String

  def get_color
    BlockType.find(self.block_type).color
  end

  def get_date
    self.date
  end
end
