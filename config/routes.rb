Rails.application.routes.draw do
  get '/words/:name' => 'words#show' 
end
