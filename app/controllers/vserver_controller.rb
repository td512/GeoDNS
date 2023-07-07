class VserverController < ApplicationController
  before_action :require_user
  before_action :check_user
  skip_before_action :verify_authenticity_token
  before_action :check_activated
  def create
    @vserver = Vm.new
  end
  def make
    t = Time.now
    @ip = request.remote_ip
    user = current_user.email
    tmpl = OsTemplate.find_by_name(params[:vm][:os])
    if Vm.maximum(:port).present?
      port = Vm.maximum(:port).to_s
    else
      port = "40888"
    end
    if params[:vm][:hostname].present?
    server = Node.order("RANDOM()").first
    pool = IpPool.where(:owner => server.id).first
    address = Address.where(['used = ? AND belongs_to = ?', '0', pool.range_start.to_s]).order("RANDOM()").pluck(:address).first
    pool.used = pool.used.to_i + 1
    pool.save
    plan = Plan.find_by(:id => params[:vm][:plan])
    req = RestClient.post "http://#{server.ip}/api/v1/create", {"port" => port, "userid" => current_user.id.to_s, "hostname" => params[:vm][:hostname].gsub(/\s+/, '_'), "cpus" => plan.cores, "ram" => plan.memory.to_i, "iso" => tmpl.image_location, "capacity" => plan.hdd+"G"}.to_json, {content_type: :json}
    res = JSON.parse(req.body)
    p res["mac_address"]
    vm = Vm.create(:hostname => params[:vm][:hostname], :os => params[:vm][:os], :ip_address => address, :disk => "#{plan.hdd}GB", :memory => "#{plan.memory}MB", :traffic => "Unlimited", :uuid => res["uuid"], :owner => current_user.email, :port => res["vnc_port"], :ws_port => res["ws_port"], :vnc_pw => res["vnc_pw"], :disk_uuid => res["disk_uuid"], :hv => server.id, :mac => res["mac_address"])
 RestClient.post "http://#{server.ip}/api/v1/add_eb", {"ip" => address, "mac" => res["mac_address"]}.to_json, {content_type: :json}
a = Address.find_by(address: address)
a.used = "1"
a.save
 server.vm_count = server.vm_count.to_i+1
 server.save
 if vm.save
   action = Action.create(:action => 'Create VM', :owner => user, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
   action.save
   redirect_to dash_path
 else
   redirect_to new_vserver_path
 end
 end
  end
  def destroy
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    RestClient.post "http://#{server.ip}/api/v1/destroy/#{params[:id]}", {"owner" => current_user.id, "disk" => vm.disk_uuid}.to_json, {content_type: :json}
    RestClient.post "http://#{server.ip}/api/v1/remove_eb", {"ip" => vm.ip_address, "mac" => vm.mac}.to_json, {content_type: :json}
    a = Address.find_by(address: vm.ip_address)
    a.used = "0"
    a.save
    address = Address.find_by(address: vm.ip_address)
    pool = IpPool.find_by(range_start: address.belongs_to)
    pool.used = pool.used.to_i - 1
    pool.save
    t = Time.now
    ip = request.remote_ip
    user = current_user.email
    action = Action.create(:action => 'Destroy VM', :owner => user, :ip => ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
    action.save
    vm = Vm.find_by(uuid: params[:id])
    vm.delete
    server.vm_count = server.vm_count.to_i - 1
    server.save
    redirect_to dash_path
  end

  def status
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    #req = RestClient.get "http://#{server.ip}/api/v1/status/#{params[:id]}"
    #res = JSON.parse(req.body)
    msg = {:status => "running"} # res["server_status"]}
    render :json => msg
  end
  def startserver
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    req = RestClient.get "http://#{server.ip}/api/v1/power/on/#{params[:id]}"
    res = JSON.parse(req.body)
    vm = Vm.find_by(uuid: params[:id])
    vm.port = res["vm_port"]
    vm.save
  end
  def stopserver
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    req = RestClient.get "http://#{server.ip}/api/v1/power/off/#{params[:id]}"
    res = JSON.parse(req.body)
  end
  def rebootserver
    vm = Vm.find_by(uuid: params[:id])
    server = Node.find_by(id: vm.hv)
    req = RestClient.get "http://#{server.ip}/api/v1/power/reset/#{params[:id]}"
    res = JSON.parse(req.body)
    vm = Vm.find_by(uuid: params[:id])
    vm.port = res["vm_port"]
    vm.save
  end
def changehostname
  if params[:hostname].present?
    t = Time.now
    @ip = request.remote_ip
    user = current_user.email
  @vm = Vm.find_by(uuid: params[:id])
  @vm.hostname = params[:hostname]
  @vm.save
  @action = Action.create(:action => 'Update VM Hostname', :owner => user, :ip => @ip, :date => t.strftime("%Y-%m-%d"), :status => 'Success')
  @action.save
  redirect_to vserver_settings_path
end
end
def swapmedia
  vm = Vm.find_by(uuid: params[:id])
  tmpl = OsTemplate.find_by_name(params[:os_name])
  server = Node.find_by(id: vm.hv)
  req = RestClient.post "http://#{server.ip}/api/v1/swapcd/#{params[:id]}", {"iso" => tmpl.image_location}.to_json, {content_type: :json}
  redirect_to "/vm/#{params[:id]}/media/mounted"
end
end
