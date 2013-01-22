class ServersController < ApplicationController
  def index
    @servers = Server.all
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(params[:server])
    @server.create
    redirect_to servers_path
  end
end
