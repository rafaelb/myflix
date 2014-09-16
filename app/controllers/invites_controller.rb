class InvitesController < ApplicationController
  before_action :require_user
  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.inviter = current_user
    if @invite.save
      flash[:success]= "Invite sent"
      redirect_to invite_path
    else
      flash[:error]= "Invalid input"
      render :new
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:recipient_name, :recipient_email, :message)
  end
end