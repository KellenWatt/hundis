json.extract! problem, :id, :problem_id, :name, :score, :problem_description, :path, :created_at, :updated_at
json.url problem_url(problem, format: :json)
