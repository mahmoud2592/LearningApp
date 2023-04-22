module HttpErrors
  class HttpError < StandardError
    attr_reader :status_code, :message

    def initialize(status_code, message)
      @status_code = status_code
      @message = message
    end
  end

  class NotFoundError < HttpError
    def initialize(message = 'Not Found')
      super(404, message)
    end
  end

  class UnauthorizedError < HttpError
    def initialize(message = 'Unauthorized')
      super(401, message)
    end
  end

  class ForbiddenError < HttpError
    def initialize(message = 'Forbidden')
      super(403, message)
    end
  end

  class BadRequestError < HttpError
    def initialize(message = 'Bad Request')
      super(400, message)
    end
  end
end
