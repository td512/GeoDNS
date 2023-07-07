class AccountController < ApplicationController
  before_action :require_user
  before_action :check_user
  before_action :check_activated
  def new
  end
  def update
    t = Time.now
    @ip = request.remote_ip
    if params[:session][:password].present?
    @user = User.find_by(email: current_user.email)
    @user.password = params[:session][:password]
    if @user.save
    @action = Action.create(:action => 'Change Password', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
    @action.save
    redirect_to account_saved_path
  else
    redirect_to account_error_path
  end
else
  redirect_to account_error_path
end
end
def updated
end
def error
end
end
