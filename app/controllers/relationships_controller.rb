class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @relationships = current_user.relationships
  end

  def create
    other_user = User.find(params[:user_id])
    current_user.follow(other_user)
    redirect_to people_path
  end

  def destroy
    relation = Relationship.find(params[:id])
    current_user.unfollow(relation.followed)
    redirect_to people_path
  end
end