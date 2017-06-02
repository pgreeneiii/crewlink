module MessagesHelper
  def recipients_options
    s = ''
   #  User.all.each do |user|
   current_user.friends.each do |user| # Only friends are recipient option
      s << "<option value='#{user.id}'>#{user.username}</option>"
    end
    s.html_safe
  end
end
