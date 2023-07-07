class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ActionView::Helpers::TextHelper
  layout 'api'
  def authenticate
    t = Time.now
    @ip = request.remote_ip
    @password = request.headers["Password"]
    @user = request.headers["User"]
    @username = User.find_by_email(@user)
    if @username && @username.authenticate(@password)
      if @username.token == @username.original_token
        token = SecureRandom.hex(24)
        @username.token = token
        @username.save
        @action = Action.create(:action => 'Create API Token', :owner => @user, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        msg = {:user => @user, :status => :ok, :token => token}
        render :json => msg
      else
        @action = Action.create(:action => 'Access API Token', :owner => @user, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        if @username.activated == "1"
          activated = true
        else
          activated = false
        end
        msg = {:user => @user, :status => :ok, :token => @username.token, :activated => activated}
        render :json => msg
      end
    else
      msg = {:user => @user, :status => :unauthorized}
      render :json => msg, status: :unauthorized
    end
  end
  def reset
    t = Time.now
    @ip = request.remote_ip
    @password = request.headers["Password"]
    @user = request.headers["User"]
    @username = User.find_by_email(@user)
    if @username && @username.authenticate(@password)
        token = SecureRandom.hex(24)
        @username.token = token
        if @username.save
        @action = Action.create(:action => 'Reset API Token', :owner => @user, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        msg = {:user => @user, :status => :ok, :token => token}
        render :json => msg
      else
        msg = {:user => @user, :status => :internal_server_error}
        render :json => msg, status: :internal_server_error
      end
    else
      msg = {:user => @user, :status => :unauthorized}
      render :json => msg, status: :unauthorized
    end
  end
  def userdetails
    @auth = request.headers["Auth"]
    @user = User.find_by_token(@auth)
    if @user
      msg = {:username => @user.email, :first_name => @user.first_name, :last_name => @user.last_name, :style => @user.style, :status => :ok}
      render :json => msg
    else
      msg = {:status => :not_found}
      render :json => msg, status: :not_found
  end
end
def userpasswd
  t = Time.now
  @ip = request.remote_ip
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user
    json = JSON.parse request.raw_post
    if json["password"].present?
    @user.password = json["password"]
    if @user.save
      @action = Action.create(:action => 'Change Password', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      @action.save
      msg = {:username => @user.email, :password => "ok", :status => :ok}
      render :json => msg
    else
      msg = {:status => :internal_server_error}
      render :json => msg, status: :internal_server_error
    end
  else
    msg = {:status => :bad_request}
    render :json => msg, status: :bad_request
  end
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def supporttickets
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user
    render 'tickets'
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def viewticket
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user && Ticket.find_by(:ticket_id => params[:id]).owner == @user.email
    Ticket.where(:ticket_id => params[:id]).pluck(:title, :body, :date, :last_reply).map do |title, body, date, last_reply|
      msg = {:ticket_id => params[:id], :title => title, :body => body, :date => date, :last_reply => last_reply}
      render :json => msg
    end
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def showbills
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user
    render 'billing'
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def viewbill
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user && Billing.find_by(:uuid => params[:id]).owner == @user.email
    Billing.where(:owner => @user.email).pluck(:date_due, :amount, :paid, :description, :transaction_id).map do |date_due, amount, paid, description, transaction_id|
      msg = {:date_due => date_due, :uuid => params[:id], :amount => amount, :paid => paid, :description => description}
      render :json => msg
    end
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def showlogs
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  if @user
    render 'logs'
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
end
end
def createticket
  t = Time.now
  @ip = request.remote_ip
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  json = JSON.parse request.raw_post
  if @user && json["title"].present? && json["body"].present?
    uuid = SecureRandom.uuid
    ticket = Ticket.create(:owner => @user.email, :title => ActionView::Base.full_sanitizer.sanitize(json["title"]), :body => simple_format(json["body"]), :date => t.strftime("%Y-%m-%d"), :last_reply => @user.email, :status => 'Open', :ticket_id => uuid)
    if ticket.save
      @action = Action.create(:action => 'Create Ticket', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      @action.save
      msg = {:ticket_id => uuid, :status => :ok}
      render :json => msg
    end
  else
    msg = {:status => :not_found}
    render :json => msg, status: :not_found
  end
end
def updatestyle
  t = Time.now
  @ip = request.remote_ip
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  json = JSON.parse request.raw_post
  if @user && json["style"].present?
    @user.style = json["style"]
    @user.save
    @action = Action.create(:action => 'Update Style', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
    @action.save
    msg = {:status => :ok}
    render :json => msg
else
  msg = {:status => :not_found}
  render :json => msg, status: :not_found
end
end

def registeruser
  json = JSON.parse request.raw_post
  @user = User.new(:first_name => json["first_name"], :last_name => json["last_name"], :email => json["email"], :password => json["password"], :style => "setup")
  t = Time.now
  @ip = request.remote_ip
  if User.exists?(:email => @user.email)
    msg = {:status => :bad_request}
    render :json => msg, status: :bad_request
    else
    if EmailValidator.valid?(@user.email)
      act_code = SecureRandom.hex(6)
      token = SecureRandom.hex(48)
      token2 = SecureRandom.hex(24)
      @user.activation_code = act_code
      @user.activated = '0'
      @user.token = token2
      @user.original_token = token
      if @user.save
        @action = Action.create(:action => 'Register', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        PostmarkMailer.verify(@user).deliver_now
        msg = {:id => @user.id, :token => @user.token, :email => @user.email, :first_name => @user.first_name, :last_name => @user.last_name, :activated => false, :status => :ok}
        render :json => msg
      else
        msg = {:status => :internal_server_error}
        render :json => msg, status: :internal_server_error
      end
    end
  end
end
def run_accounting
  v = Vm.all.each do |v|
    u = User.find_by_email(v.owner)
    u.hours = u.hours.to_i + 1
    u.save
  end
end
def run_generation
  u = User.all.each do |u|
    unless u.hours == "0" 
      d = Date.today
      p (d+7).to_s
      a = u.hours.to_i*0.01
      if u.hours == "1"
        h = "hour"
      else
        h = "hours"
      end
      b = Billing.new(:owner => u.email, :date_created => Time.now.strftime("%Y-%m-%d"), :date_due => (d+7).to_s, :amount => a.to_s, :paid => "No", :uuid => SecureRandom.uuid, :description => "VPS rental, #{u.hours} #{h}")
      b.save
      u.hours = "0"
      u.save
    end
  end
end
def verify
  t = Time.now
  @ip = request.remote_ip
  @auth = request.headers["Auth"]
  @user = User.find_by_token(@auth)
  json = JSON.parse request.raw_post
  if json["activation_code"] == @user.activation_code
    @user.activated = '1'
    @user.activation_code = nil
    if @user.save
        @action = Action.create(:action => 'Verify Account', :owner => @user.email, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
        @action.save
        msg = {:activated => :ok, :status => :ok}
        render :json => msg
      end
    else
      msg = {:status => :bad_request}
      render :json => msg, status: :bad_request
    end
end
end
