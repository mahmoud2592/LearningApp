require 'rails_helper'
RSpec.describe 'LearningPaths API routing', type: :routing do
  it 'routes GET /learning_paths to learning_paths#index' do
    expect(get: '/learning_paths').to route_to('learning_paths#index')
  end

  it 'routes GET /learning_paths/:id to learning_paths#show' do
    expect(get: '/learning_paths/1').to route_to('learning_paths#show', id: '1')
  end

  it 'routes POST /learning_paths to learning_paths#create' do
    expect(post: '/learning_paths').to route_to('learning_paths#create')
  end

  it 'routes PUT /learning_paths/:id to learning_paths#update' do
    expect(put: '/learning_paths/1').to route_to('learning_paths#update', id: '1')
  end

  it 'routes PATCH /learning_paths/:id to learning_paths#update' do
    expect(patch: '/learning_paths/1').to route_to('learning_paths#update', id: '1')
  end

  it 'routes DELETE /learning_paths/:id to learning_paths#destroy' do
    expect(delete: '/learning_paths/1').to route_to('learning_paths#destroy', id: '1')
  end
end
