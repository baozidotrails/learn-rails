class Visitor < ActiveRecord::Base
  has_no_table
  column :email, :string

  validates :email, presence: true, format: { with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }

  def subscribe
    mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
    result = mailchimp.lists.subscribe({
      id: Rails.application.secrets.mailchimp_list_id,
      email: { email: self.email },
      double_optin: false,
      update_existing: true,
      send_welcome: true
    })
  end
end