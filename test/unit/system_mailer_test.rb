require 'test_helper'

class SystemMailerTest < ActionMailer::TestCase
  test "password_ticket" do
    @expected.subject = 'SystemMailer#password_ticket'
    @expected.body    = read_fixture('password_ticket')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SystemMailer.create_password_ticket(@expected.date).encoded
  end

end
