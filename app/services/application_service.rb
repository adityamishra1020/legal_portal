# Base service object class
# Provides common functionality for all services
#
# Usage:
#   class CreateUserService < ApplicationService
#     attr_reader :params
#
#     def initialize(params)
#       @params = params
#     end
#
#     def call
#       user = User.new(params)
#       user.save
#       user
#     end
#   end
#
#   result = CreateUserService.call(name: 'John', email: 'john@example.com')
#   if result.success?
#     puts result.data
#   else
#     puts result.errors
#   end

class ApplicationService
  attr_reader :result

  def initialize(*args)
    @result = ServiceResult.new
    call(*args)
  end

  def call(*args)
    raise NotImplementedError, 'Subclasses must implement #call'
  end

  private

  def success(data = nil)
    @result.success(data)
  end

  def failure(errors)
    @result.failure(errors)
  end

  def with_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
end

# Immutable result object
class ServiceResult
  attr_reader :data, :errors, :message

  def initialize
    @success = false
    @data = nil
    @errors = []
    @message = nil
  end

  def success(data = nil, message = nil)
    @success = true
    @data = data
    @message = message
    self
  end

  def failure(errors, message = nil)
    @success = false
    @errors = Array(errors)
    @message = message
    self
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  def errors?
    @errors.any?
  end

  def to_h
    {
      success: @success,
      data: @data,
      errors: @errors,
      message: @message
    }
  end
end
