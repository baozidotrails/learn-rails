class Contact < ActiveRecord::Base

  # directive from activerecord-tableless gem
  has_no_table

  column :name, :string
  column :email, :string
  column :content, :string

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :content
  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates_length_of :content, maximum: 500

  def update_spreadsheet
    connection = GoogleDrive.login(Rails.application.secrets.email_provider_username, Rails.application.secrets.email_provider_password)

    # find spreadsheet
    ss = connection.spreadsheet_by_title('Learn-Rails-Example')
    
    # create a spreadsheet for the first time
    if ss.nil?
      ss = connection.create_spreadsheet('Learn-Rails-Example')
    end
    
    ws = ss.worksheets[0]
    last_row = 1 + ws.num_rows
    ws[last_row, 1] = Time.now
    ws[last_row, 2] = self.name
    ws[last_row, 3] = self.email
    ws[last_row, 4] = self.content
    ws.save
  end
end