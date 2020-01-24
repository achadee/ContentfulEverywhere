class WelcomeController < ApplicationController
  def index
    # since we are using barebones rails --api mode we need to manually load a view like this
    render file: Rails.root.join('public', 'index.html')
  end
end
