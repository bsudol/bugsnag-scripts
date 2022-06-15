Bugsnag.configure do |config|
  config.add_on_error(proc do |event|

    params = event.metadata[:request][:params]

    # For each request param, add as its own key value pair so that it can be indexed and searched on individually
    params.each do |key, value|
      event.add_metadata(:request, key, value)
    end

  end)
end