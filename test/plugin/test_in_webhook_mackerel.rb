require 'helper'
require 'net/http'

class MackerelWebhookInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  PORT = unused_port
  CONFIG = %[
    port #{PORT}
    tag mwebhook
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::WebhookMackerelInput, tag).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    d = create_driver
    assert_equal 'mwebhook', d.instance.tag
    assert_equal PORT, d.instance.port
    assert_equal '/', d.instance.mount
    assert_equal '0.0.0.0', d.instance.bind
  end

  def test_basic
    d = create_driver

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    Fluent::Engine.now = time

    d.expect_emit "mwebhook.alert", time, {
      :event  => 'alert',
      'host'   => {
        'id'  => 'abcabc'
      },
      'alert'  => {
        'url' => 'http://',
      },
    }

    payload = {
      'event'  => 'alert',
      'host'   => {
        'id'  => 'abcabc'
      },
      'alert'  => {
        'url' => 'http://',
      },
    }

    d.run do
      d.expected_emits.each {|tag, time, record|
        res = post("/", payload.to_json)
        assert_equal "204", res.code
      }
    end
  end

  def test_405
    create_driver.run do
      http = Net::HTTP.new("127.0.0.1", PORT)
      req = Net::HTTP::Get.new('/')
      res = http.request(req)

      assert_equal "405", res.code
    end
  end

  def post(path, params, header = {})
    http = Net::HTTP.new("127.0.0.1", PORT)
    req = Net::HTTP::Post.new(path, header)
    if params.is_a?(String)
      req.body = params
    else
      req.set_form_data(params)
    end
    http.request(req)
  end

end
