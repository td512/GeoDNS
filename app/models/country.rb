class Country < ApplicationRecord
  belongs_to :continent
  belongs_to :hemisphere
  has_many :states
end
