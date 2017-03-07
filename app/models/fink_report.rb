class FinkReport < ActiveRecord::Base

  require 'httparty'

  validates_uniqueness_of :url
  validates_presence_of :url
  validate :check_remote

  private

  def check_remote
    return if url.blank?

    remote = HTTParty.head(url)

    if remote.response.code.to_i == 200 && remote.response.header['content-length'].to_i > 0
      errors.add(:url, "Remote target exists and is not empty")
      return false
    else
      return true
    end
  end

end
