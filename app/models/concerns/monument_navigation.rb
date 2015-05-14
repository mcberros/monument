module MonumentNavigation
  extend ActiveSupport::Concern

  included do
    attr_writer :current_step
  end

  def current_step
    @current_step || steps.first
  end

  def first_step?
	  current_step == steps.first
	end

	def last_step?
	  current_step == steps.last
	end

  def next_step
	  self.current_step = steps[steps.index(current_step)+1]
	end

	def previous_step
	  self.current_step = steps[steps.index(current_step)-1]
	end

  def steps
    %w[information picture confirmation]
  end

end