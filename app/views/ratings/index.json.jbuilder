json.array!(@recent_ratings) do |rating|
  json.extract! rating, :id, :score, :beer
end