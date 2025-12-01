module RequestHelpers
  def create_and_login_user
    user = create(:user)
    login_as(user)
    user
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
