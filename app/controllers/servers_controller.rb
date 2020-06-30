# -*- coding: UTF-8 -*
class Api::V1::ServersController < ActionController::Base
  before_filter :authenticate_request

  rescue_from JWT::DecodeError,      with: :render_invalid_token
  rescue_from JWT::ExpiredSignature, with: :render_expired_token

  def index
    @account = Account.find_by_login(login)

    @servers = Server.where(account_id: @account)
      .not_uninstalled
      .management_by_account
      .paginate(page: page_number,
                per_page: page_size)
    
    render json: @servers.to_json(only: [:title, :cpus, :memory, :transfer, :status], include: [platform: { only: [:name] }])
  end

  def show
    @account = Account.find_by_login(login)

    @server = Server.where(account_id: @account, id: params[:id])
      .not_uninstalled
      .management_by_account
      .first!
    
    render json: @server.to_json(only: [:title, :cpus, :memory, :transfer, :status], include: [platform: { only: [:name] }])
  end

  def render_invalid_token
    render json: { errors: [{ detail: 'Authorization token is invalid' }] },
      status: :bad_request
  end

  def render_expired_token
    render json: { errors: [{ detail: 'Authorization token has expired' }] },
      status: :unauthorized
  end

  private

  def authenticate_request
    token = request.headers['Authorization'].gsub /^Bearer /, ''
    rsa_key = OpenSSL::PKey::RSA.new 'some_public_key'
    payload = JWT.decode token, rsa_key.public_key, true, { algorithm: 'RS256' }
    @login  = payload.first['sub']    
  end

  def page_number
    params.fetch(:page, {}).fetch(:number, nil)
  end

  def page_size
    params.fetch(:page, {}).fetch(:size, nil)
  end
end
