module Helpers
  module Controllers
    def json_response
      JSON.parse(response.body)
    end
  end
end
