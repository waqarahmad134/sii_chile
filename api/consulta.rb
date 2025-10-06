# frozen_string_literal: true

require "multi_json"
require_relative "../gem/lib/sii_chile"

# Vercel Ruby serverless entry for /consulta
# Expects query parameter 'rut'

def handler(event:, context:)
  rut = nil

  # Try to read from AWS Lambda style event payloads
  if event.is_a?(Hash)
    qs_params = event["queryStringParameters"] || event["queryString"] || {}
    if qs_params.is_a?(Hash)
      rut = qs_params["rut"] || qs_params[:rut]
    end

    # Fallback: parse raw query string if provided
    if rut.nil? && event["rawQueryString"].is_a?(String)
      event["rawQueryString"].split("&").each do |pair|
        k, v = pair.split("=", 2)
        if k == "rut"
          rut = v && CGI.unescape(v)
          break
        end
      end
    end
  end

  unless rut && !rut.to_s.strip.empty?
    return {
      statusCode: 400,
      headers: {
        "Content-Type" => "application/json",
        "Access-Control-Allow-Origin" => "*"
      },
      body: MultiJson.dump({ error: "Missing 'rut' query parameter" })
    }
  end

  consulta = SIIChile::Consulta.new(rut)
  resultado = consulta.resultado

  headers = {
    "Content-Type" => "application/json",
    "Access-Control-Allow-Origin" => "*",
    "X-Version" => SIIChile::VERSION
  }

  {
    statusCode: 200,
    headers: headers,
    body: MultiJson.dump(resultado)
  }
end
