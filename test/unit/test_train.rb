# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/model/train'

class TestTrain < Minitest::Test
  attr_reader :origin, :destination, :reverse_route_train, :passenger_train, :route

  def setup
    @origin = Struct.new
    @destination = Struct.new

    @passenger_train = Train.make_train('123-11', :passenger)
  end

  def test_initial_train_state
    assert_equal '123-11', passenger_train.number
    assert_equal :passenger, passenger_train.type
    assert_equal 0, passenger_train.carriage_count
    assert_equal 0, passenger_train.speed
    assert_nil passenger_train.route
  end

  def test_train_number_validation_with_only_digits_passed
    assert_equal true, Train.make_train('123-11', :passenger).valid?
    assert_equal true, Train.make_train('12311', :passenger).valid?
  end

  def test_train_number_validation_with_only_letters_passed
    assert_equal true, Train.make_train('abc-ab', :passenger).valid?
    assert_equal true, Train.make_train('abcab', :passenger).valid?
  end

  def test_train_number_validation_with_mixed_chars_passed
    assert_equal true, Train.make_train('abc-12', :passenger).valid?
    assert_equal true, Train.make_train('123-ab', :passenger).valid?
    assert_equal true, Train.make_train('1ab2a', :passenger).valid?
  end

  def test_train_number_validation_with_empty_number_failed
    assert_raises(ValidationError) { Train.make_train('', :passenger) }
  end

  def test_train_number_validation_wrong_length_failed
    assert_raises(ValidationError) { Train.make_train('12', :passenger) }
    assert_raises(ValidationError) { Train.make_train('123-111', :passenger) }
    assert_raises(ValidationError) { Train.make_train('1ab2ab', :passenger) }
  end

  def test_train_number_validation_wrong_chars_failed
    assert_raises(ValidationError) { Train.make_train('123/111', :passenger) }
    assert_raises(ValidationError) { Train.make_train('1аб2а', :passenger) }
  end

  def test_speed_up
    passenger_train.speed_up(10)

    assert_equal 10, passenger_train.speed
  end

  def test_speed_down
    passenger_train.speed_up(10)
    passenger_train.speed_down(5)

    assert_equal 5, passenger_train.speed
  end

  def test_full_stop
    passenger_train.speed_up(10)
    passenger_train.speed_down(15)

    assert_equal 0, passenger_train.speed
  end

  def test_attach_carriage
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '1'))
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '2'))
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '3'))

    assert_equal 3, passenger_train.carriage_count
  end

  def test_attach_carriage_of_wrong_type
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '1'))

    assert_nil passenger_train.attach_carriage(Struct.new(:type, :number).new(:cargo, '2'))
    assert_equal 1, passenger_train.carriage_count
  end

  def test_detach_carriage
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '1'))
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '2'))
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '3'))
    passenger_train.detach_carriage_by_number('2')

    assert_equal 2, passenger_train.carriage_count
  end

  def test_detach_carriage_when_carriage_count_is_zero
    assert_empty passenger_train.detach_carriage_by_number('1')
    assert_equal 0, passenger_train.carriage_count
  end

  def test_carriage_change_while_moving
    passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '1'))
    passenger_train.speed_up(10)

    assert_nil passenger_train.attach_carriage(Struct.new(:type, :number).new(:passenger, '2'))
    assert_nil passenger_train.detach_carriage_by_number('1')
  end

  def test_current_station_without_route
    assert_nil passenger_train.current_station
  end
end
