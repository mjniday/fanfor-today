class Matchweek < ApplicationRecord
	has_many :picks
	has_many :fixtures

	enum status: [:pending, :activated, :locked, :archived]
	# only one matchweek can be active at a time
	validates_uniqueness_of :status, conditions: -> {where(status: 'activated')}
end
