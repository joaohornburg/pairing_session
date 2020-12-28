class Url < ApplicationRecord
  validates :url, uniqueness: true
end
