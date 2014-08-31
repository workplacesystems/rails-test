class Sale < ActiveRecord::Base
  class << self
    def find_secure(id, hashed_password)
      result = where(:id => id, :hashed_password => hashed_password).first
      raise ActiveRecord::RecordNotFound.new("Record not found") unless result.present? and hashed_password.present?
      result
    end
  end
end
