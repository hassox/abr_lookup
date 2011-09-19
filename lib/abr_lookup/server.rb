require 'rack'
module AbrLookup
  class Server
    attr_reader :match_path
    DEFAULT_PATH = /^\/abn_lookup(\..+)?$/

    def initialize(app, opts={})
      @app = app
      @match_path = opts.fetch(:match_path, DEFAULT_PATH)
    end

    def call(env)
      req = Rack::Request.new env
      if req.path =~ match_path
        lookup = Lookup.new(req.params['abn']).lookup_abn!
        body = lookup.to_json
        status = status_from_lookup(lookup)
        res = Rack::Response.new lookup.to_json, status, 'Content-Type' => 'application/json'
        res.finish
      else
        @app.call(env)
      end
    end

    private
    def status_from_lookup(lookup)
      if lookup.errors.blank?
        200
      else
        if lookup.errors['WebServices'] && lookup.errors['WebServices'].any?{ |err| err =~ /guid/im }
          401
        elsif lookup.errors['Search'] && lookup.errors['Search'].any?{ |err| err =~ /not.+valid/im }
          404
        else 
          400
        end
      end
    end
  end
end
