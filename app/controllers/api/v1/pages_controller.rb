# encoding: UTF-8
class Api::V1::PagesController < ApplicationController

	def home
		@groups = Group.all.next.last(6)
		@courses = Course.all.visible
		@instructors = User.instructors
    render json: {groups: @groups, courses: @courses, instructors: @instructors}
	end

	def about
	end

	def contact
	end

	# def testimonials
	# end

	# def certificate
	# end
	#
	private

	# def graduates_count
	# 	@groups_passed =Group.past.inject(0){|sum,group| sum + group.enrollments.enrolled.count } + 700
	# end
end