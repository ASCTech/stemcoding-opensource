require "rails_helper"

describe Course::SignupPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :create? do
  end
end
