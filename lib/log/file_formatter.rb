# frozen_string_literal: true

# custom formatter for file output
class Log::FileFormatter < ::Logger::Formatter
  def call(severity, timestamp, _progname, msg)
    formatted_severity = format('%-5s', severity.to_s)
    formatted_time = timestamp.strftime('%Y-%m-%d %H:%M:%S.%L')

    "[#{$PROCESS_ID}] #{formatted_time} #{formatted_severity}| #{msg}\n"
  end
end
