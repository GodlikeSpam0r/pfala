class CampController < ApplicationController
  before_filter :authenticate_user!

  def camp
    id = BSON::ObjectId.from_string(current_user._id)
    @camps = Camp.where({users: id})
  end

  def add
    camp = Camp.create!(:name => params[:name], :group => params[:group], :owner => current_user._id)
    camp.push(users: current_user._id)
    BlockType.where(default:true).each do |bt|
      camp.push(block_types: bt._id)
    end

    redirect_to '/camp', status: :found, :flash => {:status => :success, :notice => "Added camp"}
  end

  def show
    get_camp
    @camp_users = User.find(@camp.users)
    @users = User.not_in(_id: @camp_users)
    @user = current_user

    camp_permission? @camp
  end

  def edit
    get_camp
    camp_permission? @camp

    name = params[:name]
    group = params[:group]
    coordinates = params[:coordinates]
    campground = params[:campground]
    camp_start = Date.parse params[:camp_start]
    camp_end = Date.parse params[:camp_end]

    if camp_end < camp_start
      redirect_to '/camp/'+ @camp._id , status: :found, :flash => {:status => :fail, :notice => "Camp has to end after it starts!"}
      return
    end

    @camp.change_name(name)
    @camp.change_group(group)
    @camp.change_coordinates(coordinates)
    @camp.change_campground(campground)
    @camp.change_start(camp_start)
    @camp.change_end(camp_end)

    redirect_to '/camp/'+ @camp._id , status: :found, :flash => {:status => :success, :notice => "Edited camp"}
  end

  def add_user
    get_camp
    user = BSON::ObjectId.from_string(params[:user])
    @camp.add_user(user)
    camp_permission? @camp

    redirect_to '/camp/'+ id , status: :found, :flash => {:status => :success, :notice => "Added user"}
  end

  def del_user
    get_camp
    user = BSON::ObjectId.from_string(params[:user])
    camp_permission? @camp

    @camp.remove_user(user)

    redirect_to '/camp/'+ id , status: :found, :flash => {:status => :success, :notice => "Removed user"}
  end

  def block_type
    get_camp
    camp_permission? @camp

    @block_types = BlockType.find(@camp.block_types)
  end

  def add_block_type
    get_camp
    camp_permission? @camp
    name = params[:name]
    block_type = BlockType.create! :name => name, :color => params[:color]
    @camp.push(block_types: block_type._id)
    redirect_to :back, status: :found, :flash => {:status => :sucess, :notice => "You created blocktype #{name}"}
  end

  def del_block_type
    get_camp
    camp_permission? @camp
    bt = BlockType.find(BSON::ObjectId.from_string(params[:block]))
    name = bt.name
    bt.delete
    redirect_to :back, status: :found, :flash => {:status => :sucess, :notice => "You deleted blocktype #{name}"}
  end

  def edit_block_type_show
    get_camp
    camp_permission? @camp
    @bt = BlockType.find(BSON::ObjectId.from_string(params[:block]))
    render 'camp/edit_block_type'
  end

  def edit_block_type
    get_camp
    camp_permission? @camp
    @bt = BlockType.find(BSON::ObjectId.from_string(params[:block]))
    name = @bt.name
    @bt.name = params[:name]
    @bt.color = params[:color]
    @bt.save
    redirect_to :back, status: :found, :flash => {:status => :sucess, :notice => "You edited blocktype #{name}"}
  end

  def camp_permission?(camp)
    unless camp.users.include? current_user._id
      redirect_to '/camp', status: :found, :flash => {:status => :fail, :notice => "You have no permisson for this camp!"}
      return
    end
  end

  def get_camp
    id = BSON::ObjectId.from_string(params[:id])
    @camp = Camp.find(id)
  end
end
