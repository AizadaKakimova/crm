class TeachingHoursIndivid < ApplicationRecord
    belongs_to :instructor, class_name: 'User'
	validates_presence_of :instructor_id, :hours
    scope :from_this_month, lambda { where("created_at > ? AND created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month) }
    scope :from_last_month, lambda {where("created_at > ? and created_at < ?" , Time.now.beginning_of_month - 1.month,Time.now.beginning_of_month)}

    def self.hours_this_month(instructor_id)
        hours = TeachingHoursIndivid.from_this_month.where(instructor_id: instructor_id)
        sum(hours)
    end

    def self.hours_last_month(instructor_id)
        hours = TeachingHoursIndivid.from_last_month.where(instructor_id: instructor_id)
        sum(hours)
    end

    def self.sum(hours)
        total = 0
        hours.each do |hour|
            total = total + hour.hours
        end
        total
    end
end
