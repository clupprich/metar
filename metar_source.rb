require 'json'

class MetarSource < Sinatra::Base

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

end