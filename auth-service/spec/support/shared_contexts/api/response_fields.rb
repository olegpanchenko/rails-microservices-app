RSpec.shared_context "data link response fields", shared_context: :metadata do
  with_options scope: :data do
    response_field :id, "ID"
    response_field :type, "Document Type"
  end
end
