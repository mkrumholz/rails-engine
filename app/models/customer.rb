class Customer < ApplicationRecord
  has_many :invoices, dependent: :nullify
end
