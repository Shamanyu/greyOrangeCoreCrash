# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::GreyOrangeCoreCrash < LogStash::Filters::Base
  config_name "greyOrangeCoreCrash"
  config :keys, :validate => :string

  public
  def register
  end

  public
  def filter(event)
        if event["keys"].is_a?(String)
                field_array = event["keys"].split("\n")
                $array_length=field_array.length
                $counter=0
                custom_event=LogStash::Event:new()
                while $counter < $array_length do
                        field_value=field_array[$counter].split(":")
                        custom_event["host"]=event["tags[0]"]
                        custom_event["tagfield"]="key".concat(($counter+1).to_s)
                        custom_event["service"]="server_crash"
                        custom_event[field_value[0]]=field_value[1]
                        $counter += 1
                end
                filter_matched(custome_event)
                yield custom_event
        end
        event.cancel
  end
end

