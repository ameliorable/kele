require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include JSON
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post("/sessions", body: { email: email, password: password })
    raise 'Invalid email or password. Authentication failed.' if response.code == 404
    @auth_token = response['auth_token']
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
end
