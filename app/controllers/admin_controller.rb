class AdminController < ApplicationController
  before_action :require_user
  before_action :check_user
  before_action :check_admin
  before_action :check_activated
  include ActionView::Helpers::TextHelper
  def edit_group
    group = OsCollection.find_by(id: params[:edit][:gid])
    group.name = params[:edit][:name]
    group.url = params[:edit][:fragment]
    group.description = params[:edit][:description]
    if group.save
      redirect_to admin_groups_path
    end
  end
  def destroy_group
    osc = OsCollection.find_by(id: params[:id])
    osc.delete
    redirect_to admin_groups_path
  end
  def create_group
    group = OsCollection.create(:name => params[:create][:name], :url => params[:create][:fragment], :description => params[:create][:description])
    if group.save
      redirect_to admin_groups_path
    end
  end
  def edit_template
    template = OsTemplate.find_by(id: params[:edit][:tid])
    tmpl = OsCollection.find_by(id: params[:edit][:belongs])
    template.name = params[:edit][:name]
    template.image_location = params[:edit][:iso]
    template.belongs_to = tmpl.name
    template.os_image = params[:edit][:image]
    if template.save
      redirect_to admin_templates_path
    end
  end
  def destroy_template
    ost = OsTemplate.find_by(id: params[:id])
    ost.delete
    redirect_to admin_templates_path
  end
  def create_template
    tmpl = OsCollection.find_by(id: params[:create][:belongs])
    template = OsTemplate.create(:name => params[:create][:name], :image_location => params[:create][:iso], :belongs_to => tmpl.name, :os_image => params[:create][:image])
    if template.save
      redirect_to admin_templates_path
    end
  end
  def close_ticket
    t = Ticket.find_by(ticket_id: params[:id])
    t.status = "Closed"
    if t.save
      redirect_to admin_support_path
    end
  end
  def open_ticket
    t = Ticket.find_by(ticket_id: params[:id])
    t.status = "Open"
    if t.save
      redirect_to admin_support_path
    end
  end
  def reply_ticket
    if params[:ticket][:reply].present?
      time = Time.now
      ti = Ticket.find_by(ticket_id: params[:id])
      @t = Ticket.new(:owner => ti.owner, :body => simple_format(params[:ticket][:reply]), :date => time.strftime("%Y-%m-%d"), :last_reply => "Staff", :status => 'Open', :ticket_id => params[:ticket][:num], :ticket_num => ti.ticket_num)
      if @t.save
        action = Action.create(:action => '[ADMINISTRATOR] Update Ticket', :owner => ti.owner, :ip => "HIDDEN", :date => time.strftime("%Y-%m-%d"), :status => 'Success')
        action.save
        PostmarkMailer.support(@t, ti.owner).deliver_now
        redirect_to admin_support_view_path(params[:ticket][:num])
      end
    end
  end
  def create_announcement
      a = Announcement.new(:announcements => params[:create][:announcement])
      if a.save
        redirect_to admin_announcements_path
      end
  end
  def destroy_announcement
    a = Announcement.find_by(id: params[:id])
    a.delete
    redirect_to admin_announcements_path
  end
  def edit_announcement
    a = Announcement.find_by(id: params[:edit][:aid])
    a.announcements = params[:edit][:announcement]
    if a.save
      redirect_to admin_announcements_path
    end
  end
  def edit_user
    t = Time.now
    user = User.find_by_id(params[:user][:userid])
    user.first_name = params[:user][:fname]
    user.last_name = params[:user][:lname]
    user.email = params[:user][:email]
    if user.save
      action = Action.create(:action => '[ADMINISTRATOR] Update Account', :owner => params[:user][:email], :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      action.save
      redirect_to admin_users_path
    end
  end
  def make_user
    t = Time.now
    user = User.find_by(id: params[:id])
    user.level = "0"
    if user.save
      action = Action.create(:action => '[ADMINISTRATOR] Update Account', :owner => user.email, :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      action.save
    end
    redirect_to admin_users_path
  end
  def make_admin
    t = Time.now
    user = User.find_by(id: params[:id])
    user.level = "1"
    if user.save
      action = Action.create(:action => '[ADMINISTRATOR] Update Account', :owner => user.email, :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      action.save
    end
    redirect_to admin_users_path
  end
  def lock_account
    t = Time.now
    user = User.find_by(id: params[:id])
    user.enabled = "0"
    if user.save
      action = Action.create(:action => '[ADMINISTRATOR] Update Account', :owner => user.email, :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      action.save
    end
    redirect_to admin_users_path
  end
  def unlock_account
    t = Time.now
    user = User.find_by(id: params[:id])
    user.enabled = "1"
    if user.save
      action = Action.create(:action => '[ADMINISTRATOR] Update Account', :owner => user.email, :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
      action.save
    end
    redirect_to admin_users_path
  end
  def void_bill
    b = Billing.find_by(uuid: params[:id])
    b.paid = "Yes"
    if b.save
      redirect_to admin_billing_path
    end
  end
  def unvoid_bill
    b = Billing.find_by(uuid: params[:id])
    b.paid = "No"
    if b.save
      redirect_to admin_billing_path
    end
  end
  def destroy
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    RestClient.post "http://#{server.ip}/api/v1/destroy/#{params[:id]}", {"owner" => current_user.id, "disk" => vm}.to_json, {content_type: :json}
    RestClient.post "http://#{server.ip}/api/v1/remove_eb", {"ip" => vm.ip_address, "mac" => vm.mac}.to_json, {content_type: :json}
    t = Time.now
    action = Action.create(:action => '[ADMINISTRATOR] Destroy VM', :owner => Vm.find_by(uuid: params[:id]).owner, :ip => "HIDDEN", :date => t.strftime("%Y-%m-%d"), :status => 'Success')
    action.save
    vm = Vm.find_by(uuid: params[:id])
    a = Address.find_by(address: vm.ip_address)
    a.used = "0"
    a.save
    server.vm_count = server.vm_count.to_i - 1
    server.save
    address = Address.find_by(address: vm.ip_address)
    pool = IpPool.find_by(range_start: address.belongs_to)
    pool.used = pool.used.to_i - 1
    pool.save
    vm.delete
    redirect_to admin_servers_path
  end
  def add_node
    n = Node.new(:name => params[:create][:name], :ip => params[:create][:hostname], :vm_count => '0')
    if n.save
      redirect_to admin_nodes_path
    end
  end
  def destroy_node
    n = Node.find_by(id: params[:id])
    n.delete
    redirect_to admin_nodes_path
  end
  def create_pool
      i = IpPool.new(:name => params[:create][:name], :range_start => params[:create][:start], :range_end => params[:create][:end], :subnet_mask => params[:create][:subnet], :gateway => params[:create][:gateway], :owner => params[:create][:belongs], :used => '0')
      @octets_start = params[:create][:start].split(".")
      octets_end = params[:create][:end].split(".")
      pool_start = @octets_start[3]
      pool_end = octets_end[3]
      (pool_start..pool_end).each do |pool|
        a = Address.new(:address => @octets_start[0]+"."+@octets_start[1]+"."+@octets_start[2]+"."+pool.to_s, :belongs_to => @octets_start[0]+"."+@octets_start[1]+"."+@octets_start[2]+"."+@octets_start[3], :used => '0')
        a.save
      end
      if i.save
        redirect_to admin_pools_path
      end
  end
  def destroy_pool
    i = IpPool.find_by(id: params[:id])
    Address.where(:belongs_to => i.range_start).destroy_all
    i.delete
    redirect_to admin_pools_path
  end
  def create_plan
    pl = Plan.new(:name => params[:create][:name], :cores => params[:create][:cores], :memory => params[:create][:memory], :hdd => params[:create][:hdd], :used => '0')
    if pl.save
      redirect_to admin_plans_path
    end
  end
  def destroy_plan
    pl = Plan.find_by(id: params[:id])
    pl.delete
    redirect_to admin_plans_path
  end
end
