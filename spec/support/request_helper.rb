# frozen_string_literal: true

module RequestHelper
  def json
    JSON.parse(response.body)
  end

  def stub_current_user_with(user)
    allow_any_instance_of(ApplicationController).to \
      receive(:current_user).and_return(user)
  end
end
