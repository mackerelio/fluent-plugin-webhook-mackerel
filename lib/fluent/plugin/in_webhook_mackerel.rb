require "thread"
require "json"
require 'fluent/input'
require 'fluent/process'

module Fluent
  class WebhookMackerelInput < Input
    include DetachProcessMixin

    Plugin.register_input('webhook_mackerel', self)

    config_param :tag, :string
    config_param :bind, :string, :default => "0.0.0.0"
    config_param :port, :integer, :default => 3838
    config_param :mount, :string, :default => "/"

    def start
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @server.shutdown
      Thread.kill(@thread)
    end

    def run
      @server = WEBrick::HTTPServer.new(
        :BindAddress => @bind,
        :Port => @port,
      )
      $log.debug "Listen on http://#{@bind}:#{@port}#{@mount}"
      @server.mount_proc(@mount) do |req, res|
        begin
          $log.debug req.header

          if req.request_method != "POST"
            res.status = 405
          else
            payload = JSON.parse(req.body)
            process(payload)
            res.status = 204
          end
        rescue => e
          $log.error e.inspect
          $log.error e.backtrace.join("\n")
          res.status = 400
        end
      end
      @server.start
    end

    def process(payload)
      event = payload.delete "event"
      payload[:event] = event
      $log.info "tag: #{@tag.dup}.#{event}, payload:#{payload}"
      Engine.emit("#{@tag.dup}.#{event}", Engine.now, payload)
    end
  end
end
