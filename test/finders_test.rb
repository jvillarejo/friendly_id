require "helper"

class JournalistWithFriendlyFinders < ActiveRecord::Base
  self.table_name = 'journalists'
  extend FriendlyId
  scope :existing, -> {where('1 = 1')}
  friendly_id :name, use: [:slugged, :finders]
end

class Finders < Minitest::Test

  include FriendlyId::Test

  def model_class
    JournalistWithFriendlyFinders
  end

  test 'should find records with finders as class methods' do
    with_instance_of(model_class) do |record|
      assert model_class.find(record.friendly_id)
    end
  end

  test 'should find records with finders on relations' do
    with_instance_of(model_class) do |record|
      assert model_class.existing.find(record.friendly_id)
    end
  end

  test 'should find record with friendly id' do
    with_instance_of(model_class) do |record|
      assert model_class.find_by_friendly_id(record.friendly_id)
    end
  end

  test 'should raise error when is not found with friendly id' do
    with_instance_of(model_class) do |record|
      assert_raises ActiveRecord::RecordNotFound do 
        model_class.find_by_friendly_id('a-friendly-id')
      end
    end
  end
end
