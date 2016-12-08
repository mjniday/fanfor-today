class Matchweek < ApplicationRecord
	has_many :picks
	has_many :fixtures

	enum status: [:pending, :activated, :archived]
	# only one matchweek can be active at a time
	validates_uniqueness_of :status, conditions: -> {where(status: 'activated')}

  def locked?
    Time.now > self.fixtures.pluck(:date).min
  end
end
