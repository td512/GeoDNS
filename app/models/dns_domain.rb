class DnsDomain < ApplicationRecord
  has_many :dns_records
end
