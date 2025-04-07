RSpec.shared_context "pagination parameters", shared_context: :metadata do
  with_options with_example: true do
    parameter :'page[number]', "Page Number", method: :page_number
    parameter :'page[size]', "Page Size", method: :page_size
  end
end

RSpec.shared_context "link parameters", shared_context: :metadata do
  with_options scope: :data, with_example: true do
    parameter :id, "Id", required: true
    parameter :type, "Type", required: true
  end
end

RSpec.shared_context "resource parameters", shared_context: :metadata do
  with_options with_example: true do
    parameter :fields, "Fields"
    parameter :include, "Include", method: :includes
  end
end
