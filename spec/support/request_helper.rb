module RequestHelper
  def json
    JSON.parse(response.body)['data']
  end
end
