Gibbon::Request.api_key = ENV['MAILCHIMP_API_KEY'] || ('0000a0aa0a0000aaaa0a00000aa00000-us00' if Rails.env.test?)
Gibbon::Request.timeout = 15
Gibbon::Request.open_timeout = 15
Gibbon::Request.symbolize_keys = true
Gibbon::Request.debug = false
