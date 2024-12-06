require 'date'

class Lab
  attr_reader :name, :topics, :tasks, :date_of_issue
  attr_accessor :id

  #constructor
  def initialize(name:, date_of_issue:, id: nil, topics: nil, tasks: nil)
    self.id = id
    self.name = name
    self.topics = topics
    self.tasks = tasks
    self.date_of_issue = date_of_issue
  end

  #constructor_from_hash
  def self.new_from_hash(hash)
    self.new(**hash.transform_keys(&:to_sym))
  end

  # date of issue validation
  def self.valid_date_of_issue?(date_of_issue)
    valid = (date_of_issue =~ /^\d{2}\.\d{2}\.\d{4}$/)
    begin
      Date.parse(date_of_issue)
    rescue
      valid = false
    end
    valid
  end

  # name validation
  def self.valid_name?(name)
    name.length > 0 && name.length <= 100
  end

  # topics validation
  def self.valid_topics?(topics)
    topics.nil? || topics.length <= 1000
  end

  # tasks validation
  def self.valid_tasks?(tasks)
    tasks.nil? || tasks.length <= 10000
  end

  private

  # date_of_issue setter
  def date_of_issue=(date_of_issue)
    @date_of_issue = date_of_issue.is_a?(String) ? Date.parse(date_of_issue) : date_of_issue
  end

  # name setter
  def name=(name)
    unless self.class.valid_name?(name)
      raise ArgumentError, "Invalid name format"
    end
    @name = name
  end

  # topics setter
  def topics=(topics)
    unless self.class.valid_topics?(topics)
      raise ArgumentError, "Invalid topics format"
    end
    @topics = topics
  end

  # tasks setter
  def tasks=(tasks)
    unless self.class.valid_tasks?(tasks)
      raise ArgumentError, "Invalid tasks format"
    end
    @tasks = tasks
  end
end