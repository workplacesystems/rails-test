# A sale
# Each instance represents a sale made
class Sale < ActiveRecord::Base
  class << self
    # @param id [Integer|String] The id of the record to find
    # @param hashed_password [String] The password for the record
    # @returns [Sale] The record found
    # @raises [ActiveRecord::RecordNotFound] If the record is not found
    def find_secure(id, hashed_password)
      result = where(:id => id, :hashed_password => hashed_password).first
      raise ActiveRecord::RecordNotFound.new("Record not found") unless result.present? and hashed_password.present?
      result
    end
  end
end
