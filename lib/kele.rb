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

  def get_messages(page == nil)
    if page = nil
      response = self.class.get("/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("/message_threads?page=#{page}", headers: { "authorization" => @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_message(email, recipient_id, token, subject, message)
    response = self.class.post("/messages", body: { sender: email, recipient_id: recipient_id, token: token, subject: subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    @enrollment_id = self.get_me['id']
    response = self.class.post("/checkpoint_submissions", body: { checkpoint_id: checkpoint_id, enrollment_id: @enrollment_id, assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, comment: comment }, heasders: { "authorization" => @auth_token })
  end

end
