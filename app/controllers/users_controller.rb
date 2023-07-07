class UsersController < ApplicationController
  def new
    redirect_to login_path if User.first
    @user = User.new
  end

def create
  @user = User.new(user_params)
  t = Time.now
  @ip = request.remote_ip
  if User.exists?(:email => @user.email)
    redirect_to '/signup/error/email'
  else
    if EmailValidator.valid?(@user.email)
      act_code = SecureRandom.hex(6)
      token = SecureRandom.hex(48)
      @user.activation_code = act_code
      @user.activated = '0'
      @user.token = token
      @user.level = '0'
      @user.enabled = '1'
      @user.original_token = token
      if @user.save
        @action = Action.create(:action => 'Register', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        PostmarkMailer.verify(@user).deliver_now
        session[:user_id] = @user.id
        redirect_to dash_path
      else
        redirect_to '/signup/error/email'
      end
  end
end
end
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
