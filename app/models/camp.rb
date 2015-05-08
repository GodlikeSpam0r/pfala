class Camp
  include Mongoid::Document
  field :name, type: String
  field :group, type: String
  field :coordinates, type: String
  field :campground, type: String
  field :users, type: Array, default: []
  field :camp_start, type: Date
  field :camp_end, type: Date
  field :blocks, type: Array, default: []
  field :owner, type: BSON::ObjectId
  field :block_types, type: Array, default: []

  validates_presence_of :owner

  def change_coordinates(coordinates)
    self.coordinates = coordinates
    save
  end

  def change_name(name)
    self.name = name
    save
  end

  def change_group(group)
    self.group = group
    save
  end

  def change_campground(campground)
    self.campground = campground
    save
  end

  def change_start(camp_start)
    self.camp_start = camp_start
    save
  end

  def change_end(camp_end)
    self.camp_end = camp_end
    save
  end

  def add_user(id)
    unless self.users.include? id
      self.users.push(id)
    end
    save
  end

  def add_block(block)

    self.blocks.push(block._id)
    save
    block
  end

  def remove_user(id)
    self.users.delete(id)
    save
  end

end
