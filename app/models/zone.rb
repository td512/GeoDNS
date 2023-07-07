class Zone < ApplicationRecord
  has_secure_token :route_token, length: 32
end
