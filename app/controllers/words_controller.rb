class WordsController < ApplicationController
  def show
    word = Word.find_by(name: params[:name])
    render json: word, include: { definitions: { only: [:content, :group] }}, except: [:created_at, :updated_at]
  end
end
