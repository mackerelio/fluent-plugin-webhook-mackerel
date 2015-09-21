# Fluent::Plugin::Webhook::Mackerel

fluentd input plugin for incoming webhook from Mackerel.

## Installation

    $ gem install fluent-plugin-webhook-mackerel

## Usage

```
<source>
  type webhook_mackerel
  tag mackerel

  # optional (values are default)
  bind 0.0.0.0
  port 3838
  mount /
</source>

<match mackerel.*>
  type stdout
</match>

<match mackerel.alert>
  type slack
</match>
```

## Contributing

1. Fork it ( https://github.com/mackerelio/fluent-plugin-webhook-mackerel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
