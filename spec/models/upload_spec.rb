require "rails_helper"

RSpec.describe Upload, type: :model do
  it { is_expected.to respond_to(:file_name) }
  it { is_expected.to respond_to(:total_lines) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:success_count) }
  it { is_expected.to respond_to(:error_count) }
  it { is_expected.to respond_to(:error_messages) }
end
