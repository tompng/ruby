# frozen_string_literal: false
require 'test/unit'
require "-test-/bignum"

class TestBignum_Div < Test::Unit::TestCase

  SIZEOF_BDIGIT = Bug::Bignum::SIZEOF_BDIGIT
  BITSPERDIG = Bug::Bignum::BITSPERDIG
  BDIGMAX = (1 << BITSPERDIG) - 1

  def test_divrem_normal
    x = (1 << (BITSPERDIG*2)) | (2 << BITSPERDIG) | 3
    y = (1 << BITSPERDIG) | 1
    q = (1 << BITSPERDIG) | 1
    r = 2
    assert_equal([q, r], Bug::Bignum.big_divrem_normal(x, y))
  end

  def test_divrem_newton_raphson
    x = (1 << (BITSPERDIG*2)) | (2 << BITSPERDIG) | 3
    y = (1 << BITSPERDIG) | 1
    q = (1 << BITSPERDIG) | 1
    r = 2
    assert_equal([q, r], Bug::Bignum.big_divrem_newton_raphson(x, y))

    xs = (3..9).each {|i| (1 << (BITSPERDIG * i)) / 3 }
    ys = (1..3).each {|i| (1 << (BITSPERDIG * i)) / 7 }
    xs.each do |x|
      ys.each do |y|
        q, r = Bug::Bignum.big_divrem_newton_raphson(x, y)
        assert_equal(x, q * y + r)
        assert_operator(q, :>=, 0)
        assert_operator(r, :<, y)
      end
    end
    raise 'OK, test is running in CI'
  rescue NotImplementedError
  end

  def test_divrem_gmp
    x = (1 << (BITSPERDIG*2)) | (2 << BITSPERDIG) | 3
    y = (1 << BITSPERDIG) | 1
    q = (1 << BITSPERDIG) | 1
    r = 2
    assert_equal([q, r], Bug::Bignum.big_divrem_gmp(x, y))
  rescue NotImplementedError
  end
end
