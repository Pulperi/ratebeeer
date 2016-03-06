json.array!(@active_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :active
  json.url brewery_url(brewery, format: :json)
end
json.array!(@retired_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :active
  json.url brewery_url(brewery, format: :json)
end
