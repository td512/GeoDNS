class Continent < ApplicationRecord
  has_many :countries

  enum :name, {
    north_america: 0,
    south_america: 1,
    europe: 2,
    asia: 3,
    africa: 4,
    australia: 5,
    antarctica: 6
  }
end
