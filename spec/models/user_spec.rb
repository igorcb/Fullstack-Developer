require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:full_name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:role) }
  it { is_expected.to respond_to(:password) }
end
