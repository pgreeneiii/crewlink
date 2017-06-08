class UpdateUserLibrariesJob < ApplicationJob
  queue_as :default

  def perform
     users = User.all

     users.each do |user|
        user.refresh_library
     end
  end

end
