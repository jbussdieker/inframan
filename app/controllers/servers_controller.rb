class ServersController < ApplicationController
  def index
    @servers = Server.all
    @mcollective = Mcollective.all
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(params[:server])
    @server.create
    redirect_to servers_path
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    redirect_to servers_path
  end
end
