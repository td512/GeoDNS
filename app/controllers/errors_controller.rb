class ErrorsController < ApplicationController
  include Gaffe::Errors
  layout 'error'
  def e400
    render "errors/bad_request", code: 400
  end
  def e401
    render "errors/unauthorized", code: 401
  end
  def e403
    render "errors/forbidden", code: 403
  end
  def e404
    render "errors/not_found", code: 404
  end
  def e405
    render "errors/method_not_allowed", code: 405
  end
  def e406
    render "errors/not_acceptable", code: 406
  end
  def e422
    render "errors/unprocessable_entity", code: 422
  end
  def e500
    render "errors/internal_server_error", code: 500
  end
  def e501
    render "errors/not_implemented", code: 501
  end
end
