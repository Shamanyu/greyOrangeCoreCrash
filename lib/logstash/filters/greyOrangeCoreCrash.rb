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
                custom_event=LogStash::Event.new()
		custom_event["host"]=event["tags[0]"]
		custom_event["service"]="server_crash"
		custom_event["metric"]=0
		field_array=event["keys"].split("\n")
		report_type = (field_array[0].split(":"))[0]
		custom_event["tagfield"]=report_type
		$array_length=field_array.length
		$counter=1
                while $counter < $array_length do
                        field_value=field_array[$counter].split(":")
                        custom_event[field_value[0]]=field_value[1]
                        $counter += 1
                end
                filter_matched(custom_event)
                yield custom_event
        end
        event.cancel
  end
end

