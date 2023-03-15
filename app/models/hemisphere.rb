class Hemisphere < ApplicationRecord
  has_many :countries

  enum :name, {
    north: 0,
    south: 1
  }
end
