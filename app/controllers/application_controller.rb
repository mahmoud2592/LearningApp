class ApplicationController < ActionController::Base
  include HttpErrors::Rescuable

  rescue_from HttpErrors::NotFoundError, with: :render_not_found
  rescue_from HttpErrors::UnauthorizedError, with: :render_unauthorized
  rescue_from HttpErrors::ForbiddenError, with: :render_forbidden
  rescue_from HttpErrors::BadRequestError, with: :render_bad_request

  def render_not_found
    render_error_page(status: 404, message: t('http_errors.not_found'))
  end

  def render_unauthorized
    render_error_page(status: 401, message: t('http_errors.unauthorized'))
  end

  def render_forbidden
    render_error_page(status: 403, message: t('http_errors.forbidden'))
  end

  def render_bad_request
    render_error_page(status: 400, message: t('http_errors.bad_request'))
  end

  private

  def render_error_page(status:, message:)
    render file: "#{Rails.root}/public/#{status}.html", layout: false, status: status, locals: { message: message }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
