class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to dash_path
    end
  end
  def create
  t = Time.now
  @user = User.find_by_email(params[:session][:email])
  @ip = request.remote_ip
  if @user && @user.authenticate(params[:session][:password])
    if @user.enabled == "0"
      redirect_to logout_path
    else
    @action = Action.create(:action => 'Login', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
    session[:user_id] = @user.id
    @action.save
    redirect_to dash_path
    end
  else
    redirect_to '/login/error'
  end
end
def destroy
  session[:user_id] = nil
  redirect_to '/login/session'
end
def error
  if current_user
    redirect_to dash_path
  end
end
def newpass
end
def loggedout
  if current_user
    redirect_to dash_path
  end
end
end
