RSpec.shared_context "errors response field", shared_context: :metadata do
  response_field :errors, "Errors", type: :array, items: {
    type: :object,
    title: :errors,
    properties: {
      title: {
        type: :string,
        description: "Title"
      },
      detail: {
        type: :string,
        description: "Detail"
      },
      code: {
        type: :string,
        description: "Code"
      },
      status: {
        type: :string,
        description: "Status"
      }
    }
  }
end

RSpec.shared_context "validation errors response field", shared_context: :metadata do
  response_field :errors, "Errors", type: :array, items: {
    type: :object,
    title: :errors,
    properties: {
      title: {
        type: :string,
        description: "Title"
      },
      detail: {
        type: :string,
        description: "Detail"
      },
      code: {
        type: :string,
        description: "Code"
      },
      source: {
        type: :object,
        description: "source",
        properties: {
          pointer: {
            type: :string,
            description: "pointer"
          }
        }
      }
    }
  }
end
