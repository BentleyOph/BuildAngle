class WebsiteRequest < ApplicationRecord
  has_many :generated_pages, dependent: :destroy
end
