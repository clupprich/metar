require 'json'
require 'csv'

def load_airport_data(filename)
  return CSV.read(filename, encoding: "ISO8859-1").inject({}) { |h, arr| h[arr[5]] = arr; h }
end



class MetarSource < Sinatra::Base

  data = load_airport_data("airports.csv")

  get "/" do
    erb :index
  end
  
  get "/metar/:location" do
    raw = Metar::Raw.new(params[:location])
    parser = Metar::Parser.new(raw)
    report = Metar::Report.new(parser)
    all = report.all
    translated = {}
    all.each do |k, v|
      translated[I18n.t("metar.#{k}.title").capitalize] = v 
    end
    translated.to_json
  end
  
  get "/cccc" do
    name = params[:query].downcase
    halt if name.length < 2
    selected = data.select{ |k,v| k.downcase.start_with?(name) or v[1].downcase.start_with?(name) or v[2].downcase.start_with?(name) or v[3].downcase.start_with?(name) }
    {
      :query       => params[:query],
      :suggestions => selected.inject([]) {|arr, (k,v)| arr << v[2]; arr},
      :data        => selected.inject([]) {|arr, (k,v)| arr << k; arr}
    }.to_json
  end

end