class PicassoController < CampController
  def show
    get_camp
    camp_permission? @camp
    @length  = (@camp.camp_end - @camp.camp_start).to_i
    @block_types  = BlockType.find(@camp.block_types)
    @blocks = Block.find(@camp.blocks)
  end

  def block
    get_camp
    camp_permission? @camp
  end

  def add_block
    get_camp
    camp_permission? @camp

    block_type = BlockType.find(BSON::ObjectId.from_string(params[:blockType]))
    name = params[:name]
    start = params[:start]
    duration = params[:duration]
    date = params[:date]

    block = @camp.add_block(Block.create! :name => name, :block_type => block_type._id, :date => date, :start => start, :duration => duration)

    color = block_type.color
    respond_to do |format|
      msg = { :status => "ok", :message => "Success!", :color => color, :id => block._id.to_s }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  def update_block
    get_camp
    camp_permission? @camp

    block = Block.find(BSON::ObjectId.from_string(params[:block]))

    name = params[:name]
    start = params[:start]
    duration = params[:duration]
    date = params[:date]

    if params[:blockType]
      block_type = BlockType.find(BSON::ObjectId.from_string(params[:blockType]))
      block.update_attribute(:block_type => block_type._id)
    end

    block.update_attributes!(:name => name, :date => date, :start => start, :duration => duration)

    color = BlockType.find(block.block_type).color
    respond_to do |format|
      msg = { :status => "ok", :message => "Success!", :color => color, :id => block._id.to_s}
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end
end
