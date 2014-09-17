class AdminsController < ApplicationController
  before_action :require_user, :require_admin
end